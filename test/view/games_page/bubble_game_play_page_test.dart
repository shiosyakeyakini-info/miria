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

    testWidgets("ゲームオーバーのあと自分の試合を再生できること", (tester) async {
      await pumpGame(tester, BubbleGameMode.normal);

      final board = find
          .byWidgetPredicate(
            (widget) =>
                widget is CustomPaint && widget.painter is BubbleGamePainter,
          )
          .first;
      BubbleGamePainter painter() =>
          tester.widget<CustomPaint>(board).painter! as BubbleGamePainter;

      Future<void> advance(int frames) async {
        for (var i = 0; i < frames; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
      }

      // 何個か落としてからギブアップする
      for (var i = 0; i < 4; i++) {
        await advance(32);
        if (painter().game.canDrop) {
          await tester.tapAt(tester.getCenter(board));
        }
      }
      await advance(30);

      final played = painter().game;
      final logs = played.getLogs();
      final seed = played.seed;
      expect(logs, isNotEmpty);

      await tester.tap(find.byIcon(Icons.flag));
      await advance(5);
      await tester.tap(find.text("ギブアップ"));
      await advance(5);

      // スコアの登録はモックなので失敗する。出たダイアログを閉じる
      if (find.text("ほい").evaluate().isNotEmpty) {
        await tester.tap(find.text("ほい"));
        await advance(5);
      }
      expect(find.text("リプレイを見る"), findsOneWidget);

      // 再生すると、同じシードのゲームが操作なしで進む
      await tester.tap(find.text("リプレイを見る"));
      await advance(5);

      final replay = painter().game;
      expect(replay.seed, seed);
      expect(identical(replay, played), isFalse);
      expect(find.text("再生中"), findsOneWidget);

      await advance(200);

      // 記録した操作が同じフレームで流れる。
      // 最後にギブアップも記録されているので、再生側のほうが1件多くなる
      final replayed = replay.getLogs();
      expect(replayed.length, greaterThanOrEqualTo(logs.length));
      expect(
        replayed.take(logs.length).map((x) => x.frame),
        logs.map((x) => x.frame),
        reason: "記録どおりのフレームで操作が流れていない",
      );
      expect(
        replayed.take(logs.length).map((x) => x.x),
        logs.map((x) => x.x),
        reason: "記録どおりの位置に落ちていない",
      );
      expect(replay.getBodyStates(), isNotEmpty, reason: "何も落ちていない");
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

    testWidgets("遊んで戻るとランキングを取り直すこと", (tester) async {
      // 自分がいま出したスコアが載らないままになるので、戻ってきたら取り直す
      final bubbleGame = MockMisskeyBubbleGame();
      final misskey = MockMisskey();
      when(misskey.bubbleGame).thenReturn(bubbleGame);
      when(bubbleGame.show(any)).thenAnswer((_) async => const []);

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
      verify(bubbleGame.show(any)).called(1);

      // 遊びに行って戻ってくる
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      // pageBackは英語のツールチップを探すので、戻るボタンを直接押す
      await tester.tap(find.byType(BackButton));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(bubbleGame.show(any)).called(1);
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
