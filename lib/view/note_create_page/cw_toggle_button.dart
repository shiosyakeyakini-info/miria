import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/common/account_scope.dart";

class CwToggleButton extends ConsumerWidget {
  const CwToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cw = ref.watch(
      noteCreateNotifierProvider(AccountScope.of(context))
          .select((value) => value.isCw),
    );
    return IconButton(
      onPressed: () => ref
          .read(noteCreateNotifierProvider(AccountScope.of(context)).notifier)
          .toggleCw(),
      icon: Icon(cw ? Icons.visibility_off : Icons.remove_red_eye),
    );
  }
}
