import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/user_page/user_list_item.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RenoteUserDialog extends ConsumerWidget {
  final Account account;
  final String noteId;

  const RenoteUserDialog({
    super.key,
    required this.account,
    required this.noteId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
        account: account,
        child: AlertDialog(
            title:  Text(S.of(context).renotedUsers),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: PushableListView<Note>(
                    initializeFuture: () async {
                      final response = await ref
                          .read(misskeyProvider(account))
                          .notes
                          .renotes(
                            NotesRenoteRequest(noteId: noteId),
                          );
                      ref
                          .read(notesProvider(account))
                          .registerAll(response.where((e) => e.text != null));
                      return response.toList();
                    },
                    nextFuture: (lastItem, _) async {
                      final response = await ref
                          .read(misskeyProvider(account))
                          .notes
                          .renotes(NotesRenoteRequest(
                              noteId: noteId, untilId: lastItem.id));
                      ref
                          .read(notesProvider(account))
                          .registerAll(response.where((e) => e.text != null));
                      return response.toList();
                    },
                    itemBuilder: (context, note) {
                      return UserListItem(user: note.user);
                    },
                    showAd: false,
                  )),
            )));
  }
}
