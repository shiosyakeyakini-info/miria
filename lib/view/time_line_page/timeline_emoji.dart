import 'package:flutter/material.dart';
import 'package:miria/view/common/note_create/input_completation.dart';
import 'package:miria/view/time_line_page/timeline_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

final filteredInputEmojiProvider =
    StateProvider.autoDispose((ref) => <Emoji>[]);

class TimelineEmoji extends ConsumerWidget {
  const TimelineEmoji({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(timelineFocusNode);

    return InputComplement(
        searchedEmojiProvider: filteredInputEmojiProvider,
        controller: ref.read(timelineNoteProvider),
        focusNode: timelineFocusNode);
  }
}
