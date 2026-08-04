import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";

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
      case NoteVisibility.home:
        color = isDark
            ? settings.darkNoteBackgroundHome
            : settings.lightNoteBackgroundHome;
      case NoteVisibility.followers:
        color = isDark
            ? settings.darkNoteBackgroundFollowers
            : settings.lightNoteBackgroundFollowers;
      case NoteVisibility.specified:
        color = isDark
            ? settings.darkNoteBackgroundDirect
            : settings.lightNoteBackgroundDirect;
    }

    if (color == null || color.a == 0) {
      return child;
    }

    return ColoredBox(color: color, child: child);
  }
}
