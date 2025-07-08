import "dart:typed_data";

import "package:file/memory.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/chat_input_state_notifier.dart";
import "package:miria/view/chat_page/chat_file_preview.dart";
import "package:miria/view/chat_page/chat_message_item.dart";
import "package:miria/view/chat_page/user_chat.dart";
import "package:miria/view/common/misskey_notes/misskey_file_view.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("チャット機能統合テスト", () {
    late MockMisskey mockMisskey;
    late MockMisskeyDrive mockDrive;
    late MockMisskeyDriveFiles mockDriveFiles;
    late MockFilePickerPlatform mockFilePicker;
    late MemoryFileSystem fileSystem;

    setUp(() {
      mockMisskey = MockMisskey();
      mockDrive = MockMisskeyDrive();
      mockDriveFiles = MockMisskeyDriveFiles();
      mockFilePicker = MockFilePickerPlatform();
      fileSystem = MemoryFileSystem();

      when(mockMisskey.drive).thenReturn(mockDrive);
      when(mockDrive.files).thenReturn(mockDriveFiles);

      FilePicker.platform = mockFilePicker;
    });

    group("チャットメッセージ表示機能", () {
      testWidgets("テキストのみのメッセージが正しく表示される", (tester) async {
        final testMessage = ChatMessage(
          id: "test-message-1",
          createdAt: DateTime.now(),
          fromUserId: "test-user",
          fromUser: TestData.user1,
          text: "テストメッセージです",
          reactions: [],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
            ],
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: ChatMessageItem(
                  message: testMessage,
                  user: TestData.user1,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
        );

        expect(find.text("テストメッセージです"), findsOneWidget);
        expect(find.byType(MisskeyFileView), findsNothing);
      });

      testWidgets("画像ファイル付きのメッセージが正しく表示される", (tester) async {
        final testMessage = ChatMessage(
          id: "test-message-2",
          createdAt: DateTime.now(),
          fromUserId: "test-user",
          fromUser: TestData.user1,
          text: "画像を送ります",
          file: TestData.drive1,
          reactions: [],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
            ],
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: ChatMessageItem(
                  message: testMessage,
                  user: TestData.user1,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
        );

        expect(find.text("画像を送ります"), findsOneWidget);
        expect(find.byType(MisskeyFileView), findsOneWidget);
      });

      testWidgets("ファイルのみのメッセージ（テキストなし）が正しく表示される", (tester) async {
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
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
            ],
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
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
        // テキストがnullの場合はテキスト要素が表示されない
      });

      testWidgets("自分のメッセージが右寄せで表示される", (tester) async {
        final testMessage = ChatMessage(
          id: "test-message-4",
          createdAt: DateTime.now(),
          fromUserId: TestData.account.userId,
          fromUser: TestData.user1,
          text: "自分のメッセージです",
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

        expect(find.text("自分のメッセージです"), findsOneWidget);
        expect(find.byType(Align), findsWidgets);
        final align = tester.widget<Align>(find.byType(Align).first);
        expect(align.alignment, Alignment.topRight);
      });

      testWidgets("他人のメッセージが左寄せで表示される", (tester) async {
        final testMessage = ChatMessage(
          id: "test-message-5",
          createdAt: DateTime.now(),
          fromUserId: "other-user",
          fromUser: TestData.user1,
          text: "他人のメッセージです",
          reactions: [],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
            ],
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: ChatMessageItem(
                  message: testMessage,
                  user: TestData.user1,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
        );

        expect(find.text("他人のメッセージです"), findsOneWidget);
        expect(find.byType(Row), findsWidgets);
      });
    });

    group("ファイル添付・プレビュー機能", () {
      testWidgets("ファイル添付ボタンが表示される", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
            ],
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.attach_file), findsOneWidget);
        expect(find.byIcon(Icons.send), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets("画像ファイルを追加するとプレビューが表示される", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
          ],
        );

        // 画像ファイルを追加
        final binaryData = await TestData.binaryImage;
        final imageFile = ImageFile(
          data: binaryData,
          fileName: "test_image.jpg",
        );

        container
            .read(chatInputStateNotifierProvider.notifier)
            .addFile(imageFile);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        expect(find.byType(ChatFilePreview), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets("NSFWファイルにはNSFWラベルが表示される", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
          ],
        );

        // NSFWファイルを追加
        final binaryData = await TestData.binaryImage;
        final nsfwFile = ImageFile(
          data: binaryData,
          fileName: "nsfw_image.jpg",
          isNsfw: true,
        );

        container
            .read(chatInputStateNotifierProvider.notifier)
            .addFile(nsfwFile);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        expect(find.byType(ChatFilePreview), findsOneWidget);
        expect(find.text("NSFW"), findsOneWidget);
      });

      testWidgets("その他ファイルはファイルアイコンで表示される", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
          ],
        );

        // その他ファイルを追加
        final unknownFile = UnknownFile(
          data: Uint8List.fromList([1, 2, 3, 4]),
          fileName: "document.pdf",
        );

        container
            .read(chatInputStateNotifierProvider.notifier)
            .addFile(unknownFile);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        expect(find.byType(ChatFilePreview), findsOneWidget);
        expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
        expect(find.text("document.pdf"), findsOneWidget);
      });

      testWidgets("ファイルプレビューの削除ボタンが動作する", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
          ],
        );

        // ファイルを追加
        final binaryData = await TestData.binaryImage;
        final imageFile = ImageFile(
          data: binaryData,
          fileName: "test_image.jpg",
        );

        container
            .read(chatInputStateNotifierProvider.notifier)
            .addFile(imageFile);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        // ファイルプレビューが表示されていることを確認
        expect(find.byType(ChatFilePreview), findsOneWidget);

        // 削除ボタンをタップ
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        // ファイルプレビューが削除されることを確認
        expect(find.byType(ChatFilePreview), findsNothing);
      });
    });

    group("ファイル選択機能", () {
      testWidgets("JPEGファイルの選択が動作する", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            fileSystemProvider.overrideWithValue(fileSystem),
          ],
        );

        // モックファイルの設定
        final mockFile = PlatformFile(
          name: "test_image.jpg",
          size: 1024,
          path: "/test/path/test_image.jpg",
        );

        when(
          mockFilePicker.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ["jpg", "jpeg", "png", "gif", "mp4", "webm"],
          ),
        ).thenAnswer((_) async => FilePickerResult([mockFile]));

        // ファイルシステムにファイルを作成
        final file = fileSystem.file("/test/path/test_image.jpg");
        file.createSync(recursive: true);
        final binaryData = await TestData.binaryImage;
        file.writeAsBytesSync(binaryData);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        // ファイル添付ボタンをタップ
        await tester.tap(find.byIcon(Icons.attach_file));
        await tester.pumpAndSettle();

        // ファイルが追加されたことを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<ImageFile>());
        expect(state.files.first.fileName, "test_image.jpg");
      });

      testWidgets("HEICファイルがJPEGに変換される", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            fileSystemProvider.overrideWithValue(fileSystem),
          ],
        );

        // モックファイルの設定
        final mockFile = PlatformFile(
          name: "test_image.heic",
          size: 1024,
          path: "/test/path/test_image.heic",
        );

        when(
          mockFilePicker.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ["jpg", "jpeg", "png", "gif", "mp4", "webm"],
          ),
        ).thenAnswer((_) async => FilePickerResult([mockFile]));

        // ファイルシステムにファイルを作成
        final file = fileSystem.file("/test/path/test_image.heic");
        file.createSync(recursive: true);
        final binaryData = await TestData.binaryImage;
        file.writeAsBytesSync(binaryData);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        // ファイル添付ボタンをタップ
        await tester.tap(find.byIcon(Icons.attach_file));
        await tester.pumpAndSettle();

        // ファイルが追加され、JPEGに変換されたことを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<ImageFile>());
        expect(state.files.first.fileName.endsWith(".jpg"), isTrue);
      });

      testWidgets("その他ファイルの選択が動作する", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            fileSystemProvider.overrideWithValue(fileSystem),
          ],
        );

        // モックファイルの設定
        final mockFile = PlatformFile(
          name: "document.pdf",
          size: 1024,
          path: "/test/path/document.pdf",
        );

        when(
          mockFilePicker.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ["jpg", "jpeg", "png", "gif", "mp4", "webm"],
          ),
        ).thenAnswer((_) async => FilePickerResult([mockFile]));

        // ファイルシステムにファイルを作成
        final file = fileSystem.file("/test/path/document.pdf");
        file.createSync(recursive: true);
        file.writeAsBytesSync([1, 2, 3, 4]);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        // ファイル添付ボタンをタップ
        await tester.tap(find.byIcon(Icons.attach_file));
        await tester.pumpAndSettle();

        // ファイルが追加されたことを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<UnknownFile>());
        expect(state.files.first.fileName, "document.pdf");
      });

      testWidgets("ファイル選択がキャンセルされた場合は何も追加されない", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            fileSystemProvider.overrideWithValue(fileSystem),
          ],
        );

        when(
          mockFilePicker.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ["jpg", "jpeg", "png", "gif", "mp4", "webm"],
          ),
        ).thenAnswer((_) async => null);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        // ファイル添付ボタンをタップ
        await tester.tap(find.byIcon(Icons.attach_file));
        await tester.pumpAndSettle();

        // ファイルが追加されていないことを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.isEmpty, isTrue);
      });
    });

    group("テキスト入力機能", () {
      testWidgets("テキスト入力が正常に動作する", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
            ],
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        // テキストを入力
        await tester.enterText(find.byType(TextField), "テストメッセージの入力");
        await tester.pumpAndSettle();

        // 入力されたテキストが表示されることを確認
        expect(find.text("テストメッセージの入力"), findsOneWidget);
      });

      testWidgets("複数行のテキスト入力が動作する", (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyPostContextProvider.overrideWithValue(mockMisskey),
            ],
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: UserChatTextField(userId: TestData.user1.id),
              ),
            ),
          ),
        );

        // 複数行のテキストを入力
        await tester.enterText(find.byType(TextField), "1行目\\n2行目\\n3行目");
        await tester.pumpAndSettle();

        // 入力されたテキストが表示されることを確認
        expect(find.text("1行目\\n2行目\\n3行目"), findsOneWidget);
      });
    });

    group("ファイルアップロード機能", () {
      testWidgets("画像ファイルのアップロードが動作する", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
        );

        // ドライブファイル作成のモック
        when(
          mockDriveFiles.createAsBinary(any, any),
        ).thenAnswer((_) async => TestData.drive1);

        // ファイルを追加
        final binaryData = await TestData.binaryImage;
        final imageFile = ImageFile(
          data: binaryData,
          fileName: "test_image.jpg",
        );

        container
            .read(chatInputStateNotifierProvider.notifier)
            .addFile(imageFile);

        // アップロードを実行
        final fileId = await container
            .read(chatInputStateNotifierProvider.notifier)
            .uploadAndGetFileId();

        expect(fileId, TestData.drive1.id);
        verify(mockDriveFiles.createAsBinary(any, any)).called(1);

        // ファイルがクリアされることを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.isEmpty, isTrue);
      });

      testWidgets("その他ファイルのアップロードが動作する", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
        );

        // ドライブファイル作成のモック
        when(
          mockDriveFiles.createAsBinary(any, any),
        ).thenAnswer((_) async => TestData.drive2AsVideo);

        // ファイルを追加
        final unknownFile = UnknownFile(
          data: Uint8List.fromList([1, 2, 3, 4]),
          fileName: "document.pdf",
        );

        container
            .read(chatInputStateNotifierProvider.notifier)
            .addFile(unknownFile);

        // アップロードを実行
        final fileId = await container
            .read(chatInputStateNotifierProvider.notifier)
            .uploadAndGetFileId();

        expect(fileId, TestData.drive2AsVideo.id);
        verify(mockDriveFiles.createAsBinary(any, any)).called(1);

        // ファイルがクリアされることを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.isEmpty, isTrue);
      });

      testWidgets("ファイルなしの場合はnullが返される", (tester) async {
        final container = ProviderContainer(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
            accountContextProvider.overrideWithValue(TestData.accountContext),
          ],
        );

        // アップロードを実行（ファイルなし）
        final fileId = await container
            .read(chatInputStateNotifierProvider.notifier)
            .uploadAndGetFileId();

        expect(fileId, isNull);
        verifyNever(mockDriveFiles.createAsBinary(any, any));
      });
    });
  });
}
