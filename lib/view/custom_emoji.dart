import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  Uint8List? emojiBinaryData;
  @override
  void initState() {
    super.initState();
    Future(() async {
      await requestEmoji();
    });
  }

  Future<void> requestEmoji() async {
    final emojiData = widget.emoji;
    if(emojiData == null) return;
    final file = await (ref.read(emojiRepositoryProvider).requestEmoji(emojiData));
    emojiBinaryData = await file.readAsBytes();
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    final loadedImageBinary = emojiBinaryData;
    if(loadedImageBinary != null) { 
      return Image.memory(loadedImageBinary, height: 24);
    }

    return  Container();
  }
}
