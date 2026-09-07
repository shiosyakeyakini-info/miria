import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:misskey_dart/misskey_dart.dart";

/// misskey_dart 側にも同名の extension があり、`priority` と `min` を持つ。
/// 明示的に `NoteVisibilityExtension.min(...)` と書けるように名前をずらす。
extension MiriaNoteVisibilityExtension on NoteVisibility {
  IconData get icon {
    return switch (this) {
      NoteVisibility.public => Icons.public,
      NoteVisibility.home => Icons.home,
      NoteVisibility.followers => Icons.lock,
      NoteVisibility.specified => Icons.mail,
      NoteVisibility.unknown => Icons.help_outline,
    };
  }

  String displayName(BuildContext context) {
    return switch (this) {
      NoteVisibility.public => S.of(context).public,
      NoteVisibility.home => S.of(context).homeOnly,
      NoteVisibility.followers => S.of(context).followersOnly,
      NoteVisibility.specified => S.of(context).direct,
      NoteVisibility.unknown => "",
    };
  }
}
