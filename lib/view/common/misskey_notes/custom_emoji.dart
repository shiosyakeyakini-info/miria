import 'package:flutter/material.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/themes/app_theme.dart';

class CustomEmoji extends ConsumerStatefulWidget {
  final MisskeyEmojiData emojiData;
  final double fontSizeRatio;
  final bool isAttachTooltip;
  final double? size;

  const CustomEmoji({
    super.key,
    required this.emojiData,
    this.fontSizeRatio = 1,
    this.isAttachTooltip = true,
    this.size,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CustomEmojiState();
}

class CustomEmojiState extends ConsumerState<CustomEmoji> {
  Widget? cachedImage;

  @override
  void didUpdateWidget(covariant CustomEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.emojiData != widget.emojiData) {
      cachedImage = null;
    }
  }

  /// カスタム絵文字のURLを解決する
  Uri resolveCustomEmojiUrl(Uri uri) {
    //　特例としてにじみすのみ、URLの変換をかける
    if (uri.host == "media.nijimiss.app") {
      return Uri(
        scheme: "https",
        host: "nijimiss.moe",
        pathSegments: ["proxy", "image.webp"],
        queryParameters: {"url": Uri.encodeFull(uri.toString()), "emoji": "1"},
      );
    } else {
      return uri;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cachedImage != null) return cachedImage!;
    final scopedFontSize = widget.size ??
        (DefaultTextStyle.of(context).style.fontSize ?? 22) *
            widget.fontSizeRatio;

    final emojiData = widget.emojiData;
    switch (emojiData) {
      case CustomEmojiData():
        cachedImage = ConditionalTooltip(
            isAttachTooltip: widget.isAttachTooltip,
            message: emojiData.hostedName,
            child: NetworkImageView(
                url: resolveCustomEmojiUrl(emojiData.url).toString(),
                type: ImageType.customEmoji,
                errorBuilder: (context, e, s) => Text(emojiData.hostedName,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color)),
                loadingBuilder: (context, widget, chunk) => SizedBox(
                      height: scopedFontSize,
                      width: scopedFontSize,
                    ),
                height: scopedFontSize));
        break;
      case UnicodeEmojiData():
        cachedImage = SizedBox(
            width: scopedFontSize,
            height: scopedFontSize,
            child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  emojiData.char,
                  style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color)
                      .merge(AppTheme.of(context).unicodeEmojiStyle),
                )));
        break;
      case NotEmojiData():
        cachedImage = Text(emojiData.name,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color));
        break;
    }
    return cachedImage!;
  }
}

class ConditionalTooltip extends StatelessWidget {
  final bool isAttachTooltip;
  final String message;
  final Widget child;

  const ConditionalTooltip(
      {super.key,
      required this.isAttachTooltip,
      required this.message,
      required this.child});

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
