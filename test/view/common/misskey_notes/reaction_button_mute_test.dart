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
import "package:miria/view/common/misskey_notes/reaction_button.dart";

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

Widget buildTestWidget({
  required String reactionName,
  required Map<String, String> reactionEmojis,
  required List<String> muted,
  String? host,
}) {
  final repoSettings = AccountSettings(
    userId: TestData.account.userId,
    host: TestData.account.host,
    mutedReactions: muted,
  );

  final localEmoji = CustomEmojiData(
    baseName: "yay",
    hostedName: ":yay@.:",
    url: Uri.parse("https://example.com/yay.png"),
    isCurrentServer: true,
    isSensitive: false,
  );

  return ProviderScope(
    overrides: [
      accountSettingsRepositoryProvider.overrideWith(
        (ref) => FakeAccountSettingsRepository(repoSettings),
      ),
      emojiRepositoryProvider(
        TestData.account,
      ).overrideWith((ref) => FakeEmojiRepository(localEmoji)),
    ],
    child: DefaultRootNoRouterWidget(
      child: AccountContextScope.as(
        account: TestData.account,
        child: ReactionButton(
          emojiData: MisskeyEmojiData.fromEmojiName(
            emojiName: reactionName,
            repository: FakeEmojiRepository(localEmoji),
            emojiInfo: reactionEmojis,
            host: host,
            accountSettingsRepository: FakeAccountSettingsRepository(
              repoSettings,
            ),
            account: TestData.account,
          ),
          reactionCount: 1,
          myReaction: null,
          noteId: "test_note_id",
        ),
      ),
    ),
  );
}

void main() {
  group("ReactionButton Mute Tests", () {
    testWidgets("not muted local emoji shows normally", (tester) async {
      await tester.pumpWidget(
        buildTestWidget(reactionName: ":yay:", reactionEmojis: {}, muted: []),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets("muted local emoji shows error icon", (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          reactionName: ":yay:",
          reactionEmojis: {},
          muted: [":yay:"],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets("muted remote emoji shows error icon", (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          reactionName: ":igyo:",
          reactionEmojis: {"igyo": "https://remote.host/igyo.png"},
          muted: [":igyo@remote.host:"],
          host: "remote.host",
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets("host wide mute shows error icon", (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          reactionName: ":igyo:",
          reactionEmojis: {"igyo": "https://remote.host/igyo.png"},
          muted: ["@remote.host"],
          host: "remote.host",
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets("unicode emoji mute shows error icon", (tester) async {
      await tester.pumpWidget(
        buildTestWidget(reactionName: "👍", reactionEmojis: {}, muted: ["👍"]),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
