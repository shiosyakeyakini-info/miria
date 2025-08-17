import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("Draft Media Restoration Test", () {
    late ProviderContainer container;
    late MockMisskey mockMisskey;
    late MockMisskeyNotes mockNotes;
    late MockMisskeyNotesDrafts mockDrafts;

    setUp(() {
      mockMisskey = MockMisskey();
      mockNotes = MockMisskeyNotes();
      mockDrafts = MockMisskeyNotesDrafts();

      when(mockMisskey.notes).thenReturn(mockNotes);
      when(mockNotes.drafts).thenReturn(mockDrafts);

      final generalSettingsRepository = MockGeneralSettingsRepository();
      when(
        generalSettingsRepository.settings,
      ).thenReturn(const GeneralSettings());

      container = ProviderContainer(
        overrides: [
          misskeyPostContextProvider.overrideWithValue(mockMisskey),
          generalSettingsRepositoryProvider.overrideWithValue(
            generalSettingsRepository,
          ),
          accountContextProvider.overrideWithValue(
            AccountContext(
              getAccount: TestData.account,
              postAccount: TestData.account,
            ),
          ),
          accountSettingsRepositoryProvider.overrideWith((ref) {
            final repository = MockAccountSettingsRepository();
            when(
              repository.fromAccount(any),
            ).thenReturn(TestData.accountSettings);
            return repository;
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test("単一画像付き下書きが正しく復元されること", () async {
      // テスト用の画像付き下書きデータを作成
      final mediaDraft = NoteDraft(
        id: "draft-single-image",
        text: "画像付きテスト",
        files: [
          TestData.drive1, // 画像ファイル1つ
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(mediaDraft);

      final state = container.read(noteCreateNotifierProvider);

      // 画像が正しく復元されていることを確認
      expect(state.files.length, equals(1));
      expect(state.files.first.id, equals(TestData.drive1.id));
      expect(state.files.first.url, equals(TestData.drive1.url));
      expect(state.files.first.name, equals(TestData.drive1.name));

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("画像付きテスト"));
    });

    test("動画ファイル付き下書きが正しく復元されること", () async {
      // テスト用の動画ファイル付き下書きデータを作成
      final videoDraft = NoteDraft(
        id: "draft-video",
        text: "動画付きテスト",
        files: [TestData.drive2AsVideo],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(videoDraft);

      final state = container.read(noteCreateNotifierProvider);

      // 動画ファイルが正しく復元されていることを確認
      expect(state.files.length, equals(1));
      expect(state.files.first.id, equals(TestData.drive2AsVideo.id));
      expect(state.files.first.type, contains("video"));

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("動画付きテスト"));
    });

    test("複数ファイル付き下書きが正しく復元されること", () async {
      // テスト用の複数ファイル付き下書きデータを作成
      final multiMediaDraft = NoteDraft(
        id: "draft-multiple-files",
        text: "複数ファイル付きテスト",
        files: [
          TestData.drive1, // 画像
          TestData.drive2AsVideo, // 動画
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(multiMediaDraft);

      final state = container.read(noteCreateNotifierProvider);

      // 複数のファイルが正しく復元されていることを確認
      expect(state.files.length, equals(2));
      expect(state.files[0].id, equals(TestData.drive1.id));
      expect(state.files[1].id, equals(TestData.drive2AsVideo.id));

      // 各ファイルの種類が正しく保持されていることを確認
      expect(state.files[0].type, contains("image"));
      expect(state.files[1].type, contains("video"));

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("複数ファイル付きテスト"));
    });

    test("メディアなしの下書きでは空のファイルリストになること", () async {
      // メディアなしの下書きデータを作成
      final noMediaDraft = NoteDraft(
        id: "draft-no-media",
        text: "メディアなしテスト",
        files: null, // メディアなし
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(noMediaDraft);

      final state = container.read(noteCreateNotifierProvider);

      // ファイルリストが空であることを確認
      expect(state.files, isEmpty);

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("メディアなしテスト"));
    });

    test("センシティブファイル付き下書きが正しく復元されること", () async {
      // センシティブファイル付き下書きデータを作成
      final sensitiveFile = TestData.drive1.copyWith(isSensitive: true);
      final sensitiveDraft = NoteDraft(
        id: "draft-sensitive",
        text: "センシティブファイル付きテスト",
        files: [sensitiveFile],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(sensitiveDraft);

      final state = container.read(noteCreateNotifierProvider);

      // センシティブファイルが正しく復元されていることを確認
      expect(state.files.length, equals(1));
      expect(state.files.first.id, equals(sensitiveFile.id));
      expect(state.files.first.isSensitive, isTrue);

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("センシティブファイル付きテスト"));
    });
  });
}
