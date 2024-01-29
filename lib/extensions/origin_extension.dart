import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:misskey_dart/misskey_dart.dart';

extension OriginExtension on Origin {
  String displayName(BuildContext context) {
    return switch (this) {
      Origin.local => S.of(context).local,
      Origin.remote => S.of(context).remote,
      Origin.combined => S.of(context).originCombined,
    };
  }
}
