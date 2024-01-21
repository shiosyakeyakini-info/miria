import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:misskey_dart/misskey_dart.dart';

extension UsersSortTypeExtension on UsersSortType {
  String displayName(BuildContext context) {
    return switch (this) {
      UsersSortType.followerAscendant => S.of(context).followerAscendingOrder,
      UsersSortType.followerDescendant => S.of(context).followerDescendingOrder,
      UsersSortType.createdAtAscendant => S.of(context).createdAtAscendingOrder,
      UsersSortType.createdAtDescendant =>
        S.of(context).createdAtDescendingOrder,
      UsersSortType.updateAtAscendant => S.of(context).updatedAtAscendingOrder,
      UsersSortType.updateAtDescendant =>
        S.of(context).updatedAtDescendingOrder,
    };
  }
}
