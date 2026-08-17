import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:miria/model/bubble_game/drop_and_fusion_game.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/util/matter/body.dart";

import "../../tool/bubble_game_compare.dart";

/// 本家 (matter-js 0.20.0 + misskey-bubble-game) が出力した参照トレースと
/// 移植したゲームの結果が完全に一致することを確かめる。
///
/// バブルゲームはスコアをシードと操作ログとともにサーバーへ送るため、
/// 「だいたい同じ動き」では意味がなく、
/// 同じ操作から同じ盤面・同じスコアになる必要がある。
/// 参照トレースの作りかたは`test/bubble_game/README.md`を参照。
void main() {
  group("DropAndFusionGame", () {
    final cases =
        jsonDecode(
              File("test/bubble_game/reference_traces.json").readAsStringSync(),
            )
            as Map<String, dynamic>;

    for (final entry in cases.entries) {
      test("本家と同じ結果になる: ${entry.key}", () {
        final testCase = entry.value as Map<String, dynamic>;
        final actual = runBubbleGameCase(testCase);
        final expected = testCase["result"] as Map<String, dynamic>;

        final expectedSnapshots = (expected["snapshots"] as List)
            .cast<Map<String, dynamic>>();
        final actualSnapshots = (actual["snapshots"] as List)
            .cast<Map<String, dynamic>>();

        expect(actualSnapshots, hasLength(expectedSnapshots.length));

        for (var i = 0; i < expectedSnapshots.length; i++) {
          final frame = expectedSnapshots[i]["frame"];
          final expectedBodies = (expectedSnapshots[i]["bodies"] as List)
              .cast<Map<String, dynamic>>();
          final actualBodies = (actualSnapshots[i]["bodies"] as List)
              .cast<Map<String, dynamic>>();

          expect(actualSnapshots[i]["frame"], frame, reason: "スナップショット$iのフレーム");
          expect(
            actualBodies,
            hasLength(expectedBodies.length),
            reason: "フレーム$frameのボディ数",
          );

          for (var j = 0; j < expectedBodies.length; j++) {
            for (final key in const ["id", "label", "x", "y", "a"]) {
              expect(
                actualBodies[j][key],
                expectedBodies[j][key],
                reason:
                    "フレーム$frame ボディ$j (${expectedBodies[j]["label"]}) の$key",
              );
            }
          }
        }

        expect(actual["events"], expected["events"]);
        expect(actual["logs"], expected["logs"]);
      });
    }

    test("操作ログを本家と同じ形式に直列化できる", () {
      final logs = [
        const BubbleGameLog(
          frame: 10,
          operation: BubbleGameOperation.drop,
          x: 225,
        ),
        const BubbleGameLog(frame: 45, operation: BubbleGameOperation.hold),
        const BubbleGameLog(
          frame: 50,
          operation: BubbleGameOperation.drop,
          x: 100,
        ),
        const BubbleGameLog(
          frame: 90,
          operation: BubbleGameOperation.surrender,
        ),
      ];

      final serialized = DropAndFusionGame.serializeLogs(logs);

      expect(serialized, [
        [10, 0, 225],
        [35, 1],
        [5, 0, 100],
        [40, 2],
      ]);

      final deserialized = DropAndFusionGame.deserializeLogs(serialized);
      expect(deserialized.map((x) => x.frame), logs.map((x) => x.frame));
      expect(
        deserialized.map((x) => x.operation),
        logs.map((x) => x.operation),
      );
      expect(deserialized[0].x, 225);
      expect(deserialized[2].x, 100);
    });

    test("同じシードなら同じストックが出る", () {
      resetMatterIdCounter();
      final first = DropAndFusionGame(
        seed: "1755000000000",
        gameMode: BubbleGameMode.normal,
      )..start();
      resetMatterIdCounter();
      final second = DropAndFusionGame(
        seed: "1755000000000",
        gameMode: BubbleGameMode.normal,
      )..start();

      expect(
        first.stock.map((x) => x.mono.id),
        second.stock.map((x) => x.mono.id),
      );
      expect(first.stock.map((x) => x.id), second.stock.map((x) => x.id));
    });
  });
}
