/// 移植したリバーシエンジンの、読んで意図がわかる方のテスト。
///
/// 本家との一致そのものは `reversi_golden_test.dart` が 205 局ぶん見ている。
/// こちらは「なぜそう書いてあるのか」が壊れたときに気づけるように、
/// 移植で判断が要った箇所を名指しで押さえている。
library;

import "package:flutter_test/flutter_test.dart";
import "package:miria/model/reversi/reversi_game.dart";
import "package:miria/model/reversi/reversi_maps.dart";
import "package:miria/model/reversi/reversi_serializer.dart";

void main() {
  group("初期状態", () {
    test("8x8 は黒番から始まり、置ける場所が 4 つある", () {
      final game = ReversiGame(eighteight.data);

      expect(game.turn, reversiBlack);
      expect(game.blackCount, 2);
      expect(game.whiteCount, 2);
      expect(game.getPuttablePlaces(reversiBlack).length, 4);
      expect(game.isEnded, isFalse);
    });

    test("盤面として存在しないマスは empty と区別される", () {
      // 四隅が欠けたマップ。左上 (0,0) はマス自体が無い。
      final game = ReversiGame(roundedEighteight.data);

      expect(game.board.first, ReversiCell.none);
      expect(game.mapDataGet(0), ReversiMapCell.none);
      // 区別が潰れていると、存在しないマスに打ててしまう。
      expect(game.canPut(reversiBlack, 0), isFalse);
    });

    test("開始時点で黒が打てないマップは白番から始まる", () {
      // 空きマスは 0 だけ。白は 0 に打てば 1 の黒を挟めるが、
      // 黒は 0 の右隣がいきなり自分の石なので何も挟めない。
      final game = ReversiGame(const ["-bw"]);

      expect(game.canPutSomewhere(reversiBlack), isFalse);
      expect(game.turn, reversiWhite);
    });
  });

  group("着手", () {
    test("挟んだ石が反転し、手番が移る", () {
      // 8x8 の初期配置は 27=白 28=黒 35=黒 36=白。
      // 黒が 19 に打つと、19 → 27(白) → 35(黒) の縦線で 27 が挟まれる。
      final game = ReversiGame(eighteight.data);
      expect(game.getPuttablePlaces(reversiBlack), [19, 26, 37, 44]);

      game.putStone(19);

      expect(game.board[19], ReversiCell.black);
      expect(game.board[27], ReversiCell.black);
      expect(game.blackCount, 4);
      expect(game.whiteCount, 1);
      expect(game.turn, reversiWhite);
      expect(game.prevPos, 19);
      expect(game.prevColor, reversiBlack);
    });

    test("undo で盤面・手番・直前の手が戻る", () {
      final game = ReversiGame(eighteight.data);
      final before = game.calcCrc32();

      game
        ..putStone(19)
        ..undo();

      expect(game.board[19], ReversiCell.empty);
      expect(game.board[27], ReversiCell.white);
      // undo が戻すのは「打った人の手番」であって、打つ前の手番ではない。
      // 移植元が putStone で board 更新後の turn を記録しているため。
      expect(game.turn, reversiBlack);
      expect(game.calcCrc32(), before);
    });

    test("canPutEverywhere なら挟めなくても空きマスに打てる", () {
      final normal = ReversiGame(eighteight.data);
      final anywhere = ReversiGame(
        eighteight.data,
        opts: const ReversiGameOptions(canPutEverywhere: true),
      );

      expect(normal.canPut(reversiBlack, 0), isFalse);
      expect(anywhere.canPut(reversiBlack, 0), isTrue);
    });

    test("loopedBoard なら盤の端を跨いで挟める", () {
      // 上端の行に白、その下に黒。ループなしでは黒は 0 に打てない。
      const map = [
        "-w------",
        "-b------",
        "--------",
        "---wb---",
        "---bw---",
        "--------",
        "--------",
        "--------",
      ];

      final normal = ReversiGame(map);
      final looped = ReversiGame(
        map,
        opts: const ReversiGameOptions(loopedBoard: true),
      );

      // (1,0) の白の上は盤外。ループすると (1,7) → 空きなので挟めない。
      // 代わりに縦にループして (1,7) 側から挟む形になるかを見る。
      expect(normal.effects(reversiBlack, 1), isEmpty);
      expect(looped.effects(reversiBlack, 57), contains(1));
    });
  });

  group("勝敗", () {
    test("石の多い方が勝ち、isLlotheo なら少ない方が勝ち", () {
      // 開始時点で決着するマップを使う。
      const map = ["bbb", "bbb", "bwb"];

      final normal = ReversiGame(map);
      final llotheo = ReversiGame(
        map,
        opts: const ReversiGameOptions(isLlotheo: true),
      );

      expect(normal.isEnded, isTrue);
      expect(normal.blackCount, 8);
      expect(normal.whiteCount, 1);
      expect(normal.winner, reversiBlack);
      expect(llotheo.winner, reversiWhite);
    });

    test("同数なら引き分け", () {
      final game = ReversiGame(const ["bw"]);

      expect(game.isEnded, isTrue);
      expect(game.winner, isNull);
    });
  });

  group("crc32", () {
    test("盤面が同じなら一致し、1 手進めば変わる", () {
      final a = ReversiGame(eighteight.data);
      final b = ReversiGame(eighteight.data);

      expect(a.calcCrc32(), b.calcCrc32());

      b.putStone(29);
      expect(a.calcCrc32(), isNot(b.calcCrc32()));
    });

    test("符号付き 32bit で返す", () {
      // 本家は npm の crc-32 を使っており、その結果は符号付き。
      // 符号なしで返すと `reversi/verify` の文字列比較が食い違う。
      final values = [
        for (final map in reversiMaps) ReversiGame(map.data).calcCrc32(),
      ];

      expect(values.every((e) => e >= -2147483648 && e <= 2147483647), isTrue);
      expect(values.any((e) => e < 0), isTrue, reason: "負の値が 1 つも出ていない");
    });
  });

  group("ログの直列化", () {
    test("時刻が差分に畳まれ、元に戻る", () {
      const logs = [
        ReversiLog(time: 1000, player: reversiBlack, pos: 29),
        ReversiLog(time: 1500, player: reversiWhite, pos: 20),
        ReversiLog(time: 4000, player: reversiBlack, pos: 19),
      ];

      final serialized = serializeReversiLogs(logs);

      expect(serialized, [
        [1000, 1, 0, 29],
        [500, 0, 0, 20],
        [2500, 1, 0, 19],
      ]);

      final restored = deserializeReversiLogs(serialized);
      expect(restored.map((e) => e.time), [1000, 1500, 4000]);
      expect(restored.map((e) => e.player), [true, false, true]);
      expect(restored.map((e) => e.pos), [29, 20, 19]);
    });

    test("途中まで打ち直せば、その時点の盤面が出る", () {
      // 棋譜の再生はこれで作っている。logs の先頭 n 件を打ち直した盤面が、
      // n 手目まで進めた盤面と一致していないと、巻き戻しが嘘になる。
      final replayed = ReversiGame(eighteight.data);
      final logs = <List<int>>[];
      var time = 1700000000000;

      for (final pos in [19, 20, 21, 34]) {
        logs.add([logs.isEmpty ? time : 1000, replayed.turn! ? 1 : 0, 0, pos]);
        time += 1000;
        replayed.putStone(pos);

        final restored = restoreReversiGame(map: eighteight.data, logs: logs);

        expect(
          restored.calcCrc32(),
          replayed.calcCrc32(),
          reason: "${logs.length} 手目の盤面が一致しない",
        );
      }

      // 0 手目は初期盤面。
      final start = restoreReversiGame(map: eighteight.data, logs: const []);
      expect(start.calcCrc32(), ReversiGame(eighteight.data).calcCrc32());
    });

    test("サーバーの logs から盤面を復元できる", () {
      // reversi/show-game がそのまま返してくる形。
      const serverLogs = [
        [1700000000000, 1, 0, 29],
        [1200, 0, 0, 20],
      ];

      final restored = restoreReversiGame(
        map: eighteight.data,
        logs: serverLogs,
      );

      final replayed = ReversiGame(eighteight.data)
        ..putStone(29)
        ..putStone(20);

      expect(restored.calcCrc32(), replayed.calcCrc32());
      expect(restored.turn, replayed.turn);
    });
  });
}
