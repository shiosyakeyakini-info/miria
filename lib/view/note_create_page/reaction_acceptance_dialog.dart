import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          title: Text(S.of(context).favoriteAll),
        ),
        ListTile(
          onTap: () => Navigator.of(context).pop(ReactionAcceptance.likeOnly),
          leading: const Icon(Icons.favorite_border),
          title: Text(S.of(context).favoriteLikeOnly),
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pop(ReactionAcceptance.likeOnlyForRemote),
          leading: const Icon(Icons.add_reaction_outlined),
          title: Text(S.of(context).favoriteLikeOnlyForRemote),
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pop(ReactionAcceptance.nonSensitiveOnly),
          leading: const Icon(Icons.shield_outlined),
          title: Text(S.of(context).favoriteNonSensitiveOnly),
        ),
        ListTile(
          onTap: () => Navigator.of(context).pop(
              ReactionAcceptance.nonSensitiveOnlyForLocalLikeOnlyForRemote),
          leading: const Icon(Icons.add_moderator_outlined),
          title:
              Text(S.of(context).favoriteNonSensitiveOnlyAndLikeOnlyForRemote),
        )
      ],
    );
  }
}
