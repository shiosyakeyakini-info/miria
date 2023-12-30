import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UserNotes extends ConsumerStatefulWidget {
  final String userId;

  const UserNotes({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserNotesState();
}

class UserNotesState extends ConsumerState<UserNotes> {
  Misskey get misskey => ref.read(misskeyProvider(AccountScope.of(context)));

  bool isFileOnly = false;
  bool withReply = false;
  bool renote = true;
  bool highlight = false;
  DateTime? untilDate;

  @override
  Widget build(BuildContext context) {
    final account = AccountScope.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, bottom: 3),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      isSelected: [withReply, isFileOnly, renote, highlight],
                      onPressed: (value) {
                        setState(() {
                          switch (value) {
                            case 0:
                              withReply = !withReply;
                              highlight = false;
                            case 1:
                              isFileOnly = !isFileOnly;
                              highlight = false;
                            case 2:
                              renote = !renote;
                              highlight = false;
                            case 3:
                              withReply = false;
                              isFileOnly = false;
                              renote = false;
                              highlight = true;
                          }
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text("返信つき"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text("ファイルつき"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text("リノートも"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text("ハイライト"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final userDetailed = await ref.read(
                    userDetailedNotifierProvider((account, widget.userId))
                        .future,
                  );
                  final firstDate = userDetailed.createdAt;
                  if (!mounted) return;
                  final result = await showDatePicker(
                    context: context,
                    initialDate: untilDate ?? DateTime.now(),
                    helpText: "この日までを表示",
                    firstDate: firstDate,
                    lastDate: DateTime.now(),
                  );
                  if (result != null) {
                    untilDate = DateTime(
                      result.year,
                      result.month,
                      result.day,
                      23,
                      59,
                      59,
                      999,
                    );
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.date_range),
              ),
            ],
          ),
        ),
        Expanded(
          child: PushableListView<Note>(
            listKey: Object.hashAll(
                [isFileOnly, withReply, renote, untilDate, highlight]),
            additionalErrorInfo: highlight
                ? (context, e) => const Text("ハイライトはMisskey 2023.10.0以降の機能です。")
                : null,
            initializeFuture: () async {
              final Iterable<Note> notes;
              if (highlight) {
                notes = await misskey.users.featuredNotes(
                  UsersFeaturedNotesRequest(userId: widget.userId),
                );
              } else {
                notes = await misskey.users.notes(
                  UsersNotesRequest(
                    userId: widget.userId,
                    withFiles: isFileOnly,
                    // 後方互換性のため
                    includeReplies: withReply,
                    includeMyRenotes: renote,
                    withReplies: withReply,
                    withRenotes: renote,
                    withChannelNotes: true,
                    untilDate: untilDate?.millisecondsSinceEpoch,
                  ),
                );
              }
              if (!mounted) return [];
              ref
                  .read(notesProvider(AccountScope.of(context)))
                  .registerAll(notes);
              return notes.toList();
            },
            nextFuture: (lastElement, _) async {
              final Iterable<Note> notes;
              if (highlight) {
                notes = await misskey.users.featuredNotes(
                  UsersFeaturedNotesRequest(
                    userId: widget.userId,
                    untilId: lastElement.id,
                  ),
                );
              } else {
                notes = await misskey.users.notes(
                  UsersNotesRequest(
                    userId: widget.userId,
                    untilId: lastElement.id,
                    withFiles: isFileOnly,
                    includeReplies: withReply,
                    includeMyRenotes: renote,
                    withReplies: withReply,
                    withRenotes: renote,
                    withChannelNotes: true,
                    untilDate: untilDate?.millisecondsSinceEpoch,
                  ),
                );
              }
              if (!mounted) return [];
              ref
                  .read(notesProvider(AccountScope.of(context)))
                  .registerAll(notes);
              return notes.toList();
            },
            itemBuilder: (context, element) {
              return MisskeyNote(note: element);
            },
          ),
        ),
      ],
    );
  }
}
