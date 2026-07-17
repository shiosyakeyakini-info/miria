import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/chat_input_state_notifier.dart";
import "package:miria/view/chat_page/chat_file_preview.dart";
import "package:miria/view/chat_page/user_chat.dart";

import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("UserChatTextField", () {
    late MockMisskey mockMisskey;

    setUp(() {
      mockMisskey = MockMisskey();
    });

    testWidgets("ファイル添付ボタンが表示されること", (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
          ],
          child: MaterialApp(
            home: Scaffold(body: UserChatTextField(userId: TestData.user1.id)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.attach_file), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets("ファイルプレビューが表示されること", (tester) async {
      final container = ProviderContainer(
        overrides: [
          misskeyProvider.overrideWith((ref, account) => mockMisskey),
        ],
      );

      // ファイルを追加
      final binaryData = await TestData.binaryImage;
      final imageFile = ImageFile(data: binaryData, fileName: "test_image.jpg");

      container.read(chatInputStateProvider.notifier).addFile(imageFile);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: UserChatTextField(userId: TestData.user1.id)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ファイルプレビューが表示されていることを確認
      expect(find.byType(ChatFilePreview), findsOneWidget);
    });

    testWidgets("ファイルプレビューから削除できること", (tester) async {
      final container = ProviderContainer(
        overrides: [
          misskeyProvider.overrideWith((ref, account) => mockMisskey),
        ],
      );

      // ファイルを追加
      final binaryData = await TestData.binaryImage;
      final imageFile = ImageFile(data: binaryData, fileName: "test_image.jpg");

      container.read(chatInputStateProvider.notifier).addFile(imageFile);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: UserChatTextField(userId: TestData.user1.id)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ファイルプレビューが表示されていることを確認
      expect(find.byType(ChatFilePreview), findsOneWidget);

      // 削除ボタンをタップ
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // ファイルプレビューが消えることを確認
      expect(find.byType(ChatFilePreview), findsNothing);
    });

    testWidgets("テキスト入力ができること", (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
          ],
          child: MaterialApp(
            home: Scaffold(body: UserChatTextField(userId: TestData.user1.id)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // テキストを入力
      await tester.enterText(find.byType(TextField), "テストメッセージ");
      await tester.pumpAndSettle();

      // 入力されたテキストが表示されることを確認
      expect(find.text("テストメッセージ"), findsOneWidget);
    });
  });
}
