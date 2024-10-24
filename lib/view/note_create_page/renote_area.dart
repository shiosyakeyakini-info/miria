import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";

class RenoteArea extends ConsumerWidget {
  const RenoteArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renote = ref.watch(
      noteCreateNotifierProvider.select((value) => value.renote),
    );

    if (renote != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RN:",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            padding: const EdgeInsets.all(5),
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(0.8)),
              child: MisskeyNote(note: renote),
            ),
          ),
        ],
      );
    }

    return Container();
  }
}
