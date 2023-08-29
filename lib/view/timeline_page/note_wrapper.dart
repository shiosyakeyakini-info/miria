import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/note_extension.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:misskey_dart/misskey_dart.dart';

final _noteFilterProvider =
    Provider.autoDispose.family<bool, (Note, TabSetting)>((ref, arg) {
  final (note, tabSetting) = arg;
  if (!tabSetting.renoteDisplay && note.isEmptyRenote) {
    return false;
  }
  if (tabSetting.isMediaOnly && note.files.isEmpty) {
    return false;
  }
  final nsfwInherit =
      ref.watch(generalSettingsRepositoryProvider).settings.nsfwInherit;
  if (nsfwInherit == NSFWInherit.removeNsfw && note.containsSensitiveFile) {
    return false;
  }
  return true;
});

final _subscribeNoteProvider =
    Provider.autoDispose.family<Note?, (Note, TabSetting)>((ref, tuple) {
  final (note, tabSetting) = tuple;

  final timelineRepository =
      ref.watch(timelineRepositoryProvider(tabSetting).notifier);

  timelineRepository.subscribe(note);

  ref.onDispose(() {
    timelineRepository.preserveUnsubscribe(note);
  });

  final account = ref.read(accountProvider(tabSetting.acct));
  return ref.watch(
    notesProvider(account).select(
      (noteRepository) => noteRepository.notes[note.id],
    ),
  );
});

class NoteWrapper extends ConsumerWidget {
  const NoteWrapper({
    super.key,
    required this.targetNote,
    required this.tabSetting,
  });

  final Note targetNote;
  final TabSetting tabSetting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final satisfied = ref.watch(_noteFilterProvider((targetNote, tabSetting)));
    if (!satisfied) {
      return const SizedBox.shrink();
    }

    final note = ref.watch(
      _subscribeNoteProvider((targetNote, tabSetting)),
    );

    if (note == null) {
      debugPrint("note was not found. $targetNote");
      return MisskeyNote(
        note: targetNote,
        key: ValueKey<String>(targetNote.id),
      );
    }
    return MisskeyNote(
      note: note,
      key: ValueKey<String>(note.id),
    );
  }
}
