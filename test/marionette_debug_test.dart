import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:miria/marionette_debug.dart";

/// [extractMarionetteText] は marionette の走査から呼ばれるので、
/// テストからも同じように [Element] を渡して確かめる。
String? labelOf(WidgetTester tester, Finder finder) =>
    extractMarionetteText(tester.element(finder));

Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  group("ボタンのラベル抽出", () {
    testWidgets("TextButton のラベルが読めること", (tester) async {
      await pump(
        tester,
        TextButton(onPressed: () {}, child: const Text("削除する")),
      );

      expect(labelOf(tester, find.byType(TextButton)), "削除する");
    });

    testWidgets("ElevatedButton / OutlinedButton も読めること", (tester) async {
      await pump(
        tester,
        Column(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("更新")),
            OutlinedButton(onPressed: () {}, child: const Text("削除")),
          ],
        ),
      );

      expect(labelOf(tester, find.byType(ElevatedButton)), "更新");
      expect(labelOf(tester, find.byType(OutlinedButton)), "削除");
    });

    testWidgets("アイコン付きボタンでアイコンがラベルに混ざらないこと", (tester) async {
      await pump(
        tester,
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text("作成"),
        ),
      );

      // Icon が内部で作る RichText の平文はフォントの私用領域の
      // コードポイントなので、拾ってしまうと読めないラベルになる。
      expect(labelOf(tester, find.byType(ElevatedButton)), "作成");
    });

    testWidgets("ラベルのないアイコンボタンは null のままであること", (tester) async {
      await pump(
        tester,
        IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
      );

      expect(labelOf(tester, find.byType(IconButton)), isNull);
    });

    testWidgets("入れ子になったラベルも読めること", (tester) async {
      await pump(
        tester,
        TextButton(
          onPressed: () {},
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Text("やっぱやめる"),
          ),
        ),
      );

      expect(labelOf(tester, find.byType(TextButton)), "やっぱやめる");
    });

    testWidgets("SwitchListTile のラベルが読めること", (tester) async {
      await pump(
        tester,
        SwitchListTile(
          value: true,
          onChanged: (_) {},
          title: const Text("ミュートする"),
        ),
      );

      expect(labelOf(tester, find.byType(SwitchListTile)), "ミュートする");
    });

    testWidgets("ボタン以外は対象にならないこと", (tester) async {
      // ここでラベルを返すと、操作できないウィジェットまで要素一覧に
      // 載ってしまい、一覧が膨らむ。
      await pump(
        tester,
        const Padding(padding: EdgeInsets.all(4), child: Text("ただの文字")),
      );

      expect(labelOf(tester, find.byType(Padding).first), isNull);
    });
  });
}
