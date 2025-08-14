import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/chat_page/chat_message_item.dart";
import "package:miria/view/chat_page/chat_search_page.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("ChatSearchPage PushableListView Tests", () {
    late MockMisskey mockMisskey;
    late MockMisskeyChat mockChat;
    late MockMisskeyChatMessages mockChatMessages;

    setUp(() {
      mockMisskey = MockMisskey();
      mockChat = MockMisskeyChat();
      mockChatMessages = MockMisskeyChatMessages();

      when(mockMisskey.chat).thenReturn(mockChat);
      when(mockChat.messages).thenReturn(mockChatMessages);
    });

    testWidgets("PushableListViewで検索結果が正しく表示される", (tester) async {
      // テスト用メッセージを作成
      final testMessages = List.generate(
        3,
        (index) => ChatMessage(
          id: "msg_$index",
          createdAt: DateTime.now().subtract(Duration(minutes: index)),
          fromUserId: TestData.i1.id,
          text: "Test message $index with search term",
          reactions: [],
        ),
      );

      // APIモックをセットアップ
      when(mockChatMessages.search(any)).thenAnswer((_) async => testMessages);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyGetContextProvider.overrideWithValue(mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
          child: DefaultRootNoRouterWidget(
            child: ChatSearchPage(
              account: TestData.account,
              chatId: "test-user-id",
              isChannel: false,
              query: "search term",
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 検索結果が表示されることを確認
      expect(find.text("Test message 0 with search term"), findsOneWidget);
      expect(find.text("Test message 2 with search term"), findsOneWidget);

      // API が正しいパラメータで呼び出されることを確認
      verify(
        mockChatMessages.search(
          argThat(
            predicate<ChatMessagesSearchRequest>(
              (req) =>
                  req.query == "search term" &&
                  req.userId == "test-user-id" &&
                  req.limit == 20,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets("空の検索結果が正しく表示される", (tester) async {
      // 空の結果を返す
      when(
        mockChatMessages.search(any),
      ).thenAnswer((_) async => <ChatMessage>[]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyGetContextProvider.overrideWithValue(mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
          child: DefaultRootNoRouterWidget(
            child: ChatSearchPage(
              account: TestData.account,
              chatId: "test-user-id",
              isChannel: false,
              query: "no results",
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 検索結果のリストビューが表示される
      expect(find.byType(PushableListView<ChatMessage>), findsOneWidget);
      // メッセージアイテムは表示されない
      expect(find.byType(ChatMessageItem), findsNothing);
    });

    testWidgets("ルームチャット検索が正しく動作する", (tester) async {
      const roomId = "room:test-room-id";

      final testMessages = [
        ChatMessage(
          id: "room_msg_1",
          createdAt: DateTime.now(),
          fromUserId: TestData.user1.id,
          text: "Room message content",
          reactions: [],
        ),
      ];

      when(mockChatMessages.search(any)).thenAnswer((_) async => testMessages);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyGetContextProvider.overrideWithValue(mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
          child: DefaultRootNoRouterWidget(
            child: ChatSearchPage(
              account: TestData.account,
              chatId: roomId,
              isChannel: false,
              query: "room search",
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ルーム検索結果が表示されることを確認
      expect(find.text("Room message content"), findsOneWidget);

      // ルームID が正しく渡されることを確認
      verify(
        mockChatMessages.search(
          argThat(
            predicate<ChatMessagesSearchRequest>(
              (req) => req.query == "room search" && req.roomId == roomId,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets("検索フィールドが正しく動作する", (tester) async {
      final emptyMessages = <ChatMessage>[];

      when(mockChatMessages.search(any)).thenAnswer((_) async => emptyMessages);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyGetContextProvider.overrideWithValue(mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
          child: DefaultRootNoRouterWidget(
            child: ChatSearchPage(
              account: TestData.account,
              chatId: "test-user-id",
              isChannel: false,
              query: "",
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 初期状態では検索を促すメッセージが表示される
      expect(find.text("入れてや"), findsOneWidget);

      // 検索フィールドを見つけてテキストを入力
      final searchField = find.widgetWithText(TextField, "検索");
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, "test search");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // 検索結果のリストビューが表示される
      expect(find.byType(PushableListView<ChatMessage>), findsOneWidget);
    });

    testWidgets("リフレッシュ機能が動作する", (tester) async {
      final testMessages = [
        ChatMessage(
          id: "refresh_msg",
          createdAt: DateTime.now(),
          fromUserId: TestData.i1.id,
          text: "Refresh test message",
          reactions: [],
        ),
      ];

      when(mockChatMessages.search(any)).thenAnswer((_) async => testMessages);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyGetContextProvider.overrideWithValue(mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
          child: DefaultRootNoRouterWidget(
            child: ChatSearchPage(
              account: TestData.account,
              chatId: "test-user-id",
              isChannel: false,
              query: "refresh",
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // メッセージが表示されることを確認
      expect(find.text("Refresh test message"), findsOneWidget);

      // RefreshIndicator を見つけてリフレッシュを実行
      final refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);

      // RefreshIndicatorを手動でトリガー
      await tester.drag(refreshIndicator, const Offset(0, 300));
      await tester.pumpAndSettle();

      // 初期ロードとリフレッシュで1回のAPI呼び出しがあることを確認
      verify(mockChatMessages.search(any)).called(1);
    });
  });
}
