import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:miria/view/time_line_page/timeline_note.dart";

class TimelineEmoji extends ConsumerWidget {
  const TimelineEmoji({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputComplement(
        controller: ref.read(timelineNoteProvider),
        focusNode: timelineFocusNode);
  }
}
