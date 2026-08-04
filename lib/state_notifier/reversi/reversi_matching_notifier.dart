/// リバーシのマッチング画面の状態。
///
/// Misskey のマッチングは「招待を Redis に積む」だけの片方向で、成立の
/// 通知は `reversi` チャンネルの `matched` で返ってくる。`reversi/match` の
/// 戻り値が null でも失敗ではなく、招待を出して待っている状態を意味する。
///
/// 積んだ招待はサーバー側で 20 秒（`ReversiService` の
/// `INVITATION_TIMEOUT_MS`）、誰でもマッチングの待ち行列は 15 秒で消える。
/// だから待っている間は投げっぱなしにできず、本家と同じく数秒おきに
/// `reversi/match` を投げ直し続ける必要がある。
library;

import "dart:async";

import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "reversi_matching_notifier.g.dart";

/// 待っている間に `reversi/match` を投げ直す間隔。
///
/// サーバー側の期限は招待 20 秒・待ち行列 15 秒なので、それより十分短く取る。
/// 本家も 5 秒。
const _matchHeartbeatInterval = Duration(seconds: 5);

class ReversiMatchingState {
  const ReversiMatchingState({
    required this.invitations,
    required this.games,
    required this.matchingAny,
    this.matchingUser,
    this.noIrregularRules = false,
    this.matchedGameId,
  });

  /// 自分を招待しているユーザー。
  final List<User> invitations;

  /// 自分が関わっている対局。
  final List<ReversiGamesResponse> games;

  /// 誰でもよいマッチングで相手を待っているかどうか。
  final bool matchingAny;

  /// 招待を出して返事を待っている相手。
  final User? matchingUser;

  /// 誰でもよいマッチングで、変則ルールなしの相手だけを希望するかどうか。
  final bool noIrregularRules;

  /// マッチが成立した対局。画面はこれを見て対局画面へ移る。
  final String? matchedGameId;

  /// 相手を待っているかどうか。
  bool get isMatching => matchingAny || matchingUser != null;

  ReversiMatchingState copyWith({
    List<User>? invitations,
    List<ReversiGamesResponse>? games,
    bool? matchingAny,
    bool? noIrregularRules,
    String? matchedGameId,
  }) => ReversiMatchingState(
    invitations: invitations ?? this.invitations,
    games: games ?? this.games,
    matchingAny: matchingAny ?? this.matchingAny,
    matchingUser: matchingUser,
    noIrregularRules: noIrregularRules ?? this.noIrregularRules,
    matchedGameId: matchedGameId ?? this.matchedGameId,
  );

  /// 待ち状態を差し替えた状態。
  ///
  /// [matchingUser] と [matchedGameId] は null を入れ直せる必要があるので
  /// [copyWith] とは分けてある。
  ReversiMatchingState withMatching({
    required bool matchingAny,
    required User? matchingUser,
    String? matchedGameId,
  }) => ReversiMatchingState(
    invitations: invitations,
    games: games,
    matchingAny: matchingAny,
    matchingUser: matchingUser,
    noIrregularRules: noIrregularRules,
    matchedGameId: matchedGameId,
  );

  /// marionette の `riverpod_read` から読むための表現。
  Map<String, dynamic> toJson() => {
    "invitations": invitations.map((e) => e.username).toList(),
    "games": games
        .map((e) => "${e.id}:${e.isEnded ? "ended" : "playing"}")
        .toList(),
    "matchingAny": matchingAny,
    "matchingUser": matchingUser?.username,
    "noIrregularRules": noIrregularRules,
    "matchedGameId": matchedGameId,
  };
}

@Riverpod(dependencies: [misskeyPostContext])
class ReversiMatchingNotifier extends _$ReversiMatchingNotifier {
  Timer? _heartbeat;

  @override
  Future<ReversiMatchingState> build() async {
    final misskey = ref.read(misskeyPostContextProvider);

    final controller = await ref.watch(
      misskeyStreamingProvider(misskey).future,
    );
    const channelId = "reversi";
    final subscription = controller
        .reversiStream(id: channelId)
        .listen(_onEvent);

    ref.onDispose(() {
      _heartbeat?.cancel();
      // 画面を離れたら募集も畳む。放っておくと、戻ってくるつもりのない
      // 対局に相手が引っかかる。
      unawaited(_cancelOnServer(misskey, state.value));
      unawaited(subscription.cancel());
      unawaited(controller.removeChannel(channelId));
    });

    final results = await Future.wait([
      misskey.reversi.invitations(),
      misskey.reversi.show(const ReversiGamesRequest(my: true, limit: 20)),
    ]);

    return ReversiMatchingState(
      invitations: (results[0] as Iterable<User>).toList(),
      games: (results[1] as Iterable<ReversiGamesResponse>).toList(),
      matchingAny: false,
    );
  }

  void _onEvent(StreamingResponse response) {
    if (response is! StreamingChannelResponse) return;
    final current = state.value;
    if (current == null) return;

    switch (response.body) {
      case ReversiInvitedChannelEvent(:final body):
        if (current.invitations.any((e) => e.id == body.user.id)) return;
        state = AsyncValue.data(
          current.copyWith(invitations: [body.user, ...current.invitations]),
        );

      case ReversiMatchedChannelEvent(:final body):
        _matched(body.game.id);

      default:
        break;
    }
  }

  void _matched(String gameId) {
    _heartbeat?.cancel();
    _heartbeat = null;
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.withMatching(
        matchingAny: false,
        matchingUser: null,
        matchedGameId: gameId,
      ),
    );
  }

  /// 待っている間、期限が切れないように `reversi/match` を投げ直す。
  void _startHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(_matchHeartbeatInterval, (_) {
      unawaited(_beat());
    });
  }

  Future<void> _beat() async {
    final current = state.value;
    if (current == null || !current.isMatching) {
      _heartbeat?.cancel();
      _heartbeat = null;
      return;
    }

    final game = await ref
        .read(misskeyPostContextProvider)
        .reversi
        .match(
          ReversiMatchRequest(
            userId: current.matchingUser?.id,
            noIrregularRules: current.matchingUser == null
                ? current.noIrregularRules
                : null,
          ),
        );

    // 相手が先に応じていれば、ここで対局が返ってくる。
    if (game != null) _matched(game.id);
  }

  /// 誰でもよいマッチングを始める。
  ///
  /// 待っている相手がいればその場で対局が返り、いなければ待ち行列に並ぶ。
  /// 並んだだけのときは [_startHeartbeat] が期限を延ばし続ける。
  Future<void> matchAnyone({bool noIrregularRules = false}) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(
      ReversiMatchingState(
        invitations: current.invitations,
        games: current.games,
        matchingAny: true,
        noIrregularRules: noIrregularRules,
      ),
    );
    _startHeartbeat();

    final game = await ref
        .read(misskeyPostContextProvider)
        .reversi
        .match(ReversiMatchRequest(noIrregularRules: noIrregularRules));

    if (game != null) _matched(game.id);
  }

  /// 特定のユーザーを対局に誘う。
  Future<void> invite(User user) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(
      current.withMatching(matchingAny: false, matchingUser: user),
    );
    _startHeartbeat();

    final game = await ref
        .read(misskeyPostContextProvider)
        .reversi
        .match(ReversiMatchRequest(userId: user.id));

    if (game != null) _matched(game.id);
  }

  /// マッチングをやめる。
  Future<void> cancelMatching() async {
    _heartbeat?.cancel();
    _heartbeat = null;

    final current = state.value;
    if (current == null) return;

    await _cancelOnServer(ref.read(misskeyPostContextProvider), current);

    final latest = state.value;
    if (latest == null) return;
    state = AsyncValue.data(
      latest.withMatching(matchingAny: false, matchingUser: null),
    );
  }

  Future<void> _cancelOnServer(
    Misskey misskey,
    ReversiMatchingState? current,
  ) async {
    if (current == null || !current.isMatching) return;
    // userId を渡すとその相手への招待、null なら待ち行列の取り消しになる。
    await misskey.reversi.cancelMatch(
      ReversiCancelMatchRequest(userId: current.matchingUser?.id),
    );
  }

  /// 招待に応じる。相手の招待が生きていればその場で対局が始まる。
  ///
  /// null が返るのは相手の招待が既に切れていたとき。招待はサーバー側で
  /// 20 秒しか保たないので、一覧に見えていても切れていることがある。
  Future<bool> accept(String userId) async {
    final game = await ref
        .read(misskeyPostContextProvider)
        .reversi
        .match(ReversiMatchRequest(userId: userId));

    final current = state.value;
    if (current == null) return false;

    if (game == null) {
      // 切れた招待を一覧に残しておくと、押しても何も起きない行になる。
      state = AsyncValue.data(
        current.copyWith(
          invitations: current.invitations
              .where((e) => e.id != userId)
              .toList(),
        ),
      );
      return false;
    }

    state = AsyncValue.data(
      current.copyWith(
        invitations: current.invitations.where((e) => e.id != userId).toList(),
        matchedGameId: game.id,
      ),
    );
    return true;
  }

  /// 対局画面へ移ったあと、同じ対局へ二度飛ばないように印を消す。
  void consumeMatched() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.withMatching(
        matchingAny: current.matchingAny,
        matchingUser: current.matchingUser,
      ),
    );
  }
}
