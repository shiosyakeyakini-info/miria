import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class NoteDetailPage extends ConsumerStatefulWidget {
  final Note note;
  final Account account;

  const NoteDetailPage({
    super.key,
    required this.note,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteDetailPageState();
}

class NoteDetailPageState extends ConsumerState<NoteDetailPage> {
  List<Note> conversations = [];
  Note? actualShow;

  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future(() async {
      actualShow = await ref
          .read(misskeyProvider(widget.account))
          .notes
          .show(NotesShowRequest(noteId: widget.note.id));
      ref.read(notesProvider(widget.account)).registerNote(actualShow!);
      final conversationResult = await ref
          .read(misskeyProvider(widget.account))
          .notes
          .conversation(NotesConversationRequest(noteId: widget.note.id));
      ref.read(notesProvider(widget.account)).registerAll(conversationResult);
      ref
          .read(notesProvider(widget.account))
          .registerAll(conversationResult.map((e) => e.reply).whereNotNull());
      conversations
        ..clear()
        ..addAll(conversationResult.toList().reversed);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).note)),
        body: Padding(
          padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: conversations.length,
                          itemBuilder: (context, index) {
                            return MisskeyNote(
                              note: conversations[index],
                              isForceUnvisibleRenote: true,
                              isForceUnvisibleReply: true,
                            );
                          }),
                      MisskeyNote(
                        note: actualShow!,
                        recursive: 1,
                        isForceUnvisibleReply: true,
                        isDisplayBorder: false,
                        isForceVisibleLong: true,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Text(
                        S.of(context).noteCreatedAt(
                              actualShow!.createdAt
                                  .formatUntilMilliSeconds(context),
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
                            initializeFuture: () async {
                              final repliesResult = await ref
                                  .read(misskeyProvider(widget.account))
                                  .notes
                                  .children(NotesChildrenRequest(
                                      noteId: widget.note.id));
                              ref
                                  .read(notesProvider(widget.account))
                                  .registerAll(repliesResult);
                              return repliesResult.toList();
                            },
                            nextFuture: (lastItem, _) async {
                              final repliesResult = await ref
                                  .read(misskeyProvider(widget.account))
                                  .notes
                                  .children(NotesChildrenRequest(
                                      noteId: widget.note.id,
                                      untilId: lastItem.id));
                              ref
                                  .read(notesProvider(widget.account))
                                  .registerAll(repliesResult);
                              return repliesResult.toList();
                            },
                            itemBuilder: (context, item) {
                              return MisskeyNote(
                                note: item,
                                recursive: 1,
                                isForceUnvisibleRenote: true,
                                isForceUnvisibleReply: true,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
