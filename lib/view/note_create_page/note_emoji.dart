import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:miria/view/note_create_page/note_create_page.dart";

class NoteEmoji extends ConsumerWidget {
  const NoteEmoji({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseHeight = MediaQuery.textScalerOf(
      context,
    ).scale((Theme.of(context).textTheme.bodyMedium?.fontSize ?? 22) * 1.35);
    final cwFocus = ref.watch(cwFocusProvider);
    final noteFocus = ref.watch(noteFocusProvider);

    final useCw = cwFocus.hasFocus && !noteFocus.hasFocus;
    final controller = useCw
        ? ref.read(cwInputTextProvider)
        : ref.read(noteInputTextProvider);
    final focusProvider = useCw ? cwFocusProvider : noteFocusProvider;
    return SizedBox(
      height: baseHeight + 40,
      child: InputComplement(controller: controller, focusNode: focusProvider),
    );
  }
}
