import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class CustomEmoji extends ConsumerStatefulWidget {
  final Emoji? emoji;

  const CustomEmoji({super.key, required this.emoji});

  factory CustomEmoji.fromEmojiName(String name, EmojiRepository repository) {
    final customEmojiRegExp = RegExp(r"\:(.+?)@.\:").firstMatch(name);
    final Emoji? found = repository.emoji?.firstWhereOrNull(
        (e) => e.name == (customEmojiRegExp?.group(1) ?? name));

    return CustomEmoji(emoji: found);
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
  Widget build(BuildContext context) {
    if (cachedImage != null) return cachedImage!;
    return FutureBuilder(
        future: requestEmoji(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data;
            if (data != null) {
              cachedImage = Image.memory(data, height: 24);
              return cachedImage!;
            }
          }
          return const SizedBox(width: 24, height: 24);
        });
  }
}
