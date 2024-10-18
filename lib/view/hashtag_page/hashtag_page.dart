import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class HashtagPage extends ConsumerWidget implements AutoRouteWrapper {
  final String hashtag;
  final AccountContext accountContext;

  const HashtagPage({
    required this.hashtag,
    required this.accountContext,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("#$hashtag")),
      body: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: PushableListView(
          initializeFuture: () async {
            final response = await ref
                .read(misskeyGetContextProvider)
                .notes
                .searchByTag(NotesSearchByTagRequest(tag: hashtag));
            ref.read(notesWithProvider).registerAll(response);
            return response.toList();
          },
          nextFuture: (lastItem, _) async {
            final response =
                await ref.read(misskeyGetContextProvider).notes.searchByTag(
                      NotesSearchByTagRequest(
                        tag: hashtag,
                        untilId: lastItem.id,
                      ),
                    );
            ref.read(notesWithProvider).registerAll(response);
            return response.toList();
          },
          itemBuilder: (context, item) => MisskeyNote(note: item),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.pushRoute(
            NoteCreateRoute(
              initialAccount: accountContext.postAccount,
              initialText: "#$hashtag",
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
