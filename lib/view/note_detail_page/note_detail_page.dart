import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "note_detail_page.g.dart";

@Riverpod(dependencies: [misskeyGetContext, notesWith])
Future<Note> _notesShow(_NotesShowRef ref, String noteId) async {
  final note = await ref
      .read(misskeyGetContextProvider)
      .notes
      .show(NotesShowRequest(noteId: noteId));

  ref.read(notesWithProvider).registerNote(note);

  return note;
}

@Riverpod(dependencies: [misskeyGetContext, notesWith])
Future<List<Note>> _conversation(_ConversationRef ref, String noteId) async {
  final conversationResult = await ref
      .read(misskeyGetContextProvider)
      .notes
      .conversation(NotesConversationRequest(noteId: noteId));
  ref.read(notesWithProvider).registerAll(conversationResult);
  ref
      .read(notesWithProvider)
      .registerAll(conversationResult.map((e) => e.reply).whereNotNull());

  return [
    ...[...conversationResult].reversed,
  ];
}

@RoutePage()
class NoteDetailPage extends ConsumerWidget implements AutoRouteWrapper {
  final Note note;
  final AccountContext accountContext;

  const NoteDetailPage({
    required this.note,
    required this.accountContext,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesShow = ref.watch(_notesShowProvider(note.id));
    final conversation = ref.watch(_conversationProvider(note.id));

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).note)),
      body: Padding(
        padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
        child: switch (notesShow) {
          AsyncLoading() => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          AsyncError(:final error, :final stackTrace) =>
            ErrorDetail(error: error, stackTrace: stackTrace),
          AsyncData(:final value) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  switch (conversation) {
                    AsyncLoading() => const SizedBox.square(
                        dimension: 100,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    AsyncError(:final error, :final stackTrace) =>
                      ErrorDetail(error: error, stackTrace: stackTrace),
                    AsyncData(:final value) => ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return MisskeyNote(
                            note: value[index],
                            isForceUnvisibleRenote: true,
                            isForceUnvisibleReply: true,
                          );
                        },
                      ),
                  },
                  MisskeyNote(
                    note: value,
                    recursive: 1,
                    isForceUnvisibleReply: true,
                    isDisplayBorder: false,
                    isForceVisibleLong: true,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    S.of(context).noteCreatedAt(
                          value.createdAt.formatUntilMilliSeconds(context),
                        ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  const Divider(),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: PushableListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      hideIsEmpty: true,
                      initializeFuture: () async {
                        final repliesResult = await ref
                            .read(misskeyGetContextProvider)
                            .notes
                            .children(NotesChildrenRequest(noteId: note.id));
                        ref.read(notesWithProvider).registerAll(repliesResult);
                        return repliesResult.toList();
                      },
                      nextFuture: (lastItem, _) async {
                        final repliesResult = await ref
                            .read(misskeyGetContextProvider)
                            .notes
                            .children(
                              NotesChildrenRequest(
                                noteId: note.id,
                                untilId: lastItem.id,
                              ),
                            );
                        ref.read(notesWithProvider).registerAll(repliesResult);
                        return repliesResult.toList();
                      },
                      itemBuilder: (context, item) {
                        return MisskeyNote(
                          note: item,
                          recursive: 1,
                          isForceUnvisibleRenote: true,
                          isForceUnvisibleReply: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
        },
      ),
    );
  }
}
