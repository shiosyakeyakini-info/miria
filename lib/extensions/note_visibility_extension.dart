import 'package:flutter/material.dart';
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
}
