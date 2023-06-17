import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ReactionAcceptanceDialog extends StatelessWidget {
  const ReactionAcceptanceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () => Navigator.of(context).pop(null),
          leading: SvgPicture.asset(
            "assets/images/play_shapes_FILL0_wght400_GRAD0_opsz48.svg",
            color: Theme.of(context).textTheme.bodyMedium!.color,
            width: 28,
            height: 28,
          ),
          title: Text("すべて"),
        ),
        ListTile(
          onTap: () => Navigator.of(context).pop(ReactionAcceptance.likeOnly),
          leading: Icon(Icons.favorite_border),
          title: Text("いいねのみ"),
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pop(ReactionAcceptance.likeOnlyForRemote),
          leading: Icon(Icons.add_reaction_outlined),
          title: Text("リモートからはいいねのみ"),
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pop(ReactionAcceptance.nonSensitiveOnly),
          leading: Icon(Icons.shield_outlined),
          title: Text("非センシティブのみ"),
          subtitle: Text("Misskey v13.13.1からの機能です。サーバーによっては使用できないことがあります。"),
        ),
        ListTile(
          onTap: () => Navigator.of(context).pop(
              ReactionAcceptance.nonSensitiveOnlyForLocalLikeOnlyForRemote),
          leading: Icon(Icons.add_moderator_outlined),
          title: Text("非センシティブのみ（リモートからはいいねのみ）"),
          subtitle: Text("Misskey v13.13.1からの機能です。サーバーによっては使用できないことがあります。"),
        )
      ],
    );
  }
}
