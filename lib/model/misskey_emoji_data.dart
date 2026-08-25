import "package:miria/model/account.dart";
import "package:miria/repository/account_settings_repository.dart";
import "package:miria/repository/emoji_repository.dart";

sealed class MisskeyEmojiData {
  final String baseName;
  final bool isSensitive;
  const MisskeyEmojiData(this.baseName, this.isSensitive);

  factory MisskeyEmojiData.fromEmojiName({
    required String emojiName,
    Map<String, String>? emojiInfo,
    EmojiRepository? repository,
    String? host,
    AccountSettingsRepository? accountSettingsRepository,
    Account? account,
  }) {
    // ミュート判定用のヘルパー関数
    MisskeyEmojiData checkMuted(MisskeyEmojiData emojiData) {
      if (accountSettingsRepository == null || account == null) {
        return emojiData;
      }

      final mutedReactions = accountSettingsRepository
          .fromAccount(account)
          .mutedReactions;

      switch (emojiData) {
        case CustomEmojiData():
          // 特定の絵文字ミュート（:emoji_name: または :emoji_name@host:）
          if (mutedReactions.contains(emojiData.hostedName)) {
            return MutedEmojiData(originalData: emojiData);
          }

          // ローカル絵文字の場合、ベース名でのミュートもチェック（:emoji_name:）
          if (emojiData.isCurrentServer) {
            final baseName = ":${emojiData.baseName}:";
            if (mutedReactions.contains(baseName)) {
              return MutedEmojiData(originalData: emojiData);
            }
          }

          // ホスト単位のミュート（@host形式）でリモート絵文字をチェック
          if (!emojiData.isCurrentServer) {
            // :emoji_name@host: から host 部分を抽出
            final match = RegExp(
              r"^:(.+?)@(.+?):$",
            ).firstMatch(emojiData.hostedName);
            if (match != null) {
              final hostPart = match.group(2)!;
              if (mutedReactions.contains("@$hostPart")) {
                return MutedEmojiData(originalData: emojiData);
              }
            }
          }
          return emojiData;
        case UnicodeEmojiData():
          // Unicode絵文字のミュートチェック
          if (mutedReactions.contains(emojiData.char)) {
            return MutedEmojiData(originalData: emojiData);
          }
          return emojiData;
        case NotEmojiData():
          return emojiData;
        case MutedEmojiData():
          return emojiData;
      }
    }

    // Unicodeの絵文字
    if (!emojiName.startsWith(":")) {
      final emojiData = UnicodeEmojiData(char: emojiName);
      return checkMuted(emojiData);
    }

    final customEmojiRegExp = RegExp(":(.+?)@(.+?):");
    final hostIncludedRegExp = RegExp(":(.+?):");

    // よそのサーバー
    if (emojiInfo != null && emojiInfo.isNotEmpty) {
      final hostIncludedBaseName =
          hostIncludedRegExp.firstMatch(emojiName)?.group(1) ?? emojiName;
      // `:ai@example.com:` ならホストを除いた `ai`
      // `:ai:` なら前後のコロンを除いた `ai`
      final baseName =
          customEmojiRegExp.firstMatch(emojiName)?.group(1) ??
          hostIncludedBaseName;

      final found = emojiInfo[hostIncludedBaseName];
      if (found != null) {
        // リモート絵文字の場合、ホスト情報を含んだhostedNameを作成
        final hostedName = host != null && !emojiName.contains("@")
            ? ":$hostIncludedBaseName@$host:"
            : emojiName;
        final emojiData = CustomEmojiData(
          baseName: baseName,
          hostedName: hostedName,
          url: Uri.parse(found),
          isCurrentServer: false,
          isSensitive: false,
        );
        return checkMuted(emojiData);
      }
    }

    // 自分のサーバー :ai@.:
    if (customEmojiRegExp.hasMatch(emojiName)) {
      assert(repository != null);
      final name =
          customEmojiRegExp.firstMatch(emojiName)?.group(1) ?? emojiName;
      final found = repository!.emojiMap?[name];

      if (found != null) {
        return checkMuted(found.emoji);
      } else {
        return NotEmojiData(name: emojiName);
      }
    }

    // 自分のサーバー　:ai:
    final customEmojiRegExp2 = RegExp(r"^:(.+?):$");
    if (customEmojiRegExp2.hasMatch(emojiName)) {
      assert(repository != null);
      final name =
          customEmojiRegExp2.firstMatch(emojiName)?.group(1) ?? emojiName;
      final found = repository!.emojiMap?[name];
      if (found != null) {
        return checkMuted(found.emoji);
      } else {
        return NotEmojiData(name: emojiName);
      }
    }

    return NotEmojiData(name: emojiName);
  }
}

/// 絵文字に見せかけた単なるテキスト
class NotEmojiData extends MisskeyEmojiData {
  const NotEmojiData({required this.name}) : super(name, false);
  final String name;
}

/// カスタム絵文字
class CustomEmojiData extends MisskeyEmojiData {
  const CustomEmojiData({
    required String baseName,
    required this.hostedName,
    required this.url,
    required this.isCurrentServer,
    required bool isSensitive,
  }) : super(baseName, isSensitive);

  final String hostedName;
  final Uri url;
  final bool isCurrentServer;
}

/// Unicode絵文字
class UnicodeEmojiData extends MisskeyEmojiData {
  const UnicodeEmojiData({required this.char}) : super(char, false);

  final String char;
}

/// ミュートされた絵文字
class MutedEmojiData extends MisskeyEmojiData {
  MutedEmojiData({required this.originalData})
    : super(originalData.baseName, originalData.isSensitive);

  final MisskeyEmojiData originalData;
}

extension MisskeyEmojiDataReaction on MisskeyEmojiData {
  /// リアクションとして投げる文字列を求める。
  ///
  /// リモートのカスタム絵文字はそのままではリアクションに使えず、サーバーに
  /// 弾かれて❤になってしまうため、同じショートコードの自分のサーバーの絵文字に
  /// 読み替える。読み替える先がないときや、そもそもリアクションできない
  /// ときはnull。
  String? resolveReactionString(EmojiRepository? repository) {
    switch (this) {
      case UnicodeEmojiData(:final char):
        return char;
      case CustomEmojiData(:final isCurrentServer, :final baseName):
        if (isCurrentServer) return ":$baseName:";
        final localEmoji = repository?.emojiMap?[baseName]?.emoji;
        if (localEmoji is! CustomEmojiData || !localEmoji.isCurrentServer) {
          return null;
        }
        return ":${localEmoji.baseName}:";
      case NotEmojiData():
        return null;
      case MutedEmojiData(:final originalData):
        return originalData.resolveReactionString(repository);
    }
  }
}
