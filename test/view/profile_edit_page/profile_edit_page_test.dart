import "dart:async";
import "dart:typed_data";

import "package:file_picker/src/platform/file_picker_platform_interface.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/profile_edit_page/edit_profile_state_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

// Mock for FilePicker
class MockFilePicker extends Mock implements FilePickerPlatform {}

// Test implementation of EditProfileStateNotifier
class TestEditProfileStateNotifier extends EditProfileStateNotifier {
  final EditProfileState _initialState;

  TestEditProfileStateNotifier(this._initialState);

  @override
  Future<EditProfileState> build() async {
    return _initialState;
  }
}

void main() {
  group("ProfileEditPage", () {
    late MockMisskey mockMisskey;
    late MockMisskeyI mockMisskeyI;
    late MockMisskeyDrive mockMisskeyDrive;
    late MockMisskeyDriveFiles mockMisskeyDriveFiles;
    late Account testAccount;

    setUp(() {
      mockMisskey = MockMisskey();
      mockMisskeyI = MockMisskeyI();
      mockMisskeyDrive = MockMisskeyDrive();
      mockMisskeyDriveFiles = MockMisskeyDriveFiles();
      testAccount = TestData.account;

      when(mockMisskey.i).thenReturn(mockMisskeyI);
      when(mockMisskey.drive).thenReturn(mockMisskeyDrive);
      when(mockMisskeyDrive.files).thenReturn(mockMisskeyDriveFiles);
    });

    Widget createTestWidget({
      required Account account,
      EditProfileState? initialState,
    }) {
      final router = AppRouter();
      final container = ProviderContainer(
        overrides: [
          misskeyGetContextProvider.overrideWithValue(mockMisskey),
          misskeyPostContextProvider.overrideWithValue(mockMisskey),
          // プロバイダーの初期状態を直接設定
          if (initialState != null)
            editProfileStateProvider.overrideWith(
              () => TestEditProfileStateNotifier(initialState),
            ),
        ],
      );

      return UncontrolledProviderScope(
        container: container,
        child: DefaultRootWidget(
          router: router,
          initialRoute: ProfileEditRoute(account: account),
        ),
      );
    }

    testWidgets("プロフィール編集画面が表示される", (tester) async {
      // Mock the initial data load
      when(mockMisskeyI.i()).thenAnswer(
        (_) async => TestData.i1.copyWith(
          name: "Test User",
          description: "Test description",
          location: "Tokyo",
          birthday: DateTime(2000, 1, 1),
          fields: [
            const UserField(name: "Field 1", value: "Value 1"),
            const UserField(name: "Field 2", value: "Value 2"),
          ],
          followedMessage: "Thanks for following!",
        ),
      );

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // 画面要素が表示されることを確認
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(find.byType(TextField), findsAtLeastNWidgets(1));
      expect(find.text("Test User"), findsOneWidget);
      expect(find.text("Test description"), findsOneWidget);
    });

    testWidgets("名前と自己紹介を変更できる", (tester) async {
      when(mockMisskeyI.i()).thenAnswer(
        (_) async => TestData.i1.copyWith(
          name: "Test User",
          description: "Test description",
        ),
      );

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // 名前を変更
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, "New Name");
      await tester.pumpAndSettle();

      // 自己紹介を変更（descriptionフィールドを探す）
      final bioField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.controller?.text == "Test description",
      );
      await tester.enterText(bioField, "New bio");
      await tester.pumpAndSettle();

      // 保存ボタンをタップ
      when(mockMisskeyI.update(any)).thenAnswer((_) async => TestData.i1);

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // i.updateが呼ばれたことを確認
      verify(
        mockMisskeyI.update(
          argThat(
            isA<IUpdateRequest>()
                .having((r) => r.name, "name", equals("New Name"))
                .having((r) => r.description, "description", equals("New bio")),
          ),
        ),
      ).called(1);
    });

    testWidgets("日付ピッカーで誕生日を設定できる", (tester) async {
      when(mockMisskeyI.i()).thenAnswer((_) async => TestData.i1);

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // 日付ピッカーアイコンをタップ
      await tester.tap(find.byIcon(Icons.date_range));
      await tester.pumpAndSettle();

      // DatePickerで日付を選択（15日を選択）
      await tester.tap(find.text("15"));
      await tester.pumpAndSettle();

      // OKボタンをタップ
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();

      // 保存
      when(mockMisskeyI.update(any)).thenAnswer((_) async => TestData.i1);

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // 誕生日が設定されることを確認
      verify(
        mockMisskeyI.update(
          argThat(
            isA<IUpdateRequest>().having(
              (r) => r.birthday,
              "birthday",
              isNotNull,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets("フィールドを追加・削除できる", (tester) async {
      when(mockMisskeyI.i()).thenAnswer(
        (_) async => TestData.i1.copyWith(
          fields: [const UserField(name: "Field 1", value: "Value 1")],
        ),
      );

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // フィールドが表示されることを確認
      expect(find.text("Field 1"), findsOneWidget);
      expect(find.text("Value 1"), findsOneWidget);

      // フィールドを追加
      await tester.tap(find.textContaining("追加"));
      await tester.pumpAndSettle();

      // 新しいフィールドの入力欄が表示されることを確認
      final textFields = find.byType(TextField);
      expect(textFields, findsAtLeastNWidgets(6)); // 既存フィールド + 新規フィールド + その他

      // フィールドを削除
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      // 保存
      when(mockMisskeyI.update(any)).thenAnswer((_) async => TestData.i1);

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      verify(mockMisskeyI.update(any)).called(1);
    });

    testWidgets("アバター画像選択ボタンが存在することを確認", (tester) async {
      when(mockMisskeyI.i()).thenAnswer((_) async => TestData.i1);

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // アバター編集エリアが存在することを確認（カメラアイコンがあるGestureDetector）
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets("エラー状態が正しく表示される", (tester) async {
      // エラーを発生させる
      when(mockMisskeyI.i()).thenThrow(Exception("Network error"));

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // エラーメッセージが表示されることを確認
      expect(find.textContaining("Exception: Network error"), findsOneWidget);
    });

    testWidgets("ローディング状態が表示される", (tester) async {
      // 遅延のあるレスポンスを設定
      final completer = Completer<MeDetailed>();
      when(mockMisskeyI.i()).thenAnswer((_) async => completer.future);

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pump(); // 初回描画

      // ローディングインジケータが表示されることを確認
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // テスト終了前にcompleterを完了させる
      completer.complete(TestData.i1);
      await tester.pumpAndSettle();
    });

    testWidgets("アバター画像選択機能が存在することを確認", (tester) async {
      when(mockMisskeyI.i()).thenAnswer(
        (_) async => TestData.i1.copyWith(
          name: "Test User",
          description: "Test description",
        ),
      );

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // アバター画像選択エリアが存在することを確認
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);

      // アバターアイコンが表示されることを確認
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
    });

    testWidgets("アバターファイル設定のテスト", (tester) async {
      when(mockMisskeyI.i()).thenAnswer(
        (_) async => TestData.i1.copyWith(
          name: "Test User",
          description: "Test description",
        ),
      );

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // アバター画像選択エリアが存在することを確認
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);

      // StateNotifierの状態変更をテスト
      final container = tester
          .widget<UncontrolledProviderScope>(
            find.byType(UncontrolledProviderScope).first,
          )
          .container;

      final notifier = container.read(editProfileStateProvider.notifier);

      // TestData.binaryImageを使用
      final testImageData = await TestData.binaryImage;

      // 初期状態を確認
      final initialState = container.read(editProfileStateProvider);
      expect(initialState, isA<AsyncData<EditProfileState>>());

      // アバターファイルを設定
      notifier.updateAvatarFile((data: testImageData, name: "avatar.png"));

      // 状態にアバターファイルが設定されていることを確認（画像レンダリング前）
      final currentState = container.read(editProfileStateProvider);
      expect(currentState, isA<AsyncData<EditProfileState>>());
      final data = (currentState as AsyncData<EditProfileState>).value;
      expect(data.avatarFile, isNotNull);
      expect(data.avatarFile!.data.length, equals(testImageData.length));
      expect(data.avatarFile!.name, equals("avatar.png"));
      expect(data.avatarDriveId, isNull); // ドライブIDはクリアされる
    });

    testWidgets("ドライブアバターID設定のテスト", (tester) async {
      // 初期状態を明示的に設定
      final initialState = EditProfileState(
        name: "Test User",
        description: "Test description",
      );

      await tester.pumpWidget(
        createTestWidget(account: testAccount, initialState: initialState),
      );
      await tester.pumpAndSettle();

      // アバター画像選択エリアが存在することを確認
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));

      // StateNotifierの状態変更をテスト
      final container = tester
          .widget<UncontrolledProviderScope>(
            find.byType(UncontrolledProviderScope).first,
          )
          .container;
      final notifier = container.read(editProfileStateProvider.notifier);

      // 初期状態を確認（TestEditProfileStateNotifierを使用しているため即座にAsyncData）
      final beforeState = container.read(editProfileStateProvider);
      expect(beforeState, isA<AsyncData<EditProfileState>>());

      // ドライブからのアバターIDを設定
      notifier.updateAvatarDriveId(
        "selected_drive_file_id",
        Uri.parse("https://example.com/drive/file.jpg"),
      );

      // 状態にアバターIDが設定されていることを確認
      final currentState = container.read(editProfileStateProvider);
      expect(currentState, isA<AsyncData<EditProfileState>>());
      final data = (currentState as AsyncData<EditProfileState>).value;
      expect(data.avatarDriveId, equals("selected_drive_file_id"));
      expect(data.avatarFile, isNull); // ファイルはクリアされる
    });

    testWidgets("アバターファイルアップロードのsubmitテスト", (tester) async {
      when(mockMisskeyI.i()).thenAnswer(
        (_) async => TestData.i1.copyWith(
          name: "Test User",
          description: "Test description",
        ),
      );

      // ドライブファイル作成のモック設定
      when(
        mockMisskeyDriveFiles.createAsBinary(any, any),
      ).thenAnswer((_) async => TestData.drive1);

      when(mockMisskeyI.update(any)).thenAnswer((_) async => TestData.i1);

      await tester.pumpWidget(createTestWidget(account: testAccount));
      await tester.pumpAndSettle();

      // StateNotifierを取得
      final container = tester
          .widget<UncontrolledProviderScope>(
            find.byType(UncontrolledProviderScope).first,
          )
          .container;
      final notifier = container.read(editProfileStateProvider.notifier);

      // TestData.binaryImageを使用
      final testImageData = await TestData.binaryImage;

      // アバターファイルを設定
      notifier.updateAvatarFile((data: testImageData, name: "avatar.png"));

      // 手動でsubmitを呼び出す（async処理をテスト環境で制御）
      await notifier.submit();

      // ドライブAPIが呼ばれたことを確認
      verify(
        mockMisskeyDriveFiles.createAsBinary(
          argThat(
            isA<DriveFilesCreateRequest>()
                .having((r) => r.force, "force", isTrue)
                .having((r) => r.name, "name", equals("avatar")),
          ),
          argThat(
            isA<Uint8List>().having(
              (data) => data.length,
              "length",
              equals(testImageData.length),
            ),
          ),
        ),
      ).called(1);

      // i.updateが呼ばれたことを確認
      verify(
        mockMisskeyI.update(
          argThat(
            isA<IUpdateRequest>().having(
              (r) => r.avatarId,
              "avatarId",
              equals(TestData.drive1.id),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets("ドライブアバターIDのsubmitテスト", (tester) async {
      // 初期状態を明示的に設定（ドライブIDも含む）
      final initialState = EditProfileState(
        name: "Test User",
        description: "Test description",
        avatarDriveId: "selected_drive_file_id",
      );

      when(mockMisskeyI.update(any)).thenAnswer((_) async => TestData.i1);

      await tester.pumpWidget(
        createTestWidget(account: testAccount, initialState: initialState),
      );
      await tester.pumpAndSettle();

      // StateNotifierを取得
      final container = tester
          .widget<UncontrolledProviderScope>(
            find.byType(UncontrolledProviderScope).first,
          )
          .container;
      final notifier = container.read(editProfileStateProvider.notifier);

      // 初期状態を確認
      final beforeState = container.read(editProfileStateProvider);
      expect(beforeState, isA<AsyncData<EditProfileState>>());
      final beforeData = (beforeState as AsyncData<EditProfileState>).value;
      expect(beforeData.avatarDriveId, equals("selected_drive_file_id"));

      // 手動でsubmitを呼び出す
      await notifier.submit();

      // ドライブAPIが呼ばれないことを確認（既存のドライブファイルを使用するため）
      verifyNever(mockMisskeyDriveFiles.createAsBinary(any, any));

      // i.updateが正しいavatarIdで呼ばれたことを確認
      verify(
        mockMisskeyI.update(
          argThat(
            isA<IUpdateRequest>().having(
              (r) => r.avatarId,
              "avatarId",
              equals("selected_drive_file_id"),
            ),
          ),
        ),
      ).called(1);
    });
  });
}
