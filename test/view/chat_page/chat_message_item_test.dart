import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/chat_page/chat_message_item.dart";
import "package:miria/view/common/misskey_notes/misskey_file_view.dart";
import "package:misskey_dart/misskey_dart.dart";

import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("ChatMessageItem", () {
    late MockMisskey mockMisskey;

    setUp(() {
      mockMisskey = MockMisskey();
    });

    testWidgets("テキストメッセージが表示されること", (tester) async {
      final testMessage = ChatMessage(
        id: "test-message-1",
        createdAt: DateTime.now(),
        fromUserId: "test-user",
        fromUser: TestData.user1,
        text: "テストメッセージ",
        reactions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ChatMessageItem(
                message: testMessage,
                user: TestData.user1,
                isMyMessage: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text("テストメッセージ"), findsOneWidget);
    });

    testWidgets("ファイル付きメッセージが表示されること", (tester) async {
      final testMessage = ChatMessage(
        id: "test-message-2",
        createdAt: DateTime.now(),
        fromUserId: "test-user",
        fromUser: TestData.user1,
        text: "画像メッセージ",
        file: TestData.drive1,
        reactions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ChatMessageItem(
                message: testMessage,
                user: TestData.user1,
                isMyMessage: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text("画像メッセージ"), findsOneWidget);
      expect(find.byType(MisskeyFileView), findsOneWidget);
    });

    testWidgets("ファイルのみのメッセージが表示されること", (tester) async {
      final testMessage = ChatMessage(
        id: "test-message-3",
        createdAt: DateTime.now(),
        fromUserId: "test-user",
        fromUser: TestData.user1,
        text: null,
        file: TestData.drive1,
        reactions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ChatMessageItem(
                message: testMessage,
                user: TestData.user1,
                isMyMessage: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(MisskeyFileView), findsOneWidget);
      expect(find.text("テストメッセージ"), findsNothing);
    });

    testWidgets("自分のメッセージが右寄せで表示されること", (tester) async {
      final testMessage = ChatMessage(
        id: "test-message-4",
        createdAt: DateTime.now(),
        fromUserId: TestData.account.userId,
        fromUser: TestData.user1,
        text: "自分のメッセージ",
        reactions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ChatMessageItem(
                message: testMessage,
                user: null,
                isMyMessage: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text("自分のメッセージ"), findsOneWidget);

      // 右寄せ（Align with Alignment.topRight）であることを確認
      final align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, Alignment.topRight);
    });

    testWidgets("他の人のメッセージが左寄せで表示されること", (tester) async {
      final testMessage = ChatMessage(
        id: "test-message-5",
        createdAt: DateTime.now(),
        fromUserId: "other-user",
        fromUser: TestData.user1,
        text: "他の人のメッセージ",
        reactions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ChatMessageItem(
                message: testMessage,
                user: TestData.user1,
                isMyMessage: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text("他の人のメッセージ"), findsOneWidget);

      // Row（左寄せレイアウト）であることを確認
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets("空のテキストでファイルのみの場合に適切に表示されること", (tester) async {
      final testMessage = ChatMessage(
        id: "test-message-6",
        createdAt: DateTime.now(),
        fromUserId: "test-user",
        fromUser: TestData.user1,
        text: "",
        file: TestData.drive1,
        reactions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ChatMessageItem(
                message: testMessage,
                user: TestData.user1,
                isMyMessage: false,
              ),
            ),
          ),
        ),
      );

      // 空文字の場合はテキストを表示しない
      expect(find.byType(MisskeyFileView), findsOneWidget);
    });
  });
}
