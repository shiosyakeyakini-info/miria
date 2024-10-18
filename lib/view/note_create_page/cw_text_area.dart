import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/themes/app_theme.dart";

class CwTextArea extends HookConsumerWidget {
  const CwTextArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cwController = useTextEditingController();
    cwController.addListener(() {
      ref
          .watch(noteCreateNotifierProvider.notifier)
          .setCwText(cwController.text);
    });

    ref.listen(
      noteCreateNotifierProvider.select((value) => value.cwText),
      (_, next) {
        if (next != cwController.text) cwController.text = next;
      },
    );

    final cw = ref.watch(
      noteCreateNotifierProvider.select((value) => value.isCw),
    );

    if (!cw) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: cwController,
          keyboardType: TextInputType.multiline,
          decoration: AppTheme.of(context).noteTextStyle.copyWith(
                hintText: S.of(context).contentWarning,
                contentPadding: const EdgeInsets.all(5),
              ),
        ),
      ),
    );
  }
}
