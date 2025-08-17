import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/account_settings.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("Draft Media Restoration Test", () {
    late ProviderContainer container;
    late Account testAccount;

    setUp(() {
      testAccount = TestData.account;

      container = ProviderContainer(
        overrides: [
          accountContextProvider.overrideWithValue(
            AccountContext(getAccount: testAccount, postAccount: testAccount),
          ),
          accountSettingsRepositoryProvider.overrideWith((ref) {
            final repository = MockAccountSettingsRepository();
            when(repository.fromAccount(any)).thenReturn(
              AccountSettings(
                userId: testAccount.userId,
                host: testAccount.host,
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

    test("メディアなしの下書きでは空のファイルリストになること", () async {
      // UserLiteの作成
      final userLite = UserLite(
        id: testAccount.i.id,
        name: testAccount.i.name,
        username: testAccount.i.username,
        host: testAccount.i.host,
        avatarUrl: testAccount.i.avatarUrl,
        avatarBlurhash: testAccount.i.avatarBlurhash,
        avatarDecorations: testAccount.i.avatarDecorations,
        isBot: testAccount.i.isBot,
        isCat: testAccount.i.isCat,
        instance: testAccount.i.instance,
        emojis: testAccount.i.emojis,
        onlineStatus: testAccount.i.onlineStatus,
        badgeRoles: testAccount.i.badgeRoles,
      );

      // メディアなしの下書きデータを作成
      final noMediaDraft = NoteDraft(
        id: "draft-no-media",
        text: "メディアなしテスト",
        files: null, // メディアなし
        createdAt: DateTime.now(),
        userId: testAccount.userId,
        user: userLite,
        visibility: NoteVisibility.public,
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
  });
}