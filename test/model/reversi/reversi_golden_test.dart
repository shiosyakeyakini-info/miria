/// 移植したルールエンジンが本家と 1 手ずつ一致することを確かめる。
///
/// `test/assets/reversi_golden.json` は本家 misskey-dev/misskey の
/// `packages/misskey-reversi` をトランスパイルして実際に走らせた出力
/// （生成スクリプトは `test/assets/reversi_golden_gen.js`）。
/// 41 マップ × 5 ルール設定を seed 固定の乱択で最後まで打ち切った 205 局、
/// 計 10918 手ぶんある。
///
/// 手ごとに crc32 まで突き合わせているので、盤面か手番が 1 マスでもずれれば
/// その手で落ちる。crc32 を見ているのは飾りではなく、Misskey の
/// `reversi/verify` が同期チェックに使う値そのものだから。
library;

import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:miria/model/reversi/reversi_game.dart";
import "package:miria/model/reversi/reversi_maps.dart";

/// 盤面を生成スクリプトと同じ表現の文字列にする。
String _boardToString(ReversiGame game) => game.board
    .map(
      (e) => switch (e) {
        ReversiCell.black => "b",
        ReversiCell.white => "w",
        ReversiCell.empty => "-",
        ReversiCell.none => "x",
      },
    )
    .join();

ReversiGameOptions _optionsOf(String label) => switch (label) {
  "default" => const ReversiGameOptions(),
  "llotheo" => const ReversiGameOptions(isLlotheo: true),
  "looped" => const ReversiGameOptions(loopedBoard: true),
  "putEverywhere" => const ReversiGameOptions(canPutEverywhere: true),
  "loopedPutEverywhere" => const ReversiGameOptions(
    canPutEverywhere: true,
    loopedBoard: true,
  ),
  _ => throw ArgumentError("未知のルール設定: $label"),
};

void main() {
  final golden =
      jsonDecode(File("test/assets/reversi_golden.json").readAsStringSync())
          as Map<String, dynamic>;
  final cases = (golden["cases"] as List).cast<Map<String, dynamic>>();

  test("照合データが空でない", () {
    expect(cases, isNotEmpty);
    expect(cases.length, 205);
  });

  for (final testCase in cases) {
    final mapKey = testCase["map"] as String;
    final optsLabel = testCase["opts"] as String;

    test("$mapKey / $optsLabel が本家と一致する", () {
      final map = reversiMapsByKey[mapKey];
      expect(map, isNotNull, reason: "マップ $mapKey が移植されていない");

      final game = ReversiGame(map!.data, opts: _optionsOf(optsLabel));

      expect(_boardToString(game), testCase["initialBoard"], reason: "初期盤面");
      expect(game.turn, testCase["initialTurn"], reason: "初期手番");
      expect(game.calcCrc32(), testCase["initialCrc32"], reason: "初期 crc32");

      final moves = (testCase["moves"] as List).cast<List<dynamic>>();
      for (var i = 0; i < moves.length; i++) {
        final [pos as int, puttableCount as int, crc32 as int] = moves[i];
        final turn = game.turn;

        expect(turn, isNotNull, reason: "${i + 1} 手目で手番が消えている");
        expect(
          game.getPuttablePlaces(turn!).length,
          puttableCount,
          reason: "${i + 1} 手目の着手可能数",
        );
        expect(game.canPut(turn, pos), isTrue, reason: "${i + 1} 手目が打てない");

        game.putStone(pos);

        expect(game.calcCrc32(), crc32, reason: "${i + 1} 手目のあとの crc32");
      }

      expect(game.turn, isNull, reason: "対局が終わっていない");
      expect(_boardToString(game), testCase["finalBoard"], reason: "最終盤面");
      expect(game.blackCount, testCase["blackCount"], reason: "黒の数");
      expect(game.whiteCount, testCase["whiteCount"], reason: "白の数");
      expect(game.winner, testCase["winner"], reason: "勝者");

      if (moves.isNotEmpty) {
        game.undo();
        expect(
          _boardToString(game),
          testCase["undoBoard"],
          reason: "undo 後の盤面",
        );
        expect(game.turn, testCase["undoTurn"], reason: "undo 後の手番");
        expect(
          game.calcCrc32(),
          testCase["undoCrc32"],
          reason: "undo 後の crc32",
        );
      }
    });
  }
}
