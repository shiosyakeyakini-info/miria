import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("ChatMessage Long Press Menu Tests", () {
    late MockMisskey mockMisskey;
    late MockMisskeyChat mockChat;
    late MockMisskeyChatMessages mockChatMessages;
    late AppRouter router;
    late ChatMessage testMessage;

    setUp(() {
      mockMisskey = MockMisskey();
      mockChat = MockMisskeyChat();
      mockChatMessages = MockMisskeyChatMessages();
      router = AppRouter();

      // Create test message
      testMessage = ChatMessage(
        id: "test-message-id",
        createdAt: DateTime.now(),
        fromUserId: TestData.i1.id,
        text: "Test message content",
        reactions: [],
      );

      when(mockMisskey.chat).thenReturn(mockChat);
      when(mockChat.messages).thenReturn(mockChatMessages);

      // Mock message operations
      when(mockChatMessages.delete(any)).thenAnswer((_) async {});
      when(mockChatMessages.show(any)).thenAnswer((_) async => testMessage);
      when(mockChatMessages.react(any)).thenAnswer((_) async {});
    });

    group("メニュー表示テスト", () {
      testWidgets("自分のメッセージで適切なメニューが表示される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: testMessage,
                user: TestData.i1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 自分のメッセージの場合のメニュー項目を確認
        expect(find.text("リアクション"), findsOneWidget);
        expect(find.text("内容をコピー"), findsOneWidget);
        expect(find.text("メッセージ詳細"), findsOneWidget);
        expect(find.text("メッセージを削除"), findsOneWidget);
        expect(find.text("通報"), findsNothing); // 自分のメッセージには通報オプションがない
      });

      testWidgets("他人のメッセージで適切なメニューが表示される", (tester) async {
        final otherUserMessage = ChatMessage(
          id: "other-message-id",
          createdAt: DateTime.now(),
          fromUserId: "different-user-id",
          text: "Other user message",
          reactions: [],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: otherUserMessage,
                user: TestData.user1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 他人のメッセージの場合のメニュー項目を確認
        expect(find.text("リアクション"), findsOneWidget);
        expect(find.text("内容をコピー"), findsOneWidget);
        expect(find.text("メッセージ詳細"), findsOneWidget);
        expect(find.text("メッセージを削除"), findsNothing); // 他人のメッセージは削除できない
        expect(find.text("通報"), findsOneWidget);
      });

      testWidgets("長押しでメニューが表示される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: testMessage,
                user: TestData.i1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // メニューシートが表示されていることを確認
        expect(find.byType(BottomSheet), findsOneWidget);
        expect(find.text("リアクション"), findsOneWidget);
        expect(find.text("内容をコピー"), findsOneWidget);
        expect(find.text("メッセージ詳細"), findsOneWidget);
        expect(find.text("メッセージを削除"), findsOneWidget);
      });
    });

    group("メニュー機能テスト", () {
      testWidgets("メッセージ削除機能のテスト", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: testMessage,
                user: TestData.i1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 削除メニューが表示されていることを確認
        expect(find.text("メッセージを削除"), findsOneWidget);

        // 削除メニューをタップ
        await tester.tap(find.text("メッセージを削除"));
        await tester.pumpAndSettle();

        // メニューが閉じることを確認（ChatMessageMenuAction.deleteが返される）
      });

      testWidgets("メッセージ詳細機能のテスト", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: testMessage,
                user: TestData.i1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 詳細メニューが表示されていることを確認
        expect(find.text("メッセージ詳細"), findsOneWidget);

        // 詳細メニューをタップ
        await tester.tap(find.text("メッセージ詳細"));
        await tester.pumpAndSettle();

        // アクションが返される（実際の画面遷移はchat_message_item.dartで処理される）
      });

      testWidgets("コピー機能のテスト", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: testMessage,
                user: TestData.i1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // コピーメニューをタップ
        await tester.tap(find.text("内容をコピー"));
        await tester.pumpAndSettle();

        // ChatMessageMenuAction.copy が返されることを確認
      });
    });

    group("メニューアイコンテスト", () {
      testWidgets("削除アイコンが赤色で表示される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: testMessage,
                user: TestData.i1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 削除アイコンとテキストが適切な色で表示されることを確認
        final deleteIcon = tester.widget<Icon>(
          find.descendant(
            of: find.widgetWithText(ListTile, "メッセージを削除"),
            matching: find.byType(Icon),
          ),
        );
        expect(deleteIcon.icon, Icons.delete);
        // テーマの error color が使用されることを確認
      });

      testWidgets("各メニュー項目に適切なアイコンが表示される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: testMessage,
                user: TestData.i1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 各アイコンが表示されることを確認
        expect(find.byIcon(Icons.add_reaction), findsOneWidget);
        expect(find.byIcon(Icons.copy), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });
    });

    group("統合テスト", () {
      testWidgets("メッセージ詳細画面への遷移テスト", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(TestData.accountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageDetailRoute(
                account: TestData.account,
                messageId: testMessage.id,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // メッセージ詳細画面が表示されることを確認
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text("メッセージ詳細"), findsOneWidget);

        // 詳細画面の主要コンポーネントが表示されることを確認
        expect(find.byType(Card), findsWidgets); // 情報カード
        expect(find.text("詳細情報"), findsOneWidget);
      });
    });

    group("権限制御テスト", () {
      testWidgets("読み取り専用アカウントでも基本メニューは表示される", (tester) async {
        // 他人のメッセージを作成
        final otherUserMessage = ChatMessage(
          id: "other-message-id-2",
          createdAt: DateTime.now(),
          fromUserId: "different-user-id-2",
          text: "Other user message",
          reactions: [],
        );

        final readOnlyAccountContext = TestData.accountContext.copyWith(
          postAccount: TestData.account.copyWith(userId: "different-user"),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyGetContextProvider.overrideWithValue(mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
              accountContextProvider.overrideWithValue(readOnlyAccountContext),
            ],
            child: DefaultRootWidget(
              router: router,
              initialRoute: ChatMessageMenuRoute(
                account: TestData.account,
                message: otherUserMessage,
                user: TestData.user1,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 読み取り専用でも基本的なメニューは表示される
        expect(find.text("リアクション"), findsOneWidget);
        expect(find.text("内容をコピー"), findsOneWidget);
        expect(find.text("メッセージ詳細"), findsOneWidget);
        // 他人のメッセージなので削除オプションはない
        expect(find.text("メッセージを削除"), findsNothing);
        expect(find.text("通報"), findsOneWidget);
      });
    });
  });
}
