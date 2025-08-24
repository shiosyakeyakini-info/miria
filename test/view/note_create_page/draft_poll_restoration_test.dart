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
  group("Draft Poll Restoration Test", () {
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

    test("単一選択の投票付き下書きが正しく復元されること", () async {
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

      // テスト用の投票付き下書きデータを作成
      final pollDraft = NoteDraft(
        id: "draft-poll-single",
        createdAt: DateTime.now(),
        text: "投票テスト",
        userId: testAccount.userId,
        user: userLite,
        visibility: NoteVisibility.public,
        poll: const NoteDraftPoll(
          choices: ["選択肢1", "選択肢2", "選択肢3"],
          multiple: false,
          expiresAt: null,
          expiredAfter: Duration(hours: 24),
        ),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(pollDraft);

      final state = container.read(noteCreateNotifierProvider);

      // 投票が有効になっていることを確認
      expect(state.isVote, isTrue);
      expect(state.isVoteMultiple, isFalse);

      // 投票の選択肢が正しく復元されていることを確認
      expect(state.voteContent, equals(["選択肢1", "選択肢2", "選択肢3"]));

      // 期限設定が正しく復元されていることを確認
      expect(state.voteExpireType, equals(VoteExpireType.duration));
      expect(state.voteDuration, equals(24));
      expect(state.voteDurationType, equals(VoteExpireDurationType.hours));

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("投票テスト"));
    });

    test("複数選択の投票付き下書きが正しく復元されること", () async {
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

      // テスト用の複数選択投票付き下書きデータを作成
      final pollDraft = NoteDraft(
        id: "draft-poll-multiple",
        createdAt: DateTime.now(),
        text: "複数選択投票テスト",
        userId: testAccount.userId,
        user: userLite,
        visibility: NoteVisibility.public,
        poll: const NoteDraftPoll(
          choices: ["オプションA", "オプションB", "オプションC", "オプションD"],
          multiple: true,
          expiresAt: null,
          expiredAfter: Duration(days: 7),
        ),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(pollDraft);

      final state = container.read(noteCreateNotifierProvider);

      // 投票が有効で複数選択が有効になっていることを確認
      expect(state.isVote, isTrue);
      expect(state.isVoteMultiple, isTrue);

      // 投票の選択肢が正しく復元されていることを確認
      expect(
        state.voteContent,
        equals(["オプションA", "オプションB", "オプションC", "オプションD"]),
      );

      // 期限設定が正しく復元されていることを確認
      expect(state.voteExpireType, equals(VoteExpireType.duration));
      expect(state.voteDuration, equals(7));
      expect(state.voteDurationType, equals(VoteExpireDurationType.day));

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("複数選択投票テスト"));
    });

    test("特定の日時で期限切れする投票付き下書きが正しく復元されること", () async {
      final expirationDate = DateTime.now().add(const Duration(days: 3));

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

      // テスト用の日時指定投票付き下書きデータを作成
      final pollDraft = NoteDraft(
        id: "draft-poll-date",
        createdAt: DateTime.now(),
        text: "日時指定投票テスト",
        userId: testAccount.userId,
        user: userLite,
        visibility: NoteVisibility.public,
        poll: NoteDraftPoll(
          choices: const ["はい", "いいえ"],
          multiple: false,
          expiresAt: expirationDate,
          expiredAfter: null,
        ),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(pollDraft);

      final state = container.read(noteCreateNotifierProvider);

      // 投票が有効になっていることを確認
      expect(state.isVote, isTrue);
      expect(state.isVoteMultiple, isFalse);

      // 投票の選択肢が正しく復元されていることを確認
      expect(state.voteContent, equals(["はい", "いいえ"]));

      // 日時指定の期限設定が正しく復元されていることを確認
      expect(state.voteExpireType, equals(VoteExpireType.date));
      expect(state.voteDate, equals(expirationDate));

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("日時指定投票テスト"));
    });

    test("投票なしの下書きでは投票設定がオフになること", () async {
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

      // 投票なしの下書きデータを作成
      final normalDraft = NoteDraft(
        id: "draft-no-poll",
        createdAt: DateTime.now(),
        text: "通常のテキストのみ",
        userId: testAccount.userId,
        user: userLite,
        visibility: NoteVisibility.public,
        poll: null,
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);

      // 下書きから初期化
      await notifier.initializeFromDraft(normalDraft);

      final state = container.read(noteCreateNotifierProvider);

      // 投票が無効になっていることを確認
      expect(state.isVote, isFalse);
      expect(state.isVoteMultiple, isFalse);

      // デフォルトの投票設定が適用されていることを確認
      expect(state.voteContent, equals(["", ""]));
      expect(state.voteExpireType, equals(VoteExpireType.unlimited));
      expect(state.voteDate, isNull);
      expect(state.voteDuration, isNull);

      // テキストが正しく復元されていることを確認
      expect(state.text, equals("通常のテキストのみ"));
    });

    test("異なる期間単位（秒、分）の投票が正しく復元されること", () async {
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

      // 30分の期間設定
      final pollDraftMinutes = NoteDraft(
        id: "draft-poll-minutes",
        createdAt: DateTime.now(),
        text: "30分間の投票",
        userId: testAccount.userId,
        user: userLite,
        visibility: NoteVisibility.public,
        poll: const NoteDraftPoll(
          choices: ["選択肢1", "選択肢2"],
          multiple: false,
          expiresAt: null,
          expiredAfter: Duration(minutes: 30),
        ),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);
      await notifier.initializeFromDraft(pollDraftMinutes);
      final state = container.read(noteCreateNotifierProvider);

      expect(state.voteExpireType, equals(VoteExpireType.duration));
      expect(state.voteDuration, equals(30));
      expect(state.voteDurationType, equals(VoteExpireDurationType.minutes));
    });

    test("投票の選択肢数が異なる場合も正しく復元されること", () async {
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

      // 10個の選択肢を持つ投票
      final pollDraftMany = NoteDraft(
        id: "draft-poll-many-choices",
        createdAt: DateTime.now(),
        text: "多数選択肢の投票",
        userId: testAccount.userId,
        user: userLite,
        visibility: NoteVisibility.public,
        poll: const NoteDraftPoll(
          choices: [
            "選択肢1",
            "選択肢2",
            "選択肢3",
            "選択肢4",
            "選択肢5",
            "選択肢6",
            "選択肢7",
            "選択肢8",
            "選択肢9",
            "選択肢10",
          ],
          multiple: true,
          expiresAt: null,
          expiredAfter: Duration(hours: 1),
        ),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);
      await notifier.initializeFromDraft(pollDraftMany);
      final state = container.read(noteCreateNotifierProvider);

      expect(state.isVote, isTrue);
      expect(state.isVoteMultiple, isTrue);
      expect(state.voteContent.length, equals(10));
      expect(
        state.voteContent,
        equals([
          "選択肢1",
          "選択肢2",
          "選択肢3",
          "選択肢4",
          "選択肢5",
          "選択肢6",
          "選択肢7",
          "選択肢8",
          "選択肢9",
          "選択肢10",
        ]),
      );
    });

    test("空の選択肢を含む投票が適切に処理されること", () async {
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

      // 空の選択肢を含む投票
      final pollDraftEmpty = NoteDraft(
        id: "draft-poll-empty",
        createdAt: DateTime.now(),
        text: "空選択肢テスト",
        userId: testAccount.userId,
        user: userLite,
        visibility: NoteVisibility.public,
        poll: const NoteDraftPoll(
          choices: ["選択肢1", "", "選択肢3"],
          multiple: false,
          expiresAt: null,
          expiredAfter: Duration(hours: 2),
        ),
      );

      final notifier = container.read(noteCreateNotifierProvider.notifier);
      await notifier.initializeFromDraft(pollDraftEmpty);
      final state = container.read(noteCreateNotifierProvider);

      expect(state.isVote, isTrue);
      expect(state.voteContent, equals(["選択肢1", "", "選択肢3"]));
      expect(state.voteContent.length, equals(3));
    });
  });
}
