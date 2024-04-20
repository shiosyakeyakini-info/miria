import "package:auto_route/auto_route.dart";
import "package:dio/dio.dart";
import "package:file/memory.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/misskey_post_file.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/chat_input_state_notifier.dart";
import "package:miria/view/note_create_page/drive_modal_sheet.dart";
import "package:misskey_dart/misskey_dart.dart" show DriveFile;
import "package:mockito/mockito.dart";
import "package:path/path.dart" as p;

import "../test_util/mock.mocks.dart";
import "../test_util/test_datas.dart";

// TestAppRouterを定義
class TestAppRouter extends AppRouter {
  DriveModalSheetReturnValue? driveModalReturnValue;
  List<DriveFile>? driveFileSelectReturnValue;

  @override
  Future<T?> push<T extends Object?>(
    PageRouteInfo<Object?> route, {
    void Function(NavigationFailure)? onFailure,
  }) async {
    if (route is DriveModalRoute) {
      return driveModalReturnValue as T?;
    } else if (route is DriveFileSelectRoute) {
      return driveFileSelectReturnValue as T?;
    }
    return null;
  }
}

void main() {
  group("ChatInputStateNotifier", () {
    late ProviderContainer container;
    late MockMisskey mockMisskey;
    late MockMisskeyDrive mockDrive;
    late MockMisskeyDriveFiles mockDriveFiles;
    late MockFilePickerPlatform mockFilePicker;
    late TestAppRouter testRouter;
    late MockDio mockDio;
    late MemoryFileSystem fileSystem;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      // path_providerをモック
      const MethodChannel(
        "plugins.flutter.io/path_provider",
      ).setMockMethodCallHandler((methodCall) async {
        if (methodCall.method == "getTemporaryDirectory") {
          return "/tmp";
        }
        return null;
      });
    });

    setUp(() {
      mockMisskey = MockMisskey();
      mockDrive = MockMisskeyDrive();
      mockDriveFiles = MockMisskeyDriveFiles();
      mockFilePicker = MockFilePickerPlatform();
      testRouter = TestAppRouter();
      mockDio = MockDio();
      fileSystem = MemoryFileSystem();

      when(mockMisskey.drive).thenReturn(mockDrive);
      when(mockDrive.files).thenReturn(mockDriveFiles);

      FilePicker.platform = mockFilePicker;

      container = ProviderContainer(
        overrides: [
          misskeyProvider.overrideWith((ref, account) => mockMisskey),
          misskeyPostContextProvider.overrideWithValue(mockMisskey),
          fileSystemProvider.overrideWithValue(fileSystem),
          accountContextProvider.overrideWithValue(TestData.accountContext),
          appRouterProvider.overrideWithValue(testRouter),
          dioProvider.overrideWithValue(mockDio),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group("初期状態", () {
      test("初期状態でファイルが空であること", () {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );
        final state = container.read(chatInputStateNotifierProvider);

        expect(state.files, isEmpty);
      });
    });

    group("ファイル追加", () {
      test("画像ファイルを追加できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        final imageFile = PostFile.file(fileSystem.file("test_image.jpg"));

        await notifier.addFile(imageFile);

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<PostFile>());
        expect(state.files.first.fileName, "test_image.jpg");
      });

      test("その他ファイルを追加できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        final unknownFile = PostFile.file(fileSystem.file("test_document.pdf"));

        await notifier.addFile(unknownFile);

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<PostFile>());
        expect(state.files.first.fileName, "test_document.pdf");
      });
    });

    group("ファイル削除", () {
      test("ファイルを削除できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ファイルを追加
        final imageFile = PostFile.file(fileSystem.file("test_image.jpg"));
        await notifier.addFile(imageFile);

        // 削除
        notifier.removeFile(0);

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files, isEmpty);
      });

      test("範囲外のインデックスでも例外が発生しないこと", () {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        expect(() => notifier.removeFile(0), returnsNormally);
        expect(() => notifier.removeFile(99), returnsNormally);
      });
    });

    group("ファイル選択", () {
      test("JPEGファイルを選択できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブモーダルのモック（アップロードを選択）
        testRouter.driveModalReturnValue =
            DriveModalSheetReturnValue.uploadFile;

        // モックファイルの設定
        final mockFile = PlatformFile(
          name: "test_image.jpg",
          size: 1024,
          path: "/test/path/test_image.jpg",
        );

        when(
          mockFilePicker.pickFiles(type: FileType.any, allowMultiple: false),
        ).thenAnswer((_) async => FilePickerResult([mockFile]));

        // ファイルシステムにファイルを作成
        final file = fileSystem.file("/test/path/test_image.jpg");
        file.createSync(recursive: true);
        final binaryData = await TestData.binaryImage;
        file.writeAsBytesSync(binaryData);

        await notifier.chooseFile();

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<PostFile>());
        expect(state.files.first.fileName, "test_image.jpg");
      });

      test("HEICファイルをJPEGに変換して選択できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブモーダルのモック（アップロードを選択）
        testRouter.driveModalReturnValue =
            DriveModalSheetReturnValue.uploadFile;

        // モックファイルの設定
        final mockFile = PlatformFile(
          name: "test_image.heic",
          size: 1024,
          path: "/test/path/test_image.heic",
        );

        when(
          mockFilePicker.pickFiles(type: FileType.any, allowMultiple: false),
        ).thenAnswer((_) async => FilePickerResult([mockFile]));

        // ファイルシステムにファイルを作成
        final file = fileSystem.file("/test/path/test_image.heic");
        file.createSync(recursive: true);
        final binaryData = await TestData.binaryImage;
        file.writeAsBytesSync(binaryData);

        // HEICからJPEG変換用の一時ディレクトリを作成
        final tmpDir = fileSystem.directory("/tmp");
        tmpDir.createSync(recursive: true);

        await notifier.chooseFile();

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<PostFile>());
        expect(p.extension(state.files.first.fileName), ".jpg");
      });

      test("その他ファイルを選択できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブモーダルのモック（アップロードを選択）
        testRouter.driveModalReturnValue =
            DriveModalSheetReturnValue.uploadFile;

        // モックファイルの設定
        final mockFile = PlatformFile(
          name: "document.pdf",
          size: 1024,
          path: "/test/path/document.pdf",
        );

        when(
          mockFilePicker.pickFiles(type: FileType.any, allowMultiple: false),
        ).thenAnswer((_) async => FilePickerResult([mockFile]));

        // ファイルシステムにファイルを作成
        final file = fileSystem.file("/test/path/document.pdf");
        file.createSync(recursive: true);
        file.writeAsBytesSync([1, 2, 3, 4]);

        await notifier.chooseFile();

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<PostFile>());
        expect(state.files.first.fileName, "document.pdf");
      });

      test("ファイル選択がキャンセルされた場合は何も追加されないこと", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブモーダルのモック（アップロードを選択）
        testRouter.driveModalReturnValue =
            DriveModalSheetReturnValue.uploadFile;

        when(
          mockFilePicker.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ["jpg", "jpeg", "png", "gif", "mp4", "webm"],
          ),
        ).thenAnswer((_) async => null);

        await notifier.chooseFile();

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files, isEmpty);
      });

      test("ドライブから画像ファイルを選択できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブモーダルのモック（ドライブを選択）
        testRouter.driveModalReturnValue = DriveModalSheetReturnValue.drive;

        // ドライブファイル選択のモック
        testRouter.driveFileSelectReturnValue = [TestData.drive1];

        // ファイルダウンロードのモック
        final binaryData = await TestData.binaryImage;
        when(
          mockDio.get<Uint8List>(
            TestData.drive1.url,
            options: anyNamed("options"),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: binaryData,
            statusCode: 200,
            requestOptions: RequestOptions(path: TestData.drive1.url),
          ),
        );

        await notifier.chooseFile();

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<AlreadyPostedFile>());
        expect(state.files.first.fileName, TestData.drive1.name);
      });

      test("ドライブからその他ファイルを選択できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブモーダルのモック（ドライブを選択）
        testRouter.driveModalReturnValue = DriveModalSheetReturnValue.drive;

        // ドライブファイル選択のモック
        testRouter.driveFileSelectReturnValue = [TestData.drive2AsVideo];

        await notifier.chooseFile();

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 1);
        expect(state.files.first, isA<AlreadyPostedFile>());
        expect(state.files.first.fileName, TestData.drive2AsVideo.name);
      });

      test("ドライブファイル選択がキャンセルされた場合は何も追加されないこと", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブモーダルのモック（ドライブを選択）
        testRouter.driveModalReturnValue = DriveModalSheetReturnValue.drive;

        // ドライブファイル選択のモック（キャンセル）
        testRouter.driveFileSelectReturnValue = null;

        await notifier.chooseFile();

        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files, isEmpty);
      });
    });

    group("ファイルアップロード", () {
      test("画像ファイルをアップロードしてファイルIDを取得できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブファイル作成のモック
        when(
          mockDriveFiles.createAsBinary(any, any),
        ).thenAnswer((_) async => TestData.drive1);

        // ファイルを追加
        final file = fileSystem.file("/test/path/test_image.jpg")
          ..createSync(recursive: true);
        final binaryData = await TestData.binaryImage;
        file.writeAsBytesSync(binaryData);
        final imageFile = PostFile.file(file);
        await notifier.addFile(imageFile);

        // アップロードを実行
        final fileId = await notifier.uploadAndGetFileId();

        expect(fileId, TestData.drive1.id);
        verify(mockDriveFiles.createAsBinary(any, any)).called(1);

        // ファイルがクリアされることを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files, isEmpty);
      });

      test("その他ファイルをアップロードしてファイルIDを取得できること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // ドライブファイル作成のモック
        when(
          mockDriveFiles.createAsBinary(any, any),
        ).thenAnswer((_) async => TestData.drive2AsVideo);

        // ファイルを追加
        final file = fileSystem.file("/test/path/test_document.jpg")
          ..createSync(recursive: true)
          ..writeAsBytesSync(Uint8List.fromList([1, 2, 3, 4]));
        final unknownFile = PostFile.file(file);
        await notifier.addFile(unknownFile);

        // アップロードを実行
        final fileId = await notifier.uploadAndGetFileId();

        expect(fileId, TestData.drive2AsVideo.id);
        verify(mockDriveFiles.createAsBinary(any, any)).called(1);

        // ファイルがクリアされることを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files, isEmpty);
      });

      test("ファイルがない場合はnullを返すこと", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        final fileId = await notifier.uploadAndGetFileId();

        expect(fileId, isNull);
        verifyNever(mockDriveFiles.createAsBinary(any, any));
      });

      test("既存のファイルIDがある場合はそのままIDを返すこと", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // 既存ファイルを追加
        final existingFile = AlreadyPostedFile.file(
          TestData.drive1.copyWith(
            id: "existing-file-id",
            name: "existing_image.jpg",
          ),
        );
        await notifier.addFile(existingFile);

        // アップロードを実行
        final fileId = await notifier.uploadAndGetFileId();

        expect(fileId, "existing-file-id");
        verifyNever(mockDriveFiles.createAsBinary(any, any));

        // ファイルがクリアされることを確認
        final state = container.read(chatInputStateNotifierProvider);
        expect(state.files, isEmpty);
      });
    });

    group("ファイルクリア", () {
      test("すべてのファイルをクリアできること", () async {
        final notifier = container.read(
          chatInputStateNotifierProvider.notifier,
        );

        // 複数ファイルを追加
        await notifier.addFile(PostFile.file(fileSystem.file("image1.jpg")));
        await notifier.addFile(PostFile.file(fileSystem.file("document.pdf")));

        // クリア前の確認
        var state = container.read(chatInputStateNotifierProvider);
        expect(state.files.length, 2);

        // クリア実行
        notifier.clearFiles();

        // クリア後の確認
        state = container.read(chatInputStateNotifierProvider);
        expect(state.files, isEmpty);
      });
    });
  });
}
