import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class AntennaNotes extends ConsumerWidget {
  final String antennaId;

  const AntennaNotes({required this.antennaId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .antennas
            .notes(AntennasNotesRequest(antennaId: antennaId));
        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      nextFuture: (lastItem, _) async {
        final response =
            await ref.read(misskeyGetContextProvider).antennas.notes(
                  AntennasNotesRequest(
                    antennaId: antennaId,
                    untilId: lastItem.id,
                  ),
                );
        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      itemBuilder: (context, item) => MisskeyNote(note: item),
    );
  }
}
