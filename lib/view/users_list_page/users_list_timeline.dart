import "package:flutter/widgets.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class UsersListTimeline extends ConsumerWidget {
  final String listId;

  const UsersListTimeline({required this.listId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView<Note>(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .notes
            .userListTimeline(UserListTimelineRequest(listId: listId));
        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      nextFuture: (lastItem, _) async {
        final response =
            await ref.read(misskeyGetContextProvider).notes.userListTimeline(
                  UserListTimelineRequest(listId: listId, untilId: lastItem.id),
                );
        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      itemBuilder: (context, item) {
        return MisskeyNote(note: item);
      },
    );
  }
}
