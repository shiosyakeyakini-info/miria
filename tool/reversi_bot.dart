/// リバーシの e2e 用、対戦相手を務めるボット。
///
/// marionette から動かせるのは miria 1 つだけなので、オンライン対局を
/// 端から端まで通すには「相手」を別に用意しないといけない。これがそれ。
///
/// ブラウザの Misskey を人が操作する代わりに、同じストリーミング API を
/// 素の Dart から叩いている。miria 本体と同じ [ReversiGame]（本家からの
/// 移植）で合法手を選ぶので、ボット側の盤面が miria 側とずれていないことも
/// ついでに確かめられる。
///
/// ```
/// fvm dart run tool/reversi_bot.dart --token <トークン> --target miria
/// ```
///
/// 既定では 1 局打ち終えたら終了する。`--wait-only` を付けると招待を出さず、
/// 相手からの招待を待つだけになる。
library;

import "dart:async";
import "dart:io";

import "package:miria/model/reversi/reversi_game.dart";
import "package:miria/model/reversi/reversi_serializer.dart";
import "package:misskey_dart/misskey_dart.dart";

const _defaultHost = "localhost:3000";

void main(List<String> args) async {
  final options = _Options.parse(args);
  if (options == null) {
    stderr.writeln(
      "usage: dart run tool/reversi_bot.dart --token <token> "
      "[--target <username>] [--host localhost:3000] [--wait-only]",
    );
    exitCode = 64;
    return;
  }

  final bot = _ReversiBot(options);
  await bot.run();
}

class _Options {
  const _Options({
    required this.token,
    required this.host,
    required this.target,
    required this.waitOnly,
  });

  final String token;
  final String host;
  final String? target;
  final bool waitOnly;

  static _Options? parse(List<String> args) {
    String? token;
    String? target;
    var host = _defaultHost;
    var waitOnly = false;

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case "--token":
          token = args.elementAtOrNull(++i);
        case "--target":
          target = args.elementAtOrNull(++i);
        case "--host":
          host = args.elementAtOrNull(++i) ?? _defaultHost;
        case "--wait-only":
          waitOnly = true;
      }
    }

    if (token == null) return null;
    return _Options(
      token: token,
      host: host,
      target: target,
      waitOnly: waitOnly,
    );
  }
}

class _ReversiBot {
  _ReversiBot(this.options);

  final _Options options;

  late final Misskey misskey = Misskey(
    token: options.token,
    host: options.host,
    // ローカルの検証環境は平文 HTTP なので明示する。
    apiUrl: "http://${options.host}/api/",
    streamingUrl: "ws://${options.host}/streaming/",
    socketConnectionTimeout: const Duration(seconds: 20),
  );

  late final StreamingController controller;
  late final String myUserId;

  final _finished = Completer<void>();
  String? _gameId;
  ReversiGame? _engine;
  ReversiColor? _myColor;
  StreamSubscription<StreamingResponse>? _gameSubscription;

  Future<void> run() async {
    final me = await misskey.i.i();
    myUserId = me.id;
    _log("ログインした: @${me.username} (${me.id})");

    controller = await misskey.streamingService.stream();
    controller.reversiStream(id: "reversi").listen(_onMatchingEvent);

    // 相手が先に招待をくれている場合もあるので、まず招待箱を見る。
    final invitations = await misskey.reversi.invitations();
    for (final user in invitations) {
      _log("招待が来ていた: @${user.username}");
      final game = await misskey.reversi.match(
        ReversiMatchRequest(userId: user.id),
      );
      if (game != null) {
        await _enterGame(game);
        break;
      }
    }

    if (_gameId == null && !options.waitOnly) {
      final target = options.target;
      if (target == null) {
        _log("相手が指定されていないので、誰でもよいマッチングに並ぶ");
        final game = await misskey.reversi.match(const ReversiMatchRequest());
        if (game != null) await _enterGame(game);
      } else {
        final user = await misskey.users.showByName(
          UsersShowByUserNameRequest(userName: target),
        );
        // 招待はサーバー側で 20 秒しか生きない
        // (ReversiService の INVITATION_TIMEOUT_MS)。人が画面を開いて
        // タップするには短すぎるので、マッチするまで出し直し続ける。
        Timer.periodic(const Duration(seconds: 10), (timer) async {
          if (_gameId != null) {
            timer.cancel();
            return;
          }
          _log("@$target を招待する");
          final game = await misskey.reversi.match(
            ReversiMatchRequest(userId: user.id),
          );
          // null なら招待を出しただけ。相手が応じると matched が飛んでくる。
          if (game != null) {
            timer.cancel();
            await _enterGame(game);
          }
        });
        _log("@$target を招待する");
        final game = await misskey.reversi.match(
          ReversiMatchRequest(userId: user.id),
        );
        if (game != null) await _enterGame(game);
      }
    }

    await _finished.future;
    await _gameSubscription?.cancel();
    exit(0);
  }

  void _onMatchingEvent(StreamingResponse response) {
    if (response is! StreamingChannelResponse) return;
    switch (response.body) {
      case ReversiInvitedChannelEvent(:final body):
        _log("招待された: @${body.user.username}");
        unawaited(() async {
          final game = await misskey.reversi.match(
            ReversiMatchRequest(userId: body.user.id),
          );
          if (game != null) await _enterGame(game);
        }());

      case ReversiMatchedChannelEvent(:final body):
        _log("マッチした");
        unawaited(_enterGame(body.game));

      default:
        break;
    }
  }

  /// 対局チャンネルに入り、準備完了を送る。
  Future<void> _enterGame(ReversiShowGameResponse game) async {
    if (_gameId != null) return;
    _gameId = game.id;
    _log(
      "対局に入る: ${game.id} (@${game.user1.username} vs @${game.user2.username})",
    );

    _gameSubscription = controller
        .reversiGameStream(gameId: game.id)
        .listen(_onGameEvent);

    _apply(game);

    // ストリームの接続要求が届く前に ready を送ると取りこぼすので、少し待つ。
    await Future<void>.delayed(const Duration(milliseconds: 500));
    controller.sendChannelMessage(id: game.id, type: "ready", body: true);
    _log("準備完了を送った");
  }

  void _onGameEvent(StreamingResponse response) {
    if (response is! StreamingChannelResponse) return;

    switch (response.body) {
      case ReversiChangeReadyStatesChannelEvent(:final body):
        _log("準備状況: user1=${body.user1} user2=${body.user2}");

      case ReversiStartedChannelEvent(:final body):
        _log("対局開始");
        _apply(body.game);
        _playIfMyTurn();

      case ReversiLogChannelEvent(:final body):
        final engine = _engine;
        if (engine == null) return;
        engine.putStone(body.pos);
        _log(
          "${body.player ? "黒" : "白"} が ${body.pos} に打った "
          "(黒${engine.blackCount} 白${engine.whiteCount})",
        );
        _playIfMyTurn();

      case ReversiEndedChannelEvent(:final body):
        final winner = body.winnerId;
        _log(
          winner == null
              ? "引き分けで終了"
              : winner == myUserId
              ? "ボットの勝ちで終了"
              : "ボットの負けで終了",
        );
        if (!_finished.isCompleted) _finished.complete();

      case ReversiCanceledChannelEvent():
        _log("対局が取り消された");
        if (!_finished.isCompleted) _finished.complete();

      default:
        break;
    }
  }

  /// 対局情報から盤面と自分の色を作り直す。
  void _apply(ReversiShowGameResponse game) {
    final black = game.black;
    if (black == null) return;

    final isUser1 = game.user1Id == myUserId;
    _myColor = (isUser1 && black == 1) || (!isUser1 && black == 2)
        ? reversiBlack
        : reversiWhite;
    _engine = restoreReversiGame(
      map: game.map,
      logs: game.logs,
      isLlotheo: game.isLlotheo,
      canPutEverywhere: game.canPutEverywhere,
      loopedBoard: game.loopedBoard,
    );
    _log("自分の色: ${_myColor! ? "黒" : "白"}");
  }

  /// 自分の手番なら 1 手打つ。
  ///
  /// 手の選び方は「置ける中でいちばん小さい番号」。e2e を何度回しても同じ
  /// 進行になるように、わざと決定的にしてある。
  void _playIfMyTurn() {
    final engine = _engine;
    final myColor = _myColor;
    final gameId = _gameId;
    if (engine == null || myColor == null || gameId == null) return;
    if (engine.turn != myColor) return;

    final places = engine.getPuttablePlaces(myColor);
    if (places.isEmpty) return;

    // 人が打つのと同じくらいの間を空ける。連打するとサーバー側の
    // ターンタイマー更新と競合して読みにくくなる。
    Timer(const Duration(milliseconds: 600), () {
      controller.sendChannelMessage(
        id: gameId,
        type: "putStone",
        body: {
          "pos": places.first,
          "id": "bot-${DateTime.now().microsecondsSinceEpoch}",
        },
      );
      _log("${places.first} に打つ");
    });
  }

  void _log(String message) =>
      stdout.writeln("[bot] ${DateTime.now().toIso8601String()} $message");
}
