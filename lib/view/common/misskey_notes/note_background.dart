import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteBackground extends ConsumerWidget {
  final NoteVisibility visibility;
  final Widget child;

  const NoteBackground({
    required this.visibility,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(generalSettingsRepositoryProvider).settings;
    final brightness = Theme.of(context).brightness;
    Color? color;
    final isDark = brightness == Brightness.dark;
    switch (visibility) {
      case NoteVisibility.public:
        color = isDark
            ? settings.darkNoteBackgroundPublic
            : settings.lightNoteBackgroundPublic;
        break;
      case NoteVisibility.home:
        color = isDark
            ? settings.darkNoteBackgroundHome
            : settings.lightNoteBackgroundHome;
        break;
      case NoteVisibility.followers:
        color = isDark
            ? settings.darkNoteBackgroundFollowers
            : settings.lightNoteBackgroundFollowers;
        break;
      case NoteVisibility.specified:
        color = isDark
            ? settings.darkNoteBackgroundDirect
            : settings.lightNoteBackgroundDirect;
        break;
    }

    if (color == null || color.opacity == 0) {
      return child;
    }

    return ColoredBox(color: color, child: child);
  }
}
