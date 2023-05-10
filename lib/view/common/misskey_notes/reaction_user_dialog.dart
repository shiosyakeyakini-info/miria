import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/futable_list_builder.dart';
import 'package:flutter_misskey_app/view/common/pushable_listview.dart';
import 'package:flutter_misskey_app/view/user_page/user_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ReactionUserDialog extends ConsumerWidget {
  final Account account;
  final String reaction;
  final String noteId;

  const ReactionUserDialog({
    super.key,
    required this.account,
    required this.reaction,
    required this.noteId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
      account: account,
      child: AlertDialog(
        title: Text(reaction),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: FutureListView(
                future: () async {
                  final response = await ref
                      .read(misskeyProvider(account))
                      .notes
                      .reactions
                      .reactions(NotesReactionsRequest(
                        noteId: noteId,
                        type: reaction,
                      ));
                  return response.toList();
                }(),
                builder: (context, item) => UserListItem(user: item.user),
              )

              /*PushableListView(
              initializeFuture: () async {
                final response = await ref
                    .read(misskeyProvider(account))
                    .notes
                    .reactions
                    .reactions(NotesReactionsRequest(
                      noteId: noteId,
                      type: reaction,
                    ));
                return response.toList();
              },
              nextFuture: (lastItem) async {
                final response = await ref
                    .read(misskeyProvider(account))
                    .notes
                    .reactions
                    .reactions(NotesReactionsRequest(
                      noteId: noteId,
                      type: reaction,
                      untilId: lastItem.id,
                    ));
                return response.toList();
              },
              itemBuilder: (context, item) => UserListItem(user: item.user),
            ),*/
              ),
        ),
      ),
    );
  }
}
