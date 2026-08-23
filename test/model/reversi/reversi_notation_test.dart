import "package:flutter_test/flutter_test.dart";
import "package:miria/model/reversi/reversi_maps.dart";
import "package:miria/model/reversi/reversi_notation.dart";

void main() {
  group("棋譜の表記", () {
    test("8x8 は左上が a1、右上が h1、右下が h8", () {
      expect(reversiPosLabel(0, 8), "a1");
      expect(reversiPosLabel(7, 8), "h1");
      expect(reversiPosLabel(63, 8), "h8");
    });

    test("定石の f5 が 8x8 の pos 37 になる", () {
      // 黒の初手として最もよく出る手。列 f = 6 列目、行 5。
      expect(reversiPosLabel(37, 8), "f5");
    });

    test("マップの幅が変われば同じ pos でも表記が変わる", () {
      expect(reversiPosLabel(10, 10), "a2");
      expect(reversiPosLabel(10, 8), "c2");
    });

    test("組み込みマップで最も広い Two board でも英字に収まる", () {
      final width = twoBoard.data.first.length;

      expect(width, 17);
      expect(reversiPosLabel(width - 1, width), "q1");
    });

    test("26 列を超えたら数字に落として壊れない", () {
      // 組み込みマップにこの幅は無いが、黙って別の列と同じ表記になるより
      // 数字で出るほうがまし。
      expect(reversiPosLabel(26, 30), "271");
    });
  });
}
