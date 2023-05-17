import 'package:flutter/material.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/misskey_notes/local_only_icon.dart';
import 'package:miria/view/note_create_page/note_create_page.dart';
import 'package:miria/view/note_create_page/note_visibility_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteCreateSettingTop extends ConsumerWidget {
  const NoteCreateSettingTop({super.key});

  IconData resolveVisibilityIcon(NoteVisibility visibility) {
    switch (visibility) {
      case NoteVisibility.public:
        return Icons.public;
      case NoteVisibility.home:
        return Icons.home;
      case NoteVisibility.followers:
        return Icons.lock_outline;
      case NoteVisibility.specified:
        return Icons.mail_outline;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccount = ref.watch(selectedAccountProvider);
    final noteVisibility = ref.watch(noteVisibilityProvider);
    final isLocal = ref.watch(isLocalProvider);
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 5)),
        if (selectedAccount != null)
          AvatarIcon.fromIResponse(
            selectedAccount.i,
            height: Theme.of(context)
                    .iconButtonTheme
                    .style
                    ?.iconSize
                    ?.resolve({}) ??
                32,
          ),
        Expanded(child: Container()),
        Builder(
          builder: (context2) => IconButton(
              onPressed: () async {
                final result = await showModalBottomSheet<NoteVisibility?>(
                    context: context2,
                    builder: (context) => const NoteVisibilityDialog());
                if (result != null) {
                  ref.read(noteVisibilityProvider.notifier).state = result;
                }
              },
              icon: Icon(resolveVisibilityIcon(noteVisibility))),
        ),
        IconButton(
            onPressed: () async {
              ref.read(isLocalProvider.notifier).state =
                  !ref.read(isLocalProvider);
            },
            icon: isLocal ? const LocalOnlyIcon() : const Icon(Icons.rocket)),
        IconButton(
            onPressed: () async {}, icon: const Icon(Icons.all_inclusive))
      ],
    );
  }
}
