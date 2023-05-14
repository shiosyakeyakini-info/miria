import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class CustomEmoji extends ConsumerStatefulWidget {
  final Emoji? emoji;
  final String? anotherServerEmojiUrl;
  final String? naturalEmoji;
  final double fontSizeRatio;
  final bool isAttachTooltip;

  const CustomEmoji({
    super.key,
    required this.emoji,
    this.anotherServerEmojiUrl,
    this.naturalEmoji,
    this.fontSizeRatio = 1,
    this.isAttachTooltip = true,
  });

  factory CustomEmoji.fromEmojiName(
    String name,
    EmojiRepository repository, {
    String? anotherServerUrl,
    double fontSizeRatio = 1,
    bool isAttachTooltip = true,
  }) {
    if (anotherServerUrl != null) {
      return CustomEmoji(
        emoji: null,
        anotherServerEmojiUrl: anotherServerUrl,
        fontSizeRatio: fontSizeRatio,
        isAttachTooltip: isAttachTooltip,
      );
    }

    if (!name.startsWith(":")) {
      return CustomEmoji(
        emoji: null,
        naturalEmoji: name,
        fontSizeRatio: fontSizeRatio,
        isAttachTooltip: isAttachTooltip,
      );
    }

    final customEmojiRegExp = RegExp(r"\:(.+?)@.\:");
    if (customEmojiRegExp.hasMatch(name)) {
      final Emoji? found = repository.emoji?.firstWhereOrNull((e) =>
          e.name == (customEmojiRegExp.firstMatch(name)?.group(1) ?? name));

      return CustomEmoji(
        emoji: found,
        fontSizeRatio: fontSizeRatio,
        isAttachTooltip: isAttachTooltip,
      );
    }

    final customEmojiRegExp2 = RegExp(r"^:(.+?):$");
    if (customEmojiRegExp2.hasMatch(name)) {
      final Emoji? found = repository.emoji?.firstWhereOrNull((e) =>
          e.name == (customEmojiRegExp2.firstMatch(name)?.group(1) ?? name));

      if (found != null) {
        return CustomEmoji(
          emoji: found,
          fontSizeRatio: fontSizeRatio,
          isAttachTooltip: isAttachTooltip,
        );
      } else {
        return CustomEmoji(
          emoji: null,
          naturalEmoji: ":${customEmojiRegExp2.firstMatch(name)?.group(1)}:",
          fontSizeRatio: fontSizeRatio,
          isAttachTooltip: isAttachTooltip,
        );
      }
    }
    return CustomEmoji(
      emoji: null,
      fontSizeRatio: fontSizeRatio,
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CustomEmojiState();
}

class CustomEmojiState extends ConsumerState<CustomEmoji> {
  Widget? cachedImage;
  Future<Uint8List?> requestEmoji() async {
    final emojiData = widget.emoji;
    if (emojiData == null) return null;
    final file = await (ref
        .read(emojiRepositoryProvider(AccountScope.of(context)))
        .requestEmoji(emojiData));
    return await file.readAsBytes();
  }

  @override
  void didUpdateWidget(covariant CustomEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.emoji != widget.emoji) {
      cachedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cachedImage != null) return cachedImage!;
    final scopedFontSize = (DefaultTextStyle.of(context).style.fontSize ?? 22) *
        widget.fontSizeRatio *
        MediaQuery.of(context).textScaleFactor;

    if (widget.anotherServerEmojiUrl != null) {
      return NetworkImageView(
        url: widget.anotherServerEmojiUrl!,
        type: ImageType.customEmoji,
        loadingBuilder: (context, widget, chunk) =>
            SizedBox(width: scopedFontSize, height: scopedFontSize),
        errorBuilder: (context, e, s) => Container(),
        height: scopedFontSize,
      );
    }
    if (widget.naturalEmoji != null) {
      return Text(widget.naturalEmoji!);
    }

    final emoji = widget.emoji;
    if (emoji == null) return Container();

    cachedImage = Tooltip(
        message: ":${emoji.name ?? ""}:",
        child: NetworkImageView(
            url: emoji.url.toString(),
            type: ImageType.customEmoji,
            loadingBuilder: (context, widget, chunk) => SizedBox(
                  height: scopedFontSize,
                  width: scopedFontSize,
                ),
            height: scopedFontSize));
    return cachedImage!;

    /*return FutureBuilder(
        future: requestEmoji(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data;
            if (data != null) {
              final memoryImage = Image.memory(data, height: scopedFontSize);
              if (widget.isAttachTooltip) {
                cachedImage = Tooltip(
                    message: ":${widget.emoji?.name ?? ""}:",
                    child: memoryImage);
              } else {
                cachedImage = memoryImage;
              }
              return cachedImage!;
            }
          }

          if (snapshot.hasError ||
              (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == null)) {
            return Text(":${widget.emoji?.name ?? ""}:");
          }
          return SizedBox(width: scopedFontSize, height: scopedFontSize);
        });*/
  }
}
