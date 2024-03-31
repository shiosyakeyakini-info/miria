import "package:flutter/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class UsersListTimeline extends ConsumerWidget {
  final String listId;

  const UsersListTimeline({required this.listId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    return PushableListView<Note>(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyProvider(account))
            .notes
            .userListTimeline(UserListTimelineRequest(listId: listId));
        ref.read(notesProvider(account)).registerAll(response);
        return response.toList();
      },
      nextFuture: (lastItem, _) async {
        final response = await ref
            .read(misskeyProvider(account))
            .notes
            .userListTimeline(
                UserListTimelineRequest(listId: listId, untilId: lastItem.id));
        ref.read(notesProvider(account)).registerAll(response);
        return response.toList();
      },
      itemBuilder: (context, item) {
        return MisskeyNote(note: item);
      },
    );
  }
}
