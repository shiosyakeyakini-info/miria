import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/account_settings.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_settings_repository.dart";
import "package:miria/repository/emoji_repository.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/custom_emoji.dart";

import "../../../test_util/default_root_widget.dart";
import "../../../test_util/test_datas.dart";

class FakeAccountSettingsRepository extends AccountSettingsRepository {
  FakeAccountSettingsRepository(this.settings);

  AccountSettings settings;

  @override
  AccountSettings fromAccount(Account account) => settings;

  @override
  Future<void> save(AccountSettings settings) async {
    this.settings = settings;
  }

  @override
  Future<void> load() async {}
}

Widget buildTestWidget({
  required MisskeyEmojiData emoji,
  required List<String> muted,
}) {
  final repoSettings = AccountSettings(
    userId: TestData.account.userId,
    host: TestData.account.host,
    mutedReactions: muted,
  );
  return ProviderScope(
    overrides: [
      accountSettingsRepositoryProvider.overrideWith(
        (ref) => FakeAccountSettingsRepository(repoSettings),
      ),
    ],
    child: DefaultRootNoRouterWidget(
      child: AccountContextScope.as(
        account: TestData.account,
        child: CustomEmoji(emojiData: emoji),
      ),
    ),
  );
}

/// テスト用のダミーリポジトリを作成
class FakeEmojiRepository extends EmojiRepository {
  final CustomEmojiData _testEmoji;

  FakeEmojiRepository(this._testEmoji);

  @override
  Map<String, EmojiRepositoryData>? get emojiMap => {
    _testEmoji.baseName: EmojiRepositoryData(
      emoji: _testEmoji,
      category: "test",
      aliases: [],
      kanaName: "",
      kanaAliases: [],
    ),
  };

  @override
  EmojiRepositoryData? get(String name) => emojiMap?[name];

  @override
  List<String> search(String query) => [];

  @override
  Future<void> load() async {}

  @override
  List<MisskeyEmojiData> defaultEmojis({int limit = 30}) => [];

  @override
  Future<void> loadFromLocalCache() async {}

  @override
  Future<void> loadFromSource() async {}

  @override
  Future<void> loadFromSourceIfNeed() async {}

  @override
  Future<List<MisskeyEmojiData>> searchEmojis(
    String name, {
    int limit = 30,
  }) async => [];
}

/// テスト用にミュート判定を行う絵文字データを作成
MisskeyEmojiData createTestEmojiData({
  required MisskeyEmojiData originalEmoji,
  required List<String> muted,
}) {
  if (originalEmoji is! CustomEmojiData) {
    // Unicode絵文字などの場合は、直接ミュート判定を適用
    final settings = AccountSettings(
      userId: TestData.account.userId,
      host: TestData.account.host,
      mutedReactions: muted,
    );
    final fakeRepo = FakeAccountSettingsRepository(settings);

    return MisskeyEmojiData.fromEmojiName(
      emojiName: originalEmoji is UnicodeEmojiData
          ? originalEmoji.char
          : originalEmoji.baseName,
      emojiInfo: null,
      repository: null,
      host: null,
      accountSettingsRepository: fakeRepo,
      account: TestData.account,
    );
  }

  // CustomEmojiDataの場合
  final isRemote = !originalEmoji.isCurrentServer;

  return MisskeyEmojiData.fromEmojiName(
    emojiName: isRemote
        ? ":${originalEmoji.baseName}:"
        : originalEmoji.hostedName,
    emojiInfo: isRemote
        ? {originalEmoji.baseName: originalEmoji.url.toString()}
        : null,
    repository: isRemote ? null : FakeEmojiRepository(originalEmoji),
    host: isRemote
        ? RegExp(
            r"^:(.+?)@(.+?):$",
          ).firstMatch(originalEmoji.hostedName)?.group(2)
        : null,
    accountSettingsRepository: FakeAccountSettingsRepository(
      AccountSettings(
        userId: TestData.account.userId,
        host: TestData.account.host,
        mutedReactions: muted,
      ),
    ),
    account: TestData.account,
  );
}

void main() {
  final localEmoji = CustomEmojiData(
    baseName: "yay",
    hostedName: ":yay@.:",
    url: Uri.parse("https://example.com/yay.png"),
    isCurrentServer: true,
    isSensitive: false,
  );
  final remoteEmoji = CustomEmojiData(
    baseName: "igyo",
    hostedName: ":igyo@remote.host:",
    url: Uri.parse("https://remote.host/igyo.png"),
    isCurrentServer: false,
    isSensitive: false,
  );

  testWidgets("not muted emoji appears normally", (tester) async {
    final emojiData = createTestEmojiData(originalEmoji: localEmoji, muted: []);
    await tester.pumpWidget(buildTestWidget(emoji: emojiData, muted: []));
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets("muted same host emoji shows error", (tester) async {
    final emojiData = createTestEmojiData(
      originalEmoji: localEmoji,
      muted: [":yay:"],
    );
    await tester.pumpWidget(
      buildTestWidget(emoji: emojiData, muted: [":yay:"]),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets("muted different host emoji shows error", (tester) async {
    final emojiData = createTestEmojiData(
      originalEmoji: remoteEmoji,
      muted: [":igyo@remote.host:"],
    );
    await tester.pumpWidget(
      buildTestWidget(emoji: emojiData, muted: [":igyo@remote.host:"]),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets("host wide mute shows error", (tester) async {
    final emojiData = createTestEmojiData(
      originalEmoji: remoteEmoji,
      muted: ["@remote.host"],
    );
    await tester.pumpWidget(
      buildTestWidget(emoji: emojiData, muted: ["@remote.host"]),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets("exact match with host specified emoji shows error", (
    tester,
  ) async {
    final exactMatchEmoji = CustomEmojiData(
      baseName: "aaa",
      hostedName: ":aaa@example.com:",
      url: Uri.parse("https://example.com/aaa.png"),
      isCurrentServer: false,
      isSensitive: false,
    );
    final emojiData = createTestEmojiData(
      originalEmoji: exactMatchEmoji,
      muted: [":aaa@example.com:"],
    );
    await tester.pumpWidget(
      buildTestWidget(emoji: emojiData, muted: [":aaa@example.com:"]),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets("host wide mute with domain shows error", (tester) async {
    final domainEmoji = CustomEmojiData(
      baseName: "aaa",
      hostedName: ":aaa@example.com:",
      url: Uri.parse("https://example.com/aaa.png"),
      isCurrentServer: false,
      isSensitive: false,
    );
    final emojiData = createTestEmojiData(
      originalEmoji: domainEmoji,
      muted: ["@example.com"],
    );
    await tester.pumpWidget(
      buildTestWidget(emoji: emojiData, muted: ["@example.com"]),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
