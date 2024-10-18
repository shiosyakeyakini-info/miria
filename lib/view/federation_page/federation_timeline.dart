import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class FederationTimeline extends ConsumerWidget {
  final String host;
  final MetaResponse meta;

  const FederationTimeline({
    required this.host,
    required this.meta,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: PushableListView(
        initializeFuture: () async {
          final result = await ref
              .read(misskeyGetContextProvider)
              .notes
              .localTimeline(const NotesLocalTimelineRequest());
          ref.read(notesWithProvider).registerAll(result);
          return result.toList();
        },
        nextFuture: (lastItem, _) async {
          final result =
              await ref.read(misskeyGetContextProvider).notes.localTimeline(
                    NotesLocalTimelineRequest(untilId: lastItem.id),
                  );
          ref.read(notesWithProvider).registerAll(result);
          return result.toList();
        },
        itemBuilder: (context2, item) => Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: MisskeyNote(
            note: item,
          ),
        ),
      ),
    );
  }
}
