import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/user_page/user_page.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UserNotes extends ConsumerStatefulWidget {
  final String userId;

  final Account? actualAccount;

  const UserNotes(
      {super.key, required this.userId, required this.actualAccount});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserNotesState();
}

class UserNotesState extends ConsumerState<UserNotes> {
  Misskey get misskey => ref.read(misskeyProvider(AccountScope.of(context)));

  bool isFileOnly = false;
  bool withReply = false;
  bool renote = true;
  DateTime? untilDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, bottom: 3),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: ToggleButtons(
                    isSelected: [
                      withReply,
                      isFileOnly,
                      renote,
                    ],
                    onPressed: (value) {
                      setState(() {
                        switch (value) {
                          case 0:
                            withReply = !withReply;
                          case 1:
                            isFileOnly = !isFileOnly;
                          case 2:
                            renote = !renote;
                        }
                      });
                    },
                    children: const [
                      Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text("返信つき")),
                      Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text("ファイルつき")),
                      Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text("リノートも"))
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    final firstDate = widget.actualAccount == null
                        ? ref
                            .read(userInfoProvider(widget.userId))
                            ?.response
                            ?.createdAt
                        : ref
                            .read(userInfoProvider(widget.userId))
                            ?.remoteResponse
                            ?.createdAt;

                    final result = await showDatePicker(
                        context: context,
                        initialDate: untilDate ?? DateTime.now(),
                        helpText: "この日までを表示",
                        firstDate: firstDate ?? DateTime.now(),
                        lastDate: DateTime.now());
                    if (result != null) {
                      untilDate = DateTime(result.year, result.month,
                          result.day, 23, 59, 59, 999);
                    }
                    setState(() {});
                  },
                  icon: const Icon(Icons.date_range))
            ],
          ),
        ),
        Expanded(
          child: PushableListView<Note>(
              listKey:
                  Object.hashAll([isFileOnly, withReply, renote, untilDate]),
              initializeFuture: () async {
                final notes = await misskey.users.notes(UsersNotesRequest(
                  userId: widget.userId,
                  withFiles: isFileOnly,
                  includeReplies: withReply,
                  includeMyRenotes: renote,
                  untilDate: untilDate?.millisecondsSinceEpoch,
                ));
                if (!mounted) return [];
                ref
                    .read(notesProvider(AccountScope.of(context)))
                    .registerAll(notes);
                return notes.toList();
              },
              nextFuture: (lastElement, _) async {
                final notes = await misskey.users.notes(UsersNotesRequest(
                  userId: widget.userId,
                  untilId: lastElement.id,
                  withFiles: isFileOnly,
                  includeReplies: withReply,
                  includeMyRenotes: renote,
                  untilDate: untilDate?.millisecondsSinceEpoch,
                ));
                if (!mounted) return [];
                ref
                    .read(notesProvider(AccountScope.of(context)))
                    .registerAll(notes);
                return notes.toList();
              },
              itemBuilder: (context, element) {
                return MisskeyNote(
                  note: element,
                  loginAs: widget.actualAccount,
                );
              }),
        ),
      ],
    );
  }
}
