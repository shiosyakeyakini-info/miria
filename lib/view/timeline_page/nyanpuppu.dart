import 'package:flutter/material.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';

// blobs in community discord server
final _discordOfficialEmojiList = [
  // meowmoji
  "https://cdn.discordapp.com/emojis/600787523421208577.png?size=32",
  "https://cdn.discordapp.com/emojis/471640366093828096.gif?size=64",
  "https://cdn.discordapp.com/emojis/455010658782674944.gif?size=64",
  "https://cdn.discordapp.com/emojis/430345205951234059.gif?size=64",
  "https://cdn.discordapp.com/emojis/826517106308284438.gif?size=64",
  "https://cdn.discordapp.com/emojis/594159590107643914.gif?size=64",
  "https://cdn.discordapp.com/emojis/684091781926879296.gif?size=64",
  "https://cdn.discordapp.com/emojis/621634488220385290.png?size=32",
  "https://cdn.discordapp.com/emojis/352818268572221442.png?size=32",

  // meowmoji 2
  "https://cdn.discordapp.com/emojis/380080817214324739.png?size=32",
  "https://cdn.discordapp.com/emojis/391358218971906050.png?size=32"

  //mewomoji 3
]..shuffle();

final _selectedEmoji = _discordOfficialEmojiList.first;

class Nyanpuppu extends StatelessWidget {
  const Nyanpuppu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: NetworkImageView(
        url: _selectedEmoji,
        type: ImageType.customEmoji,
      ),
    );
  }
}
