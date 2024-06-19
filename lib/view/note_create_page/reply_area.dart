import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";

class ReplyArea extends ConsumerWidget {
  const ReplyArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reply = ref.watch(
      noteCreateNotifierProvider(AccountScope.of(context))
          .select((value) => value.reply),
    );

    if (reply != null) {
      return MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(0.8)),
        child: MisskeyNote(note: reply),
      );
    }

    return Container();
  }
}
