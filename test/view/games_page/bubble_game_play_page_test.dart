import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/games_page/bubble_game/bubble_game_painter.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("バブルゲーム", () {
    /// 画像の読み込みとハイスコアの取得は失敗しても遊べるようにしてあるので、
    /// ここではモックを差し替えるだけで通信はさせない。
    Future<void> pumpGame(WidgetTester tester, BubbleGameMode gameMode) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => MockMisskey()),
            dioProvider.overrideWith((ref) => MockDio()),
          ],
          child: DefaultRootWidget(
            initialRoute: BubbleGamePlayRoute(
              accountContext: TestData.accountContext,
              gameMode: gameMode,
            ),
          ),
        ),
      );
      await tester.pump();
    }

    for (final gameMode in BubbleGameMode.values) {
      testWidgets("${gameMode.apiValue}モードの盤面が描画できること", (tester) async {
        await pumpGame(tester, gameMode);

        expect(find.byType(CustomPaint), findsWidgets);
        expect(
          tester
              .widgetList<CustomPaint>(find.byType(CustomPaint))
              .where((x) => x.painter is BubbleGamePainter),
          isNotEmpty,
        );

        // 数フレーム進めても落ちないこと
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
      });
    }

    testWidgets("盤面をタップするとモノが落ちること", (tester) async {
      await pumpGame(tester, BubbleGameMode.normal);

      final board = find
          .byWidgetPredicate(
            (widget) =>
                widget is CustomPaint && widget.painter is BubbleGamePainter,
          )
          .first;

      BubbleGamePainter painter() =>
          tester.widget<CustomPaint>(board).painter! as BubbleGamePainter;

      expect(painter().game.getBodyStates(), isEmpty);

      // 開始直後はクールタイム中で落とせないので、少し進めてから落とす
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(painter().game.canDrop, isTrue);

      await tester.tapAt(tester.getCenter(board));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(painter().game.getBodyStates(), hasLength(1));
    });

    testWidgets("ホールドを押すとストックが入れ替わること", (tester) async {
      await pumpGame(tester, BubbleGameMode.normal);

      final board = find
          .byWidgetPredicate(
            (widget) =>
                widget is CustomPaint && widget.painter is BubbleGamePainter,
          )
          .first;
      final game =
          (tester.widget<CustomPaint>(board).painter! as BubbleGamePainter)
              .game;

      final head = game.stock.first;
      expect(game.holding, isNull);

      await tester.tap(find.text("ホールド"));
      await tester.pump();

      expect(game.holding?.id, head.id);
    });
  });
}
