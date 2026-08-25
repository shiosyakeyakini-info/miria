import "package:flutter_test/flutter_test.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/repository/emoji_repository.dart";

class FakeEmojiRepository extends EmojiRepository {
  FakeEmojiRepository(List<MisskeyEmojiData> emojis) {
    emoji = emojis
        .map(
          (e) => EmojiRepositoryData(
            emoji: e,
            category: "",
            kanaName: "",
            aliases: const [],
            kanaAliases: const [],
          ),
        )
        .toList();
    emojiMap = {for (final e in emoji!) e.emoji.baseName: e};
  }

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

final localEmoji = CustomEmojiData(
  baseName: "yay",
  hostedName: ":yay@.:",
  url: Uri.parse("https://example.com/yay.png"),
  isCurrentServer: true,
  isSensitive: false,
);

void main() {
  group("fromEmojiName", () {
    test("よそのサーバーのノートの絵文字はコロンを含まない名前になる", () {
      final emojiData = MisskeyEmojiData.fromEmojiName(
        emojiName: ":yay:",
        emojiInfo: {"yay": "https://remote.example/yay.png"},
        host: "remote.example",
      );

      expect(emojiData, isA<CustomEmojiData>());
      emojiData as CustomEmojiData;
      expect(emojiData.baseName, "yay");
      expect(emojiData.hostedName, ":yay@remote.example:");
      expect(emojiData.isCurrentServer, false);
    });

    test("ホストつきで書かれた絵文字もコロンを含まない名前になる", () {
      final emojiData = MisskeyEmojiData.fromEmojiName(
        emojiName: ":yay@remote.example:",
        emojiInfo: {"yay@remote.example": "https://remote.example/yay.png"},
        host: "remote.example",
      );

      expect(emojiData, isA<CustomEmojiData>());
      expect((emojiData as CustomEmojiData).baseName, "yay");
    });
  });

  group("resolveReactionString", () {
    final repository = FakeEmojiRepository([localEmoji]);

    test("自分のサーバーのカスタム絵文字はそのまま", () {
      expect(localEmoji.resolveReactionString(repository), ":yay:");
    });

    test("Unicode絵文字はコロンで囲まない", () {
      expect(
        const UnicodeEmojiData(char: "❤️").resolveReactionString(repository),
        "❤️",
      );
    });

    test("リモートの絵文字は同じショートコードの自分のサーバーの絵文字に読み替える", () {
      final emojiData = MisskeyEmojiData.fromEmojiName(
        emojiName: ":yay:",
        emojiInfo: {"yay": "https://remote.example/yay.png"},
        host: "remote.example",
      );

      expect(emojiData.resolveReactionString(repository), ":yay:");
    });

    test("自分のサーバーにない絵文字はリアクションできない", () {
      final emojiData = MisskeyEmojiData.fromEmojiName(
        emojiName: ":nothing_here:",
        emojiInfo: {"nothing_here": "https://remote.example/nothing_here.png"},
        host: "remote.example",
      );

      expect(emojiData.resolveReactionString(repository), isNull);
    });

    test("絵文字でないものはリアクションできない", () {
      expect(
        const NotEmojiData(
          name: ":not_found:",
        ).resolveReactionString(repository),
        isNull,
      );
    });

    test("ミュートされた絵文字はミュート前の絵文字として解決する", () {
      expect(
        MutedEmojiData(
          originalData: localEmoji,
        ).resolveReactionString(repository),
        ":yay:",
      );
    });
  });
}
