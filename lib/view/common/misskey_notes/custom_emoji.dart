import 'package:flutter/material.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/themes/app_theme.dart';

class CustomEmoji extends ConsumerStatefulWidget {
  final MisskeyEmojiData emojiData;
  final double fontSizeRatio;
  final bool isAttachTooltip;

  const CustomEmoji({
    super.key,
    required this.emojiData,
    this.fontSizeRatio = 1,
    this.isAttachTooltip = true,
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

  @override
  Widget build(BuildContext context) {
    if (cachedImage != null) return cachedImage!;
    final scopedFontSize = (DefaultTextStyle.of(context).style.fontSize ?? 22) *
        widget.fontSizeRatio;

    final emojiData = widget.emojiData;
    switch (emojiData) {
      case CustomEmojiData():
        cachedImage = ConditionalTooltip(
            isAttachTooltip: widget.isAttachTooltip,
            message: emojiData.hostedName,
            child: NetworkImageView(
                url: emojiData.url.toString(),
                type: ImageType.customEmoji,
                errorBuilder: (context, e, s) => Text(emojiData.baseName,
                    style: TextStyle(
                        height: 0,
                        //TODO: あとでなおす
                        fontSize: scopedFontSize / 1.5,
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
