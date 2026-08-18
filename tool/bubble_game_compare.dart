/// 移植したバブルゲームの挙動を、本家 (matter-js + misskey-bubble-game) が
/// 出力した参照トレースと突き合わせるための開発用スクリプト。
///
/// 参照トレースの生成手順は`test/bubble_game/README.md`を参照。
///
/// ```
/// fvm dart run tool/bubble_game_compare.dart <参照JSONのパス>
/// ```
library;

import "dart:convert";
import "dart:io";

import "package:miria/model/bubble_game/drop_and_fusion_game.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/util/matter/body.dart";

void main(List<String> args) {
  final path = args.isNotEmpty
      ? args.first
      : "test/bubble_game/reference_traces.json";
  final cases =
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

  var failed = 0;

  for (final entry in cases.entries) {
    final name = entry.key;
    final testCase = entry.value as Map<String, dynamic>;
    final result = runBubbleGameCase(testCase);
    final expected = testCase["result"] as Map<String, dynamic>;

    final diff = _diff(expected, result);
    if (diff == null) {
      stdout.writeln("OK   $name");
    } else {
      failed++;
      stdout.writeln("FAIL $name: $diff");
    }
  }

  stdout.writeln(failed == 0 ? "ALL MATCH" : "$failed case(s) failed");
  if (failed > 0) exitCode = 1;
}

/// 参照トレースを取るフレーム間隔。生成側の`SNAP`と揃える必要がある。
const int snapshotInterval = 300;

/// 参照トレースと同じ手順でゲームを進めて結果を集める。
Map<String, dynamic> runBubbleGameCase(Map<String, dynamic> testCase) {
  // ボディのidを本家のページ読み込み直後と揃える
  resetMatterIdCounter();

  final mode = BubbleGameMode.values.firstWhere(
    (x) => x.apiValue == testCase["mode"] as String,
  );
  final seed = testCase["seed"] as String;
  final totalFrames = testCase["frames"] as int;
  final ops = (testCase["ops"] as List).cast<Map<String, dynamic>>();

  final game = DropAndFusionGame(seed: seed, gameMode: mode);
  final events = <String>[];

  game.onFusioned = (fusion) {
    events.add(
      "fusioned ${game.frame} ${_fixed9(fusion.x)} ${_fixed9(fusion.y)} "
      "${fusion.next?.id ?? "null"} ${fusion.scoreDelta}",
    );
  };
  game.onGameOver = () => events.add("gameOver ${game.frame}");
  game.onChangeScore = (score) => events.add("score ${game.frame} $score");
  // comboは毎フレーム0で通知されるので、値が変わったときだけ記録する
  int? lastCombo;
  game.onChangeCombo = (combo) {
    if (combo != lastCombo) {
      lastCombo = combo;
      events.add("combo ${game.frame} $combo");
    }
  };
  game.start();

  final opsByFrame = <int, List<Map<String, dynamic>>>{};
  for (final op in ops) {
    opsByFrame.putIfAbsent(op["frame"] as int, () => []).add(op);
  }

  final snapshots = <Map<String, dynamic>>[];

  Map<String, dynamic> snapshot() => {
    "frame": game.frame,
    "bodies": [
      for (final body in game.debugBodies)
        {
          "id": body.id,
          "label": body.label,
          "x": body.position.x,
          "y": body.position.y,
          "a": body.angle,
        },
    ],
  };

  for (var f = 0; f <= totalFrames; f++) {
    for (final op in opsByFrame[f] ?? const []) {
      if (op["op"] == "drop") {
        game.drop((op["x"] as num).toDouble());
      } else {
        game.hold();
      }
    }

    if (f % snapshotInterval == 0) snapshots.add(snapshot());

    if (!game.tick()) break;
  }

  // 最後の状態も必ず記録する
  snapshots.add(snapshot());

  return {
    "snapshots": snapshots,
    "events": events,
    "logs": DropAndFusionGame.serializeLogs(game.getLogs()),
  };
}

String _fixed9(double value) => value.toStringAsFixed(9);

String? _diff(Map<String, dynamic> expected, Map<String, dynamic> actual) {
  final expectedSnapshots = (expected["snapshots"] as List)
      .cast<Map<String, dynamic>>();
  final actualSnapshots = (actual["snapshots"] as List)
      .cast<Map<String, dynamic>>();

  if (expectedSnapshots.length != actualSnapshots.length) {
    return "snapshot count ${actualSnapshots.length} != "
        "${expectedSnapshots.length}";
  }

  for (var i = 0; i < expectedSnapshots.length; i++) {
    final expectedSnapshot = expectedSnapshots[i];
    final actualSnapshot = actualSnapshots[i];
    final expectedBodies = (expectedSnapshot["bodies"] as List)
        .cast<Map<String, dynamic>>();
    final actualBodies = (actualSnapshot["bodies"] as List)
        .cast<Map<String, dynamic>>();

    if (expectedBodies.length != actualBodies.length) {
      return "frame ${expectedSnapshot["frame"]}: body count "
          "${actualBodies.length} != ${expectedBodies.length}";
    }

    for (var j = 0; j < expectedBodies.length; j++) {
      for (final key in const ["id", "label"]) {
        if (expectedBodies[j][key] != actualBodies[j][key]) {
          return "frame ${expectedSnapshot["frame"]} body $j: $key "
              "${actualBodies[j][key]} != ${expectedBodies[j][key]}";
        }
      }
      for (final key in const ["x", "y", "a"]) {
        final expectedValue = (expectedBodies[j][key] as num).toDouble();
        final actualValue = actualBodies[j][key] as double;
        if (expectedValue != actualValue) {
          return "frame ${expectedSnapshot["frame"]} body $j "
              "(${expectedBodies[j]["label"]}): $key "
              "$actualValue != $expectedValue "
              "(diff ${actualValue - expectedValue})";
        }
      }
    }
  }

  final expectedEvents = (expected["events"] as List).cast<String>();
  final actualEvents = (actual["events"] as List).cast<String>();
  for (var i = 0; i < expectedEvents.length && i < actualEvents.length; i++) {
    if (expectedEvents[i] != actualEvents[i]) {
      return "event $i: ${actualEvents[i]} != ${expectedEvents[i]}";
    }
  }
  if (expectedEvents.length != actualEvents.length) {
    return "event count ${actualEvents.length} != ${expectedEvents.length}";
  }

  final expectedLogs = jsonEncode(expected["logs"]);
  final actualLogs = jsonEncode(actual["logs"]);
  if (expectedLogs != actualLogs) {
    return "logs $actualLogs != $expectedLogs";
  }

  return null;
}
