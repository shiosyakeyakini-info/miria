/// 進行中の対局の盤面を、移植したエンジンで復元して表示する。
///
/// e2e で miria を marionette から操作するとき、「次にどのマスを押せばいいか」
/// を知る手段が要る。盤面はウィジェットツリーからは読めず（マスはただの
/// 矩形）、Riverpod の状態も `AccountContextScope` が挟む子 [ProviderScope]
/// の中にあるので `riverpod_read` からも見えない。
///
/// ここではサーバーの `reversi/show-game` からログを取り、miria 本体と同じ
/// [ReversiGame] で盤面を組み直している。miria の中で動いているのと同じ
/// 実装なので、これが出す着手可能マスは miria が受け付けるマスと一致する。
///
/// ```
/// fvm dart run tool/reversi_show.dart --token <トークン> --game <gameId>
/// ```
library;

import "dart:io";

import "package:miria/model/reversi/reversi_game.dart";
import "package:miria/model/reversi/reversi_serializer.dart";
import "package:misskey_dart/misskey_dart.dart";

void main(List<String> args) async {
  String? token;
  String? gameId;
  var host = "localhost:3000";

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case "--token":
        token = args.elementAtOrNull(++i);
      case "--game":
        gameId = args.elementAtOrNull(++i);
      case "--host":
        host = args.elementAtOrNull(++i) ?? host;
    }
  }

  if (token == null || gameId == null) {
    stderr.writeln(
      "usage: dart run tool/reversi_show.dart --token <token> "
      "--game <gameId> [--host localhost:3000]",
    );
    exitCode = 64;
    return;
  }

  final misskey = Misskey(
    token: token,
    host: host,
    apiUrl: "http://$host/api/",
  );

  final game = await misskey.reversi.showGame(
    ReversiShowGameRequest(gameId: gameId),
  );

  final engine = restoreReversiGame(
    map: game.map,
    logs: game.logs,
    isLlotheo: game.isLlotheo,
    canPutEverywhere: game.canPutEverywhere,
    loopedBoard: game.loopedBoard,
  );

  final black = game.black;
  final user1IsBlack = black == 1;
  stdout
    ..writeln("game     : ${game.id}")
    ..writeln(
      "players  : @${game.user1.username}"
      "(${user1IsBlack ? "黒" : "白"}) vs @${game.user2.username}"
      "(${user1IsBlack ? "白" : "黒"})",
    )
    ..writeln("started  : ${game.isStarted}  ended: ${game.isEnded}")
    ..writeln("moves    : ${game.logs.length}")
    ..writeln(
      "turn     : ${switch (engine.turn) {
        null => "(終了)",
        reversiBlack => "黒",
        _ => "白",
      }}",
    )
    ..writeln("score    : 黒 ${engine.blackCount} - 白 ${engine.whiteCount}")
    ..writeln("crc32    : ${engine.calcCrc32()}");

  for (var y = 0; y < engine.mapHeight; y++) {
    final row = StringBuffer("${y.toString().padLeft(2)} ");
    for (var x = 0; x < engine.mapWidth; x++) {
      row.write(switch (engine.board[engine.xyToPos(x, y)]) {
        ReversiCell.black => "● ",
        ReversiCell.white => "○ ",
        ReversiCell.empty => ". ",
        ReversiCell.none => "  ",
      });
    }
    stdout.writeln(row);
  }

  final turn = engine.turn;
  if (turn != null) {
    stdout.writeln("puttable : ${engine.getPuttablePlaces(turn).join(", ")}");
  }

  // サーバーと一致しているかその場で確かめる。
  final verified = await misskey.reversi.verify(
    ReversiVerifyRequest(gameId: game.id, crc32: engine.calcCrc32().toString()),
  );
  stdout.writeln("desynced : ${verified.desynced}");

  exit(0);
}
