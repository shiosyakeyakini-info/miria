import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class RenoteUserDialog extends ConsumerWidget implements AutoRouteWrapper {
  final Account account;
  final String noteId;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountScopeMark2(account: account, child: this);

  const RenoteUserDialog({
    required this.account,
    required this.noteId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
      account: account,
      child: AlertDialog(
        title: Text(S.of(context).renotedUsers),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: PushableListView<Note>(
              initializeFuture: () async {
                final response =
                    await ref.read(misskeyProvider(account)).notes.renotes(
                          NotesRenoteRequest(noteId: noteId),
                        );
                ref
                    .read(notesProvider(account))
                    .registerAll(response.where((e) => e.text != null));
                return response.toList();
              },
              nextFuture: (lastItem, _) async {
                final response =
                    await ref.read(misskeyProvider(account)).notes.renotes(
                          NotesRenoteRequest(
                            noteId: noteId,
                            untilId: lastItem.id,
                          ),
                        );
                ref
                    .read(notesProvider(account))
                    .registerAll(response.where((e) => e.text != null));
                return response.toList();
              },
              itemBuilder: (context, note) {
                return UserListItem(user: note.user);
              },
              showAd: false,
            ),
          ),
        ),
      ),
    );
  }
}
