/// 対局ログの直列化と、ログからの盤面復元。
///
/// 移植元は `misskey-dev/misskey` の
/// `packages/misskey-reversi/src/serializer.ts`
/// (AGPL-3.0-only, syuilo and misskey-project)。
///
/// サーバーの `reversi/show-game` が返す `logs` はこの直列化形式そのもの
/// （`[経過ミリ秒の差分, 打った人, 操作, 位置]` の配列）なので、
/// 途中参加や再接続で盤面を復元するにはこの実装が要る。
library;

import "package:miria/model/reversi/reversi_game.dart";

/// 1 手ぶんのログ。移植元の `Log`。
class ReversiLog {
  const ReversiLog({
    required this.time,
    required this.player,
    required this.pos,
  });

  /// 対局開始からの経過ではなく、エポックミリ秒。
  final int time;

  /// 打った色。true が黒。
  final ReversiColor player;

  /// 打った位置。
  final int pos;

  /// 操作の種類。今のところ `put`（0）しかない。
  ///
  /// 移植元には surrender（1）がコメントアウトで残っているが、
  /// 実際には投了はログに積まれず `reversi/surrender` で処理される。
  static const operationPut = 0;
}

/// [logs] を Misskey の配信形式に直列化する。
List<List<int>> serializeReversiLogs(List<ReversiLog> logs) {
  final result = <List<int>>[];

  for (var i = 0; i < logs.length; i++) {
    final log = logs[i];
    // 先頭だけは絶対時刻、以降は前の手からの差分。
    final timeDelta = i == 0 ? log.time : log.time - logs[i - 1].time;
    final player = log.player ? 1 : 0;
    result.add([timeDelta, player, ReversiLog.operationPut, log.pos]);
  }

  return result;
}

/// Misskey の配信形式のログを [ReversiLog] に戻す。
///
/// 未知の操作種別は移植元と同じく黙って捨てる。
List<ReversiLog> deserializeReversiLogs(List<List<int>> logs) {
  final result = <ReversiLog>[];
  var time = 0;

  for (final log in logs) {
    time += log[0];
    if (log[2] != ReversiLog.operationPut) continue;
    result.add(ReversiLog(time: time, player: log[1] == 1, pos: log[3]));
  }

  return result;
}

/// ログを順に打ち直して盤面を復元する。移植元の `restoreGame`。
ReversiGame restoreReversiGame({
  required List<String> map,
  required List<List<int>> logs,
  bool isLlotheo = false,
  bool canPutEverywhere = false,
  bool loopedBoard = false,
}) {
  final game = ReversiGame(
    map,
    opts: ReversiGameOptions(
      isLlotheo: isLlotheo,
      canPutEverywhere: canPutEverywhere,
      loopedBoard: loopedBoard,
    ),
  );

  for (final log in deserializeReversiLogs(logs)) {
    game.putStone(log.pos);
  }

  return game;
}
