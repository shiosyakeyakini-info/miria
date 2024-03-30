import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:misskey_dart/misskey_dart.dart';

extension ReactionAcceptanceExtension on ReactionAcceptance {
  String displayName(BuildContext context) {
    return switch (this) {
      ReactionAcceptance.likeOnlyForRemote =>
        S.of(context).favoriteLikeOnlyForRemote,
      ReactionAcceptance.nonSensitiveOnly =>
        S.of(context).favoriteNonSensitiveOnly,
      ReactionAcceptance.nonSensitiveOnlyForLocalLikeOnlyForRemote =>
        S.of(context).favoriteNonSensitiveOnlyAndLikeOnlyForRemote,
      ReactionAcceptance.likeOnly => S.of(context).favoriteLikeOnly,
    };
  }
}
