import "package:flutter/cupertino.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class ClipDetailNoteList extends ConsumerWidget {
  final String id;

  const ClipDetailNoteList({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView<Note>(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .clips
            .notes(ClipsNotesRequest(clipId: id));
        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      nextFuture: (latestItem, _) async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .clips
            .notes(ClipsNotesRequest(clipId: id, untilId: latestItem.id));
        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      itemBuilder: (context, item) {
        return MisskeyNote(note: item);
      },
    );
  }
}
