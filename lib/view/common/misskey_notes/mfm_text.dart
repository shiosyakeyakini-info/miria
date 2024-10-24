import "package:auto_route/auto_route.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_highlighting/flutter_highlighting.dart";
import "package:flutter_highlighting/themes/github-dark.dart";
import "package:flutter_highlighting/themes/github.dart";
import "package:highlighting/languages/all.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:mfm/mfm.dart";
import "package:mfm_parser/mfm_parser.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/custom_emoji.dart";
import "package:miria/view/common/misskey_notes/link_navigator.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:twemoji_v2/twemoji_v2.dart";
import "package:url_launcher/url_launcher.dart";

InlineSpan _unicodeEmojiBuilder(
  BuildContext builderContext,
  String emoji,
  TextStyle? style,
  WidgetRef ref,
  void Function() onTap,
) {
  if (ref.read(generalSettingsRepositoryProvider).settings.emojiType ==
      EmojiType.system) {
    return TextSpan(
      text: emoji,
      style: style,
      recognizer: MfmBlurScope.of(builderContext)
          ? null
          : (TapGestureRecognizer()..onTap = () => onTap),
    );
  } else {
    return WidgetSpan(
      child: GestureDetector(
        onTap: MfmBlurScope.of(builderContext) ? null : () => onTap,
        child: Twemoji(
          emoji: emoji,
          width: style?.fontSize ??
              DefaultTextStyle.of(builderContext).style.fontSize,
          height: style?.fontSize ??
              DefaultTextStyle.of(builderContext).style.fontSize ??
              22,
        ),
      ),
    );
  }
}

class MfmText extends ConsumerWidget {
  final String? mfmText;
  final List<MfmNode>? mfmNode;
  final String? host;
  final TextStyle? style;
  final Map<String, String> emoji;
  final bool isNyaize;
  final List<InlineSpan> suffixSpan;
  final List<InlineSpan> prefixSpan;
  final Function(MisskeyEmojiData)? onEmojiTap;
  final bool isEnableAnimatedMFM;
  final int? maxLines;

  const MfmText({
    super.key,
    this.mfmText,
    this.mfmNode,
    this.host,
    this.style,
    this.emoji = const {},
    this.isNyaize = false,
    this.suffixSpan = const [],
    this.prefixSpan = const [],
    this.onEmojiTap,
    this.isEnableAnimatedMFM = true,
    this.maxLines,
  }) : assert(mfmText != null || mfmNode != null);

  Future<void> onSearch(String query) async {
    final uri = Uri(
      scheme: "https",
      host: "google.com",
      pathSegments: ["search"],
      queryParameters: {"q": query},
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Mfm(
      mfmText: mfmText,
      mfmNode: mfmNode,
      emojiBuilder: (builderContext, emojiName, style) {
        final emojiData = MisskeyEmojiData.fromEmojiName(
          emojiName: ":$emojiName:",
          repository: ref.read(
            emojiRepositoryProvider(
              ref.read(accountContextProvider).getAccount,
            ),
          ),
          emojiInfo: emoji,
        );
        return DefaultTextStyle(
          style: style ?? DefaultTextStyle.of(builderContext).style,
          child: GestureDetector(
            onTap: MfmBlurScope.of(builderContext)
                ? null
                : () => onEmojiTap?.call(emojiData),
            child: EmojiInk(
              child: CustomEmoji(
                emojiData: emojiData,
                fontSizeRatio: 2,
                style: style,
              ),
            ),
          ),
        );
      },
      unicodeEmojiBuilder: (context, emoji, style) => _unicodeEmojiBuilder(
        context,
        emoji,
        style,
        ref,
        () => onEmojiTap?.call(UnicodeEmojiData(char: emoji)),
      ),
      codeBlockBuilder: (context, code, lang) => CodeBlock(
        code: code,
        language: lang,
      ),
      unixTimeBuilder: (context, unixtime, style) {
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(left: 5, right: 5),
            margin: const EdgeInsets.only(left: 5, right: 5),
            child: Text.rich(
              textScaler: TextScaler.noScaling,
              TextSpan(
                style: style,
                text:
                    "${unixtime?.formatUntilSeconds(context) ?? "？？？"} (${unixtime?.differenceNowDetail(context) ?? "？？？"})",
              ),
            ),
          ),
        );
      },
      serifStyle: AppTheme.of(context).serifStyle,
      monospaceStyle: AppTheme.of(context).monospaceStyle,
      cursiveStyle: AppTheme.of(context).cursiveStyle,
      fantasyStyle: AppTheme.of(context).fantasyStyle,
      linkTap: (src) async =>
          const LinkNavigator().onTapLink(context, ref, src, host),
      linkStyle: AppTheme.of(context).linkStyle,
      hashtagStyle: AppTheme.of(context).hashtagStyle,
      mentionTap: (userName, host, acct) async =>
          const LinkNavigator().onMentionTap(
        context,
        ref,
        acct,
        host,
      ),
      hashtagTap: (hashtag) async => await context.pushRoute(
        HashtagRoute(
          accountContext: ref.read(accountContextProvider),
          hashtag: hashtag,
        ),
      ),
      searchTap: onSearch,
      style: style,
      isNyaize: isNyaize,
      suffixSpan: suffixSpan,
      prefixSpan: prefixSpan,
      isUseAnimation: isEnableAnimatedMFM,
      defaultBorderColor: Theme.of(context).primaryColor,
      maxLines: maxLines,
    );
  }
}

class CodeBlock extends StatelessWidget {
  final String? language;
  final String code;

  const CodeBlock({
    required this.code,
    super.key,
    this.language,
  });

  String resolveLanguage(String language) {
    if (language == "js") return "javascript";
    if (language == "c++") return "cpp";

    return language;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedLanguage =
        allLanguages[resolveLanguage(language ?? "text")]?.id ?? "javascript";

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: HighlightView(
          code,
          languageId: resolvedLanguage,
          theme:
              AppTheme.of(context).isDarkMode ? githubDarkTheme : githubTheme,
          padding: const EdgeInsets.all(10),
          textStyle: AppTheme.of(context).monospaceStyle,
        ),
      ),
    );
  }
}

class EmojiInk extends ConsumerWidget {
  final Widget child;

  const EmojiInk({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(
      generalSettingsRepositoryProvider
          .select((value) => value.settings.enableDirectReaction),
    );
    if (isEnabled) {
      return InkWell(child: child);
    } else {
      return child;
    }
  }
}

class SimpleMfmText extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final Map<String, String> emojis;
  final List<InlineSpan> suffixSpan;
  final List<InlineSpan> prefixSpan;
  final bool isNyaize;

  const SimpleMfmText(
    this.text, {
    super.key,
    this.style,
    this.emojis = const {},
    this.suffixSpan = const [],
    this.prefixSpan = const [],
    this.isNyaize = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleMfm(
      text,
      emojiBuilder: (context, emojiName, style) => DefaultTextStyle.merge(
        style: style ?? DefaultTextStyle.of(context).style,
        child: CustomEmoji(
          emojiData: MisskeyEmojiData.fromEmojiName(
            emojiName: ":$emojiName:",
            repository: ref.read(
              emojiRepositoryProvider(
                ref.read(accountContextProvider).getAccount,
              ),
            ),
            emojiInfo: emojis,
          ),
          fontSizeRatio: 1,
          style: style,
        ),
      ),
      unicodeEmojiBuilder: (context, emoji, style) => _unicodeEmojiBuilder(
        context,
        emoji,
        style,
        ref,
        () => {},
      ),
      style: style,
      suffixSpan: suffixSpan,
      prefixSpan: prefixSpan,
      isNyaize: isNyaize,
    );
  }
}

class UserInformation extends ConsumerWidget {
  final User user;
  const UserInformation({
    required this.user,
    super.key,
  });

  String resolveIconUrl(Uri uri, WidgetRef ref) {
    final baseUrl = uri.toString();
    if (baseUrl.startsWith("/")) {
      return "https://${user.host ?? ref.read(accountContextProvider).getAccount.host}$baseUrl";
    } else {
      return baseUrl;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleMfmText(
      user.name ?? user.username,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.bold),
      emojis: user.emojis,
      suffixSpan: [
        for (final badge in user.badgeRoles)
          if (badge.iconUrl != null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Tooltip(
                message: badge.name,
                child: NetworkImageView(
                  type: ImageType.role,
                  url: resolveIconUrl(badge.iconUrl!, ref),
                  height: DefaultTextStyle.of(context).style.fontSize ?? 22,
                  loadingBuilder: (context, widget, event) => SizedBox(
                    width: DefaultTextStyle.of(context).style.fontSize ?? 22,
                    height: DefaultTextStyle.of(context).style.fontSize ?? 22,
                  ),
                  errorBuilder: (context, e, s) => SizedBox(
                    width: DefaultTextStyle.of(context).style.fontSize ?? 22,
                    height: DefaultTextStyle.of(context).style.fontSize ?? 22,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
