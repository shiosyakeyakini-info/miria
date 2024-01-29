import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:misskey_dart/misskey_dart.dart';

extension NoteVisibilityExtension on NoteVisibility {
  IconData get icon {
    return switch (this) {
      NoteVisibility.public => Icons.public,
      NoteVisibility.home => Icons.home,
      NoteVisibility.followers => Icons.lock,
      NoteVisibility.specified => Icons.mail,
    };
  }

  String displayName(BuildContext context) {
    return switch (this) {
      NoteVisibility.public => S.of(context).public,
      NoteVisibility.home => S.of(context).homeOnly,
      NoteVisibility.followers => S.of(context).followersOnly,
      NoteVisibility.specified => S.of(context).direct,
    };
  }
}
