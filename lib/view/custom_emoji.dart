import 'package:collection/collection.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class CustomEmoji extends ConsumerWidget {
  final Emoji? emoji;

  const CustomEmoji({super.key, required this.emoji});

  factory CustomEmoji.fromEmojiName(String name, EmojiRepository repository) {
    final customEmojiRegExp = RegExp(r"\:(.+?)@.\:").firstMatch(name);
    final Emoji? found = repository.emoji?.firstWhereOrNull(
        (e) => e.name == (customEmojiRegExp?.group(1) ?? name));

    return CustomEmoji(emoji: found);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiData = emoji;
    if (emojiData == null) return Container();

    return FutureBuilder(
      future: ref.read(emojiRepositoryProvider).requestEmoji(emojiData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;
          if (data != null) {
            return Image.file(
              data,
              height: 24,
            );
          }
        }
        return Container();
      },
    );
  }
}
