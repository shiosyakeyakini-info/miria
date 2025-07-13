import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/chat_page/chat_home_page.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("ChatHomePage FloatingActionButton", () {
    late MockMisskey mockMisskey;
    late MockMisskeyChat mockChat;
    late MockMisskeyChatRooms mockChatRooms;
    late AppRouter router;

    setUp(() {
      mockMisskey = MockMisskey();
      mockChat = MockMisskeyChat();
      mockChatRooms = MockMisskeyChatRooms();
      final mockInvitations = MockMisskeyChatRoomsInvitations();
      final mockStreaming = MockWebSocketController();
      final mockStreamingController = MockStreamingController();
      router = AppRouter();

      // Setup the mock hierarchy
      when(mockMisskey.chat).thenReturn(mockChat);
      when(mockChat.rooms).thenReturn(mockChatRooms);
      when(mockChatRooms.invitations).thenReturn(mockInvitations);
      when(mockMisskey.streamingService).thenReturn(mockStreaming);
      when(
        mockStreaming.stream(),
      ).thenAnswer((_) async => mockStreamingController);

      // Mock successful operations
      when(
        mockChatRooms.create(any),
      ).thenAnswer((_) async => TestData.chatRoom1);
    });

    // Create different account contexts for testing
    final normalAccountContext = AccountContext(
      getAccount: TestData.account,
      postAccount: Account(
        host: "example.miria.shiosyakeyakini.info",
        userId: "different-user",
        i: TestData.i1,
        meta: TestData.meta,
      ),
    );

    final readOnlyAccountContext = AccountContext(
      getAccount: TestData.account,
      postAccount: TestData.account, // Same account = read-only
    );

    group("FAB表示テスト", () {
      testWidgets("通常のアカウントでFABが表示される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(normalAccountContext),
            ],
            child: DefaultRootNoRouterWidget(
              child: ChatHomePage(accountContext: normalAccountContext),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // FABが表示されることを確認
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);

        // ツールチップが設定されていることを確認
        final fab = tester.widget<FloatingActionButton>(
          find.byType(FloatingActionButton),
        );
        expect(fab.tooltip, "新しいルームを作成");
      });

      testWidgets("読み取り専用アカウントでFABが非表示になる", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(readOnlyAccountContext),
            ],
            child: DefaultRootNoRouterWidget(
              child: ChatHomePage(accountContext: readOnlyAccountContext),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // FABが表示されないことを確認
        expect(find.byType(FloatingActionButton), findsNothing);
        expect(find.byIcon(Icons.add), findsNothing);
      });
    });

    group("FAB機能テスト", () {
      testWidgets("FABタップでエラーが発生しない", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(normalAccountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatHomeRoute(accountContext: normalAccountContext),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // FABが表示されることを確認
        expect(find.byType(FloatingActionButton), findsOneWidget);

        // FABをタップ
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // タップ処理が実行されることを確認（エラーが発生しない）
        expect(tester.takeException(), isNull);
      });

      testWidgets("FABが正しい位置に配置される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(normalAccountContext),
            ],
            child: DefaultRootNoRouterWidget(
              child: ChatHomePage(accountContext: normalAccountContext),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // ScaffoldのfloatingActionButtonとして配置されていることを確認
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.floatingActionButton, isA<FloatingActionButton>());
      });
    });

    group("タブ表示テスト", () {
      testWidgets("チャットホームの4つのタブが表示される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(normalAccountContext),
            ],
            child: DefaultRootNoRouterWidget(
              child: ChatHomePage(accountContext: normalAccountContext),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 4つのタブが表示されることを確認
        expect(find.text("ホーム"), findsOneWidget);
        expect(find.text("招待"), findsOneWidget);
        expect(find.text("入ってるルーム"), findsOneWidget);
        expect(find.text("自分で作ったやつ"), findsOneWidget);

        // TabBarが存在することを確認
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.byType(TabBarView), findsOneWidget);
      });

      testWidgets("初期タブが正しく設定される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(normalAccountContext),
            ],
            child: DefaultRootNoRouterWidget(
              child: ChatHomePage(
                accountContext: normalAccountContext,
                initialTab: 2, // "入ってるルーム"タブ
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // TabControllerが正しく設定されていることを確認
        final tabController = DefaultTabController.of(
          tester.element(find.byType(TabBarView)),
        );
        expect(tabController.index, 2);
      });
    });

    group("AppBar表示テスト", () {
      testWidgets("AppBarとTabBarが正しく表示される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(normalAccountContext),
            ],
            child: DefaultRootNoRouterWidget(
              child: ChatHomePage(accountContext: normalAccountContext),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // AppBarが表示されることを確認
        expect(find.byType(AppBar), findsOneWidget);

        // AppBarのbottomプロパティとしてTabBarが設定されていることを確認
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.bottom, isA<TabBar>());
      });
    });

    group("レスポンシブレイアウトテスト", () {
      testWidgets("異なる画面サイズでもFABが正しく表示される", (tester) async {
        // 小さい画面サイズでテスト
        await tester.binding.setSurfaceSize(const Size(400, 600));

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(normalAccountContext),
            ],
            child: DefaultRootNoRouterWidget(
              child: ChatHomePage(accountContext: normalAccountContext),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // FABが表示されることを確認
        expect(find.byType(FloatingActionButton), findsOneWidget);

        // 大きい画面サイズでテスト
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpAndSettle();

        // FABが引き続き表示されることを確認
        expect(find.byType(FloatingActionButton), findsOneWidget);

        // デフォルトサイズに戻す
        addTearDown(() => tester.binding.setSurfaceSize(null));
      });
    });
  });
}
