import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:twemoji_v2/twemoji_v2.dart";

class CustomEmoji extends ConsumerStatefulWidget {
  final MisskeyEmojiData emojiData;
  final double fontSizeRatio;
  final bool isAttachTooltip;
  final double? size;
  final TextStyle? style;
  final bool forceSquare;

  const CustomEmoji({
    required this.emojiData,
    super.key,
    this.fontSizeRatio = 1,
    this.isAttachTooltip = true,
    this.size,
    this.style,
    this.forceSquare = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CustomEmojiState();
}

class CustomEmojiState extends ConsumerState<CustomEmoji> {
  Widget? cachedImage;

  @override
  void didUpdateWidget(covariant CustomEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.emojiData != widget.emojiData || oldWidget.size != widget.size) {
      cachedImage = null;
    }
  }

  /// カスタム絵文字のURLを解決する
  Uri resolveFallbackCustomEmojiUrl(CustomEmojiData emojiData) {
    return Uri(
      scheme: "https",
      host: emojiData.isCurrentServer
          ? ref.read(accountContextProvider).getAccount.host
          : emojiData.hostedName.replaceAll(RegExp(r"^\:(.+?)@"), "").replaceAll(":", ""),
      pathSegments: ["proxy", "image.webp"],
      queryParameters: {
        "url": Uri.encodeFull(emojiData.url.toString()),
        "emoji": "1",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cachedImage != null) return cachedImage!;
    final scopedFontSize = widget.size ?? (DefaultTextStyle.of(context).style.fontSize ?? 22) * widget.fontSizeRatio;
    final style = widget.style ??
        TextStyle(
          height: 1.0,
          fontSize: scopedFontSize,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        );

    final emojiData = widget.emojiData;

    bool isMuted = false;
    if (emojiData is CustomEmojiData) {
      final settings =
          ref.read(accountSettingsRepositoryProvider).fromAccount(ref.read(accountContextProvider).getAccount);
      final host = emojiData.isCurrentServer
          ? ref.read(accountContextProvider).getAccount.host
          : emojiData.hostedName.replaceAll(RegExp(r'^:(.+?)@'), '').replaceAll(':', '');
      final candidates = <String>[
        ':${emojiData.baseName}:',
        ':${emojiData.baseName}@$host:',
        '@$host',
      ];
      isMuted = settings.mutedReactions.any(candidates.contains);
    }

    if (isMuted) {
      cachedImage = Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 224, 224, 224),
        ),
        height: scopedFontSize,
        width: scopedFontSize,
        child: SvgPicture.asset(
          'assets/images/miria_error.svg',
          colorFilter: const ColorFilter.mode(
            Color.fromARGB(255, 117, 117, 117),
            BlendMode.srcIn,
          ),
          width: scopedFontSize,
          height: scopedFontSize,
        ),
      );
      return cachedImage!;
    }

    switch (emojiData) {
      case CustomEmojiData():
        cachedImage = ConditionalTooltip(
          isAttachTooltip: widget.isAttachTooltip,
          message: emojiData.hostedName,
          child: NetworkImageView(
            url: emojiData.url.toString(),
            type: ImageType.customEmoji,
            errorBuilder: (context, e, s) => NetworkImageView(
              url: resolveFallbackCustomEmojiUrl(emojiData).toString(),
              type: ImageType.customEmoji,
              loadingBuilder: (context, widget, chunk) => SizedBox(
                height: scopedFontSize,
                width: scopedFontSize,
              ),
              height: scopedFontSize,
              errorBuilder: (context, e, s) => Text(emojiData.hostedName, style: style),
            ),
            loadingBuilder: (context, widget, chunk) => SizedBox(
              height: scopedFontSize,
              width: scopedFontSize,
            ),
            width: widget.forceSquare ? scopedFontSize : null,
            height: scopedFontSize,
          ),
        );
      case UnicodeEmojiData():
        switch (ref.read(generalSettingsRepositoryProvider).settings.emojiType) {
          case EmojiType.system:
            cachedImage = FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                emojiData.char,
                strutStyle: StrutStyle(
                  height: 1.0,
                  forceStrutHeight: true,
                  fontSize: scopedFontSize,
                ),
                style: style.merge(AppTheme.of(context).unicodeEmojiStyle),
              ),
            );
          case EmojiType.twemoji:
            cachedImage = Twemoji(
              height: scopedFontSize,
              emoji: emojiData.char,
            );
        }
      case NotEmojiData():
        cachedImage = Text(
          emojiData.name,
          style: style,
        );
    }
    return cachedImage!;
  }
}

class ConditionalTooltip extends StatelessWidget {
  final bool isAttachTooltip;
  final String message;
  final Widget child;

  const ConditionalTooltip({
    required this.isAttachTooltip,
    required this.message,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isAttachTooltip) {
      return Tooltip(
        message: message,
        child: child,
      );
    } else {
      return child;
    }
  }
}
