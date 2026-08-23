import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/reversi/reversi_game.dart";
import "package:miria/model/reversi/reversi_maps.dart";
import "package:miria/view/games_page/reversi/reversi_board.dart";

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group("リバーシの盤面", () {
    testWidgets("マスごとに位置つきの Key が振られること", (tester) async {
      // marionette から `tap --key reversi-cell-<pos>` で撃てることが前提の
      // 作りなので、Key が消えると e2e が丸ごと動かなくなる。
      await tester.pumpWidget(
        _wrap(
          ReversiBoard(game: ReversiGame(eighteight.data), onTapCell: (_) {}),
        ),
      );

      expect(find.byKey(const Key("reversi-cell-0")), findsOneWidget);
      expect(find.byKey(const Key("reversi-cell-63")), findsOneWidget);
      expect(find.byKey(const Key("reversi-cell-64")), findsNothing);
    });

    testWidgets("マスを押すとその位置が渡ること", (tester) async {
      final tapped = <int>[];

      await tester.pumpWidget(
        _wrap(
          ReversiBoard(
            game: ReversiGame(eighteight.data),
            onTapCell: tapped.add,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key("reversi-cell-19")));
      await tester.pump();

      expect(tapped, [19]);
    });

    testWidgets("盤面として存在しないマスは押せないこと", (tester) async {
      final tapped = <int>[];

      // 四隅が欠けたマップ。左上 (pos 0) はマスが無い。
      await tester.pumpWidget(
        _wrap(
          ReversiBoard(
            game: ReversiGame(roundedEighteight.data),
            onTapCell: tapped.add,
          ),
        ),
      );

      expect(find.byKey(const Key("reversi-cell-0")), findsNothing);
      expect(find.byKey(const Key("reversi-cell-1")), findsOneWidget);
    });

    testWidgets("アバターを渡すと、その色の石だけがアバターを持つこと", (tester) async {
      // 本家と同じく石を持ち主のアバターにする。黒白の取り違えは
      // 「どちらの石か分からない」で終わらず、対局の見え方が壊れる。
      final black = Uri.parse("https://example.com/black.png");
      final white = Uri.parse("https://example.com/white.png");

      await tester.pumpWidget(
        ProviderScope(
          child: _wrap(
            ReversiBoard(
              game: ReversiGame(eighteight.data),
              blackAvatarUrl: black,
              whiteAvatarUrl: white,
              onTapCell: (_) {},
            ),
          ),
        ),
      );

      final stones = tester
          .widgetList<ReversiStone>(find.byType(ReversiStone))
          .toList();

      expect(stones, hasLength(4));
      expect(
        stones.where((e) => e.color == Colors.black).map((e) => e.avatarUrl),
        everyElement(black),
      );
      expect(
        stones.where((e) => e.color == Colors.white).map((e) => e.avatarUrl),
        everyElement(white),
      );
    });

    testWidgets("アバターを渡さなければ石だけ描かれること", (tester) async {
      await tester.pumpWidget(
        _wrap(
          ReversiBoard(game: ReversiGame(eighteight.data), onTapCell: (_) {}),
        ),
      );

      final stones = tester.widgetList<ReversiStone>(find.byType(ReversiStone));

      expect(stones, hasLength(4));
      expect(stones.map((e) => e.avatarUrl), everyElement(isNull));
    });

    testWidgets("石が置かれているマスだけ石が描かれること", (tester) async {
      await tester.pumpWidget(
        _wrap(
          ReversiBoard(game: ReversiGame(eighteight.data), onTapCell: (_) {}),
        ),
      );

      // 8x8 の初期配置は 27=白 28=黒 35=黒 36=白 の 4 つだけ。
      final stones = find.descendant(
        of: find.byType(ReversiBoard),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
        ),
      );

      expect(stones, findsNWidgets(4));
    });
  });
}
