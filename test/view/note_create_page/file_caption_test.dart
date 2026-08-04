import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account_settings.dart";
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/note_create_page/file_settings_dialog.dart";
import "package:miria/view/note_create_page/note_create_page.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:misskey_dart/src/services/api_service.dart";
import "package:mockito/mockito.dart";

import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

/// `drive/files/update` に送られたリクエストを記録するApiService
class RecordingApiService extends Fake implements ApiService {
  final requests =
      <(String, Map<String, dynamic>, bool Function(String, String?)?)>[];

  @override
  Future<T> post<T>(
    String path,
    Map<String, dynamic> request, {
    bool Function(String, String?)? excludeRemoveNullPredicate,
  }) async {
    requests.add((path, request, excludeRemoveNullPredicate));
    return TestData.drive1.toJson() as T;
  }
}

void main() {
  group("ファイル情報の編集", () {
    late ProviderContainer container;
    late RecordingApiService apiService;

    // 画像以外のファイルにするとダウンロード処理を挟まずに
    // UnknownAlreadyPostedFileとして復元される
    final driveFile = TestData.drive1.copyWith(
      name: "before.txt",
      type: "text/plain",
      comment: null,
    );
    final noteWithFile = TestData.note1.copyWith(
      files: [driveFile],
      fileIds: [driveFile.id],
    );

    setUp(() {
      apiService = RecordingApiService();
      final mockMisskey = MockMisskey();
      final mockNotes = MockMisskeyNotes();
      when(mockMisskey.notes).thenReturn(mockNotes);
      when(mockMisskey.apiService).thenReturn(apiService);

      final account = TestData.account;
      container = ProviderContainer(
        overrides: [
          misskeyProvider.overrideWith((ref, account) => mockMisskey),
          accountContextProvider.overrideWithValue(
            AccountContext(getAccount: account, postAccount: account),
          ),
          accountSettingsRepositoryProvider.overrideWith((ref) {
            final repository = MockAccountSettingsRepository();
            when(repository.fromAccount(any)).thenReturn(
              AccountSettings(
                userId: account.userId,
                host: account.host,
                defaultNoteVisibility: NoteVisibility.public,
                defaultIsLocalOnly: false,
                defaultReactionAcceptance: ReactionAcceptance.nonSensitiveOnly,
              ),
            );
            return repository;
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    // #849: 説明が空のまま`comment: ''`を送ると、Misskey Webが
    // ALTテキストとしてファイル名を表示しなくなってしまう
    test("説明を入力せずにファイル名だけ編集した場合、commentが空文字で送られないこと", () async {
      final notifier = container.read(noteCreateProvider.notifier);
      await notifier.initialize(
        null,
        null,
        null,
        noteWithFile,
        null,
        null,
        NoteCreationMode.recreate,
      );

      notifier.setFileMetaData(
        0,
        const FileSettingsDialogResult(
          fileName: "after.txt",
          isNsfw: false,
          caption: null,
        ),
      );
      notifier.setContentText("ぬるぽ");

      await notifier.note();

      final update = apiService.requests.singleWhere(
        (e) => e.$1 == "drive/files/update",
      );
      expect(update.$2["name"], "after.txt");
      expect(update.$2["comment"], isNot(""));
      expect(update.$2["comment"], isNull);
      // commentのnullがリクエストから削除されないようにする必要がある
      expect(update.$3?.call("comment", null), isTrue);
    });

    test("説明を入力した場合はその内容が送られること", () async {
      final notifier = container.read(noteCreateProvider.notifier);
      await notifier.initialize(
        null,
        null,
        null,
        noteWithFile,
        null,
        null,
        NoteCreationMode.recreate,
      );

      notifier.setFileMetaData(
        0,
        const FileSettingsDialogResult(
          fileName: "after.txt",
          isNsfw: false,
          caption: "ぬるぽのファイル",
        ),
      );
      notifier.setContentText("ぬるぽ");

      await notifier.note();

      final update = apiService.requests.singleWhere(
        (e) => e.$1 == "drive/files/update",
      );
      expect(update.$2["comment"], "ぬるぽのファイル");
    });
  });
}
