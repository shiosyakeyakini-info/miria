import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChannelNoteHighlight extends ConsumerWidget {
  final String channelId;
  const ChannelNoteHighlight({required this.channelId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .notes
            .featured(NotesFeaturedRequest(channelId: channelId));

        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      nextFuture: (item, index) async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .notes
            .featured(
              NotesFeaturedRequest(
                offset: index,
                untilId: item.id,
                channelId: channelId,
              ),
            );

        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      itemBuilder: (context, item) => MisskeyNote(note: item),
    );
  }
}
