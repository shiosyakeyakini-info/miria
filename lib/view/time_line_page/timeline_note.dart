import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/themes/app_theme.dart";

final timelineNoteProvider =
    ChangeNotifierProvider.autoDispose((ref) => TextEditingController());

final timelineFocusNode =
    ChangeNotifierProvider.autoDispose((ref) => FocusNode());

class TimelineNoteField extends ConsumerWidget {
  const TimelineNoteField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteStyle = AppTheme.of(context).noteTextStyle;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextField(
        focusNode: ref.watch(timelineFocusNode),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: ref.watch(timelineNoteProvider),
        decoration: noteStyle,
        // onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      ),
    );
  }
}
