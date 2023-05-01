import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class CustomEmoji extends ConsumerStatefulWidget {
  final Emoji? emoji;
  final String? anotherServerEmojiUrl;
  final String? naturalEmoji;
  final double fontSizeRatio;

  const CustomEmoji({
    super.key,
    required this.emoji,
    this.anotherServerEmojiUrl,
    this.naturalEmoji,
    this.fontSizeRatio = 1,
  });

  factory CustomEmoji.fromEmojiName(String name, EmojiRepository repository,
      {String? anotherServerUrl, double fontSizeRatio = 1}) {
    if (anotherServerUrl != null) {
      return CustomEmoji(
        emoji: null,
        anotherServerEmojiUrl: anotherServerUrl,
        fontSizeRatio: fontSizeRatio,
      );
    }

    if (!name.startsWith(":")) {
      return CustomEmoji(
        emoji: null,
        naturalEmoji: name,
        fontSizeRatio: fontSizeRatio,
      );
    }

    final customEmojiRegExp = RegExp(r"\:(.+?)@.\:");
    if (customEmojiRegExp.hasMatch(name)) {
      final Emoji? found = repository.emoji?.firstWhereOrNull((e) =>
          e.name == (customEmojiRegExp.firstMatch(name)?.group(1) ?? name));

      return CustomEmoji(
        emoji: found,
        fontSizeRatio: fontSizeRatio,
      );
    }

    final customEmojiRegExp2 = RegExp(r"^:(.+?):$");
    if (customEmojiRegExp2.hasMatch(name)) {
      final Emoji? found = repository.emoji?.firstWhereOrNull((e) =>
          e.name == (customEmojiRegExp2.firstMatch(name)?.group(1) ?? name));

      return CustomEmoji(
        emoji: found,
        fontSizeRatio: fontSizeRatio,
      );
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
    final file =
        await (ref.read(emojiRepositoryProvider).requestEmoji(emojiData));
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
        widget.fontSizeRatio;
    print("$scopedFontSize / ${widget.fontSizeRatio}");

    if (widget.anotherServerEmojiUrl != null) {
      return Image.network(widget.anotherServerEmojiUrl!,
          errorBuilder: (context, e, s) => Container(), height: scopedFontSize);
    }
    if (widget.naturalEmoji != null) {
      return Text(widget.naturalEmoji!);
    }
    return FutureBuilder(
        future: requestEmoji(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data;
            if (data != null) {
              cachedImage = Image.memory(data, height: scopedFontSize);
              return cachedImage!;
            }
          }
          return SizedBox(width: scopedFontSize, height: scopedFontSize);
        });
  }
}
