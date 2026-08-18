import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/games_page/bubble_game/bubble_game_painter.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

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

    testWidgets("モード選択の画面でランキングが表示されること", (tester) async {
      // ランキングのプロバイダはアカウントごとにスコープされたリポジトリを読むので、
      // dependenciesの宣言が足りないと実行時に落ちる
      final bubbleGame = MockMisskeyBubbleGame();
      final misskey = MockMisskey();
      when(misskey.bubbleGame).thenReturn(bubbleGame);
      when(bubbleGame.show(any)).thenAnswer(
        (_) async => [
          BubbleGameRankingResponse(
            id: "record1",
            score: 1234,
            user: TestData.user1,
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref, account) => misskey)],
          child: DefaultRootWidget(
            initialRoute: BubbleGameRoute(
              accountContext: TestData.accountContext,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("1234pt"), findsOneWidget);
      verify(
        bubbleGame.show(
          argThat(equals(const BubbleGameRankingRequest(gameMode: "normal"))),
        ),
      );
    });

    testWidgets("モノの画像をアカウントのスキームで取りにいくこと", (tester) async {
      // httpのサーバーもあるので、httpsを決め打ちにしてはいけない
      final account = Account(
        host: "localhost",
        userId: "miria",
        i: TestData.i1,
        meta: TestData.meta,
        scheme: "http",
        port: 3000,
      );
      final dio = MockDio();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => MockMisskey()),
            dioProvider.overrideWith((ref) => dio),
          ],
          child: DefaultRootWidget(
            initialRoute: BubbleGamePlayRoute(
              accountContext: AccountContext(
                getAccount: account,
                postAccount: account,
              ),
              gameMode: BubbleGameMode.normal,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));

      final captured = verify(
        dio.getUri<List<int>>(captureAny, options: anyNamed("options")),
      ).captured.cast<Uri>();

      expect(captured, isNotEmpty);
      for (final uri in captured) {
        expect(uri.scheme, "http");
        expect(uri.host, "localhost");
        expect(uri.port, 3000);
        expect(uri.path, startsWith("/client-assets/drop-and-fusion/"));
      }
    });
  });
}
