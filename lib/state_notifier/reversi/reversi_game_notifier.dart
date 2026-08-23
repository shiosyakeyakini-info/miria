/// リバーシ 1 局ぶんの状態。
///
/// サーバーは対局が始まったあと、盤面そのものを一度も送ってこない。流れて
/// くるのは「誰がどこに打ったか」という `log` イベントだけで、盤面は各
/// クライアントが自前のルールエンジンで再現する
/// （`lib/model/reversi/` が本家からの移植）。
///
/// つまりこの Notifier がやっているのは、
///   1. `reversi/show-game` で今までの手を全部もらって盤面を復元し、
///   2. `reversiGame` チャンネルで 1 手ずつ追いかけ、
///   3. `reversi/verify` で自分の盤面がサーバーとずれていないか確かめる
/// の 3 つ。3 番目の照合に使う CRC32 まで移植元と一致しているので、
/// ずれれば即座に検出できる。
library;

import "dart:async";

import "package:miria/model/reversi/reversi_game.dart";
import "package:miria/model/reversi/reversi_serializer.dart";
import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "reversi_game_notifier.g.dart";

/// 対局画面が見ている状態。
///
/// [engine] は可変なので、盤面が動いたことは [revision] の変化で伝える。
/// 盤面を作り直すたびに新しい [ReversiGame] を作る手もあるが、1 手ごとに
/// 全ログを打ち直すことになるので採らない。
class ReversiGameState {
  const ReversiGameState({
    required this.game,
    required this.myUserId,
    required this.engine,
    required this.revision,
    required this.desynced,
    this.reviewIndex,
    this.reviewEngine,
    this.canceled = false,
    this.opponentChangedSettings = false,
    this.turnRemain,
  });

  /// サーバーから来た対局情報。
  final ReversiShowGameResponse game;

  /// 自分のユーザー ID。
  final String myUserId;

  /// 盤面。対局開始前は null。
  final ReversiGame? engine;

  /// 盤面が動いた回数。可変な [engine] の変化を Riverpod に伝えるためのもの。
  final int revision;

  /// 直近の `reversi/verify` でサーバーとずれていると言われたかどうか。
  final bool desynced;

  /// 棋譜を何手目まで進めて見ているか。null なら最新の盤面。
  final int? reviewIndex;

  /// [reviewIndex] 手目までを打ち直した盤面。[reviewIndex] が null なら null。
  ///
  /// [engine] とは別に持つ。対局中の盤面を巻き戻してしまうと、そこへ相手の
  /// 手が届いたときに辻褄が合わなくなる。
  final ReversiGame? reviewEngine;

  /// 開始前に対局が取り消されたかどうか。
  final bool canceled;

  /// 自分が準備完了にしたあとで相手が設定を変えたかどうか。
  ///
  /// 変えられた側の準備完了はサーバーではなくクライアントが外す
  /// （本家も同じ）。黙って外すと理由が分からないので画面に出す。
  final bool opponentChangedSettings;

  /// 手番の残り秒。制限時間が無い対局と、対局中でないときは null。
  ///
  /// サーバーは手番が変わるたびに Redis のキーを張り直すだけで、時間切れを
  /// 自分から検知しない。切れたことは打っている側のクライアントが
  /// `claimTimeIsUp` で申告する（`ReversiService.checkTimeout`）。
  /// つまりこれを持たないと、相手が離席した対局が永久に終わらない。
  final int? turnRemain;

  ReversiGameState copyWith({
    ReversiShowGameResponse? game,
    ReversiGame? engine,
    int? revision,
    bool? desynced,
    bool? canceled,
    bool? opponentChangedSettings,
    int? turnRemain,
  }) => ReversiGameState(
    game: game ?? this.game,
    myUserId: myUserId,
    engine: engine ?? this.engine,
    revision: revision ?? this.revision,
    desynced: desynced ?? this.desynced,
    reviewIndex: reviewIndex,
    reviewEngine: reviewEngine,
    canceled: canceled ?? this.canceled,
    opponentChangedSettings:
        opponentChangedSettings ?? this.opponentChangedSettings,
    turnRemain: turnRemain ?? this.turnRemain,
  );

  /// 棋譜の再生位置を差し替えた状態。[index] が null なら最新に戻る。
  ///
  /// null を渡せる必要があるので [copyWith] とは分けてある。
  ReversiGameState withReview(int? index, ReversiGame? reviewEngine) =>
      ReversiGameState(
        game: game,
        myUserId: myUserId,
        engine: engine,
        revision: revision + 1,
        desynced: desynced,
        reviewIndex: index,
        reviewEngine: reviewEngine,
        canceled: canceled,
        opponentChangedSettings: opponentChangedSettings,
        turnRemain: turnRemain,
      );

  /// 画面に出す盤面。棋譜を見ている間は巻き戻した方。
  ReversiGame? get displayEngine => reviewEngine ?? engine;

  /// 棋譜を見ているかどうか。
  bool get isReviewing => reviewIndex != null;

  /// 打たれた手の総数。
  int get moveCount => game.logs.length;

  /// 打たれた手の一覧。
  List<ReversiLog> get moves => deserializeReversiLogs(game.logs);

  /// 自分が user1 かどうか。
  bool get isUser1 => game.user1Id == myUserId;

  /// 対戦相手。
  UserLite get opponent => isUser1 ? game.user2 : game.user1;

  /// 自分の色。まだ黒白が決まっていなければ null。
  ///
  /// `black` は「どちらのユーザーが黒か」を 1 / 2 で表す。
  ReversiColor? get myColor {
    final black = game.black;
    if (black == null) return null;
    return (isUser1 && black == 1) || (!isUser1 && black == 2)
        ? reversiBlack
        : reversiWhite;
  }

  /// 黒を持っているユーザー。まだ黒白が決まっていなければ null。
  UserLite? get blackUser => switch (game.black) {
    1 => game.user1,
    2 => game.user2,
    _ => null,
  };

  /// 白を持っているユーザー。まだ黒白が決まっていなければ null。
  UserLite? get whiteUser => switch (game.black) {
    1 => game.user2,
    2 => game.user1,
    _ => null,
  };

  /// 自分の手番かどうか。
  bool get isMyTurn => engine?.turn != null && engine?.turn == myColor;

  /// 自分が準備完了にしているかどうか。
  bool get isMyReady => isUser1 ? game.user1Ready : game.user2Ready;

  /// 自分が勝ったかどうか。引き分け・未終了なら null。
  bool? get isWinner {
    if (!game.isEnded) return null;
    final winnerId = game.winnerId;
    if (winnerId == null) return null;
    return winnerId == myUserId;
  }

  /// 盤面を 1 行 1 文字列で表したもの。
  ///
  /// marionette からも読めるように [toJson] にも載せている。盤面は
  /// ウィジェットツリーからは読み取りようがない（マスはただの色付き矩形）
  /// ので、e2e で盤面を確かめる唯一の手段になる。
  List<String> get boardLines {
    final engine = displayEngine;
    if (engine == null) return const [];
    return [
      for (var y = 0; y < engine.mapHeight; y++)
        [
          for (var x = 0; x < engine.mapWidth; x++)
            switch (engine.board[engine.xyToPos(x, y)]) {
              ReversiCell.black => "b",
              ReversiCell.white => "w",
              ReversiCell.empty => "-",
              ReversiCell.none => " ",
            },
        ].join(),
    ];
  }

  /// marionette の `riverpod_read` から読むための表現。
  Map<String, dynamic> toJson() {
    // 盤面まわりは画面に出ているものを載せる。棋譜を見ている間は巻き戻した
    // 盤面が答えでないと、e2e から見えるものと画面が食い違う。
    final engine = displayEngine;
    final turn = engine?.turn;

    return {
      "gameId": game.id,
      "isStarted": game.isStarted,
      "isEnded": game.isEnded,
      "user1": "${game.user1.username}(${game.user1Ready ? "ready" : "-"})",
      "user2": "${game.user2.username}(${game.user2Ready ? "ready" : "-"})",
      "myUserId": myUserId,
      "myColor": switch (myColor) {
        null => null,
        reversiBlack => "black",
        _ => "white",
      },
      "turn": switch (turn) {
        null => null,
        reversiBlack => "black",
        _ => "white",
      },
      "isMyTurn": isMyTurn,
      "blackCount": engine?.blackCount,
      "whiteCount": engine?.whiteCount,
      "puttable": engine == null || turn == null
          ? const <int>[]
          : engine.getPuttablePlaces(turn),
      "board": boardLines,
      // 同期チェックに使う値なので、棋譜を巻き戻していても最新の盤面のもの。
      "crc32": this.engine?.calcCrc32(),
      "desynced": desynced,
      "winnerId": game.winnerId,
      "moveCount": moveCount,
      "reviewIndex": reviewIndex,
      "turnRemain": turnRemain,
      "canceled": canceled,
      "revision": revision,
    };
  }
}

const _uuid = Uuid();

/// 盤面がサーバーとずれていないか確かめる間隔。本家と同じ。
const _verifyInterval = Duration(seconds: 10);

/// 手番の残り時間を減らす間隔。本家と同じ 3 秒刻み。
const _turnTickInterval = Duration(seconds: 3);

/// `started` を取りこぼしていないか確かめる間隔。本家と同じ。
const _startPollInterval = Duration(seconds: 10);

/// 対局情報から盤面を復元する。開始前は盤面を持たない。
ReversiGame? _restore(ReversiShowGameResponse game) {
  if (!game.isStarted) return null;
  return restoreReversiGame(
    map: game.map,
    logs: game.logs,
    isLlotheo: game.isLlotheo,
    canPutEverywhere: game.canPutEverywhere,
    loopedBoard: game.loopedBoard,
  );
}

@Riverpod(dependencies: [misskeyPostContext, accountContext])
class ReversiGameNotifier extends _$ReversiGameNotifier {
  StreamingController? _controller;
  Timer? _verifyTimer;
  Timer? _turnTimer;
  Timer? _startPollTimer;

  @override
  Future<ReversiGameState> build(String gameId) async {
    final misskey = ref.read(misskeyPostContextProvider);
    final myUserId = ref.read(accountContextProvider).postAccount.i.id;

    final game = await misskey.reversi.showGame(
      ReversiShowGameRequest(gameId: gameId),
    );

    final controller = await ref.watch(
      misskeyStreamingProvider(misskey).future,
    );
    _controller = controller;

    final subscription = controller
        .reversiGameStream(gameId: gameId)
        .listen(_onEvent);

    ref.onDispose(() {
      _stopTimers();
      unawaited(subscription.cancel());
      unawaited(controller.removeChannel(gameId));
    });

    _startTimers(game);

    return ReversiGameState(
      game: game,
      myUserId: myUserId,
      engine: _restore(game),
      revision: 0,
      desynced: false,
      turnRemain: game.isStarted && !game.isEnded
          ? game.timeLimitForEachTurn
          : null,
    );
  }

  /// 対局の進み具合に応じて、動かしておくべきタイマーを張り直す。
  void _startTimers(ReversiShowGameResponse game) {
    _stopTimers();
    if (game.isEnded) return;

    if (game.isStarted) {
      // 切断中に相手の手を取りこぼすと、次の手が来るまで気づけない。
      // 定期的に照合して、ずれていたらサーバーの盤面で作り直す。
      _verifyTimer = Timer.periodic(
        _verifyInterval,
        (_) => unawaited(verify()),
      );
      _turnTimer = Timer.periodic(_turnTickInterval, (_) => _tickTurnTimer());
    } else {
      // `started` を取りこぼすと開始に気づけないまま待ち続けることになる。
      _startPollTimer = Timer.periodic(
        _startPollInterval,
        (_) => unawaited(_pollUntilStarted()),
      );
    }
  }

  void _stopTimers() {
    _verifyTimer?.cancel();
    _turnTimer?.cancel();
    _startPollTimer?.cancel();
    _verifyTimer = null;
    _turnTimer = null;
    _startPollTimer = null;
  }

  /// 開始前に `started` を取りこぼしていないか確かめる。
  Future<void> _pollUntilStarted() async {
    final current = state.value;
    if (current == null || current.game.isStarted || current.canceled) return;

    final game = await ref
        .read(misskeyPostContextProvider)
        .reversi
        .showGame(ReversiShowGameRequest(gameId: gameId));

    final latest = state.value;
    if (latest == null || latest.game.isStarted) return;

    _applyGame(latest, game);
  }

  /// 手番の残り時間を減らし、切れたらサーバーへ申告する。
  void _tickTurnTimer() {
    final current = state.value;
    if (current == null) return;
    if (current.game.isEnded || !current.game.isStarted) return;

    final limit = current.game.timeLimitForEachTurn;
    // 0 は無制限。減らすものが無い。
    if (limit <= 0) return;

    final remain = (current.turnRemain ?? limit) - _turnTickInterval.inSeconds;
    final clamped = remain < 0 ? 0 : remain;
    state = AsyncValue.data(current.copyWith(turnRemain: clamped));

    // 申告できるのは対局者だけ。観戦者が送っても弾かれる。
    if (clamped == 0 && current.myColor != null) {
      _controller?.sendChannelMessage(
        id: current.game.id,
        type: "claimTimeIsUp",
      );
    }
  }

  /// 対局情報を差し替え、盤面とタイマーを揃える。
  void _applyGame(ReversiGameState current, ReversiShowGameResponse game) {
    _startTimers(game);
    state = AsyncValue.data(
      current.copyWith(
        game: game,
        engine: _restore(game),
        revision: current.revision + 1,
        // 始まってしまえば設定変更の警告は用済み。
        opponentChangedSettings: false,
        turnRemain: game.isStarted && !game.isEnded
            ? game.timeLimitForEachTurn
            : null,
      ),
    );
  }

  void _onEvent(StreamingResponse response) {
    if (response is! StreamingChannelResponse) return;
    final current = state.value;
    // build() が返る前にイベントが来ると state はまだ空。ここで取りこぼした
    // 手は次の `log` で必ず検出される（欠けた盤面には相手の手が打てないので
    // canPut が落ち、verify が走って作り直される）ので、握り潰してよい。
    if (current == null) return;

    switch (response.body) {
      case ReversiChangeReadyStatesChannelEvent(:final body):
        state = AsyncValue.data(
          current.copyWith(
            game: current.game.copyWith(
              user1Ready: body.user1,
              user2Ready: body.user2,
            ),
          ),
        );

      case ReversiStartedChannelEvent(:final body):
        _applyGame(current, body.game);

      case ReversiLogChannelEvent(:final body):
        // 自分が打った手もここに返ってくる。先読みで盤面を進めていないので、
        // 誰の手かによらずそのまま適用してよい。
        final engine = current.engine;
        if (engine == null) return;
        if (!engine.canPut(body.player, body.pos)) {
          // ここに来たら盤面がサーバーとずれている。verify で拾い直す。
          unawaited(verify());
          return;
        }
        engine.putStone(body.pos);
        state = AsyncValue.data(
          current.copyWith(
            revision: current.revision + 1,
            // 手番が移ったので持ち時間を戻す。サーバーも同じ時点で
            // Redis のタイマーを張り直している。
            turnRemain: current.game.timeLimitForEachTurn,
          ),
        );
        unawaited(verify());

      case ReversiEndedChannelEvent(:final body):
        _applyGame(current, body.game);

      case ReversiUpdateSettingsChannelEvent(:final body):
        _applySettings(current, body);

      case ReversiCanceledChannelEvent(:final body):
        _stopTimers();
        state = AsyncValue.data(
          current.copyWith(
            game: current.game.copyWith(isEnded: true),
            // 自分が取り消したときは画面側で既に離れているので出さない。
            canceled: body.userId != current.myUserId,
          ),
        );

      default:
        break;
    }
  }

  /// 相手が変えた設定を取り込む。
  ///
  /// 準備完了のあとに変えられたら、こちらの準備完了を外す。サーバーは
  /// 外してくれないので、黙って知らない設定で始まらないようにする
  /// （本家も同じ扱い）。
  void _applySettings(ReversiGameState current, ReversiUpdateSettings body) {
    if (body.userId == current.myUserId) return;

    final game = switch (body.key) {
      "map" => current.game.copyWith(map: (body.value! as List).cast<String>()),
      "bw" => current.game.copyWith(bw: body.value! as String),
      "isLlotheo" => current.game.copyWith(isLlotheo: body.value! as bool),
      "canPutEverywhere" => current.game.copyWith(
        canPutEverywhere: body.value! as bool,
      ),
      "loopedBoard" => current.game.copyWith(loopedBoard: body.value! as bool),
      "timeLimitForEachTurn" => current.game.copyWith(
        timeLimitForEachTurn: (body.value! as num).toInt(),
      ),
      _ => null,
    };
    if (game == null) return;

    final wasReady = current.isMyReady;
    state = AsyncValue.data(
      current.copyWith(game: game, opponentChangedSettings: wasReady),
    );
    if (wasReady) ready(value: false);
  }

  /// 対局前の設定を変える。準備完了のあとは変えられない（サーバーが弾く）。
  void updateSettings(String key, Object? value) {
    final current = state.value;
    if (current == null) return;
    _controller?.sendChannelMessage(
      id: current.game.id,
      type: "updateSettings",
      body: {"key": key, "value": value},
    );

    // サーバーは送り主に updateSettings を返さないので、自分の分は自分で反映する。
    final game = switch (key) {
      "map" => current.game.copyWith(map: (value! as List).cast<String>()),
      "bw" => current.game.copyWith(bw: value! as String),
      "isLlotheo" => current.game.copyWith(isLlotheo: value! as bool),
      "canPutEverywhere" => current.game.copyWith(
        canPutEverywhere: value! as bool,
      ),
      "loopedBoard" => current.game.copyWith(loopedBoard: value! as bool),
      "timeLimitForEachTurn" => current.game.copyWith(
        timeLimitForEachTurn: (value! as num).toInt(),
      ),
      _ => null,
    };
    if (game == null) return;
    state = AsyncValue.data(current.copyWith(game: game));
  }

  /// 開始前の対局を取り消す。対局はサーバーから消える。
  void cancelGame() {
    final current = state.value;
    if (current == null) return;
    _controller?.sendChannelMessage(id: current.game.id, type: "cancel");
  }

  /// 準備完了を切り替える。両者が完了すると 3 秒後に対局が始まる。
  void ready({required bool value}) {
    _controller?.sendChannelMessage(
      id: state.value?.game.id ?? gameId,
      type: "ready",
      // サーバーは `typeof body !== 'boolean'` で弾くので、真偽値を直に送る。
      body: value,
    );
  }

  /// 石を打つ。
  ///
  /// 打てるかどうかは移植したエンジンで判定する。サーバーも同じ判定をして
  /// いるので、ここで弾かれる手は送っても無視される。
  void putStone(int pos) {
    final current = state.value;
    final engine = current?.engine;
    final myColor = current?.myColor;
    if (current == null || engine == null || myColor == null) return;
    if (engine.turn != myColor) return;
    if (!engine.canPut(myColor, pos)) return;

    _controller?.sendChannelMessage(
      id: current.game.id,
      type: "putStone",
      body: {"pos": pos, "id": _uuid.v4()},
    );
  }

  /// 棋譜を [index] 手目まで進めた盤面を見る。null を渡すと最新に戻る。
  ///
  /// 巻き戻しは [ReversiGame.undo] ではなくログの打ち直しで作る。undo は
  /// このセッションで打った手しか戻せないので、後から開いた対局には使えない。
  /// 1 局はせいぜい 60 手なので、毎回作り直しても支障はない。
  void review(int? index) {
    final current = state.value;
    if (current == null) return;

    if (index == null) {
      state = AsyncValue.data(current.withReview(null, null));
      return;
    }

    final clamped = index.clamp(0, current.moveCount);
    state = AsyncValue.data(
      current.withReview(
        clamped,
        restoreReversiGame(
          map: current.game.map,
          logs: current.game.logs.sublist(0, clamped),
          isLlotheo: current.game.isLlotheo,
          canPutEverywhere: current.game.canPutEverywhere,
          loopedBoard: current.game.loopedBoard,
        ),
      ),
    );
  }

  /// 棋譜の再生位置を [delta] だけ動かす。まだ見ていなければ最終手から。
  void reviewBy(int delta) {
    final current = state.value;
    if (current == null) return;
    review((current.reviewIndex ?? current.moveCount) + delta);
  }

  /// 投了する。
  Future<void> surrender() async {
    final current = state.value;
    if (current == null) return;
    await ref
        .read(misskeyPostContextProvider)
        .reversi
        .surrender(ReversiSurrenderRequest(gameId: current.game.id));
  }

  /// 自分の盤面がサーバーとずれていないか確かめ、ずれていたら作り直す。
  ///
  /// 突き合わせるのは移植したエンジンが計算した CRC32。ここが通るという
  /// ことは、盤面も手番も本家と 1 ビットも違わないということ。
  Future<void> verify() async {
    final current = state.value;
    final engine = current?.engine;
    if (current == null || engine == null) return;

    final result = await ref
        .read(misskeyPostContextProvider)
        .reversi
        .verify(
          ReversiVerifyRequest(
            gameId: current.game.id,
            crc32: engine.calcCrc32().toString(),
          ),
        );

    final latest = state.value;
    if (latest == null) return;

    if (!result.desynced) {
      if (latest.desynced) {
        state = AsyncValue.data(latest.copyWith(desynced: false));
      }
      return;
    }

    // desynced のときサーバーは正しい対局情報を必ず添えてくるが、
    // 万一無ければ今の盤面を保ったまま印だけ立てる。
    final game = result.game;
    if (game != null) _startTimers(game);
    state = AsyncValue.data(
      latest.copyWith(
        game: game,
        engine: game == null ? null : _restore(game),
        revision: latest.revision + 1,
        desynced: true,
      ),
    );
  }
}
