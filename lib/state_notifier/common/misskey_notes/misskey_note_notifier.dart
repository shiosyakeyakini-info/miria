import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_select_dialog.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "misskey_note_notifier.g.dart";

@Riverpod(dependencies: [accountContext, misskeyGetContext])
class MisskeyNoteNotifier extends _$MisskeyNoteNotifier {
  @override
  void build() {
    return;
  }

  /// 指定したアカウントから見たNoteを返す
  Future<Note?> lookupNote({
    required Note note,
  }) async {
    final accountContext = ref.read(accountContextProvider);
    if (accountContext.isSame) {
      return note;
    }

    if (note.localOnly) {
      await ref.read(dialogStateNotifierProvider.notifier).showSimpleDialog(
            message: (context) =>
                S.of(context).cannotOpenLocalOnlyNoteFromRemote,
          );
      return null;
    }

    final host = note.user.host ?? accountContext.getAccount.host;

    try {
      // まず、自分のサーバーの直近のノートに該当のノートが含まれているか見る
      final user = await ref.read(misskeyGetContextProvider).users.showByName(
            UsersShowByUserNameRequest(
              userName: note.user.username,
              host: host,
            ),
          );

      final userNotes = await ref.read(misskeyGetContextProvider).users.notes(
            UsersNotesRequest(
              userId: user.id,
              untilDate: note.createdAt.add(const Duration(seconds: 1)),
            ),
          );

      return userNotes
          .firstWhere((e) => e.uri?.pathSegments.lastOrNull == note.id);
    } catch (e) {
      // 最終手段として、連合で照会する
      final response =
          await ref.read(dialogStateNotifierProvider.notifier).guard(
                () async => await ref.read(misskeyGetContextProvider).ap.show(
                      ApShowRequest(
                        uri: note.uri ??
                            Uri(
                              scheme: "https",
                              host: host,
                              pathSegments: ["notes", note.id],
                            ),
                      ),
                    ),
              );
      final result = response.valueOrNull?.object;
      if (result == null) return null;
      return Note.fromJson(result);
    }
  }

  /// 指定したアカウントから見たUserを返す
  Future<User?> lookupUser({
    required User user,
  }) async {
    final accountContext = ref.read(accountContextProvider);
    if (accountContext.isSame) {
      return user;
    }

    final host = user.host ?? accountContext.getAccount.host;

    final response = await ref.read(dialogStateNotifierProvider.notifier).guard(
          () async => ref.read(misskeyGetContextProvider).users.showByName(
                UsersShowByUserNameRequest(
                  userName: user.username,
                  host: host,
                ),
              ),
        );
    return response.valueOrNull;
  }

  Future<void> navigateToNoteDetailPage(
    BuildContext context,
    Note note, {
    Account? account,
  }) async {
    final accountContext = ref.read(accountContextProvider);
    final foundNote =
        accountContext.isSame ? note : await lookupNote(note: note);
    if (!context.mounted) return;
    if (foundNote == null) return;
    await context.pushRoute(
      NoteDetailRoute(
          note: foundNote, account: account ?? accountContext.postAccount),
    );
  }

  Future<void> navigateToUserPage(
    BuildContext context,
    User user, {
    Account? account,
  }) async {
    final accountContext = ref.read(accountContextProvider);
    final foundUser =
        accountContext.isSame ? user : await lookupUser(user: user);
    if (foundUser == null) return;
    if (!context.mounted) return;
    await context.pushRoute(
      UserRoute(
          userId: foundUser.id, account: account ?? accountContext.getAccount),
    );
  }

  Future<void> openNoteInOtherAccount(BuildContext context, Note note) async {
    final accountContext = ref.read(accountContextProvider);
    final selectedAccount = await context.pushRoute<Account>(
      AccountSelectRoute(
          host: note.localOnly ? accountContext.getAccount.host : null),
    );
    if (selectedAccount == null) return;
    if (!context.mounted) return;
    await navigateToNoteDetailPage(context, note, account: selectedAccount);
  }

  Future<void> openUserInOtherAccount(BuildContext context, User user) async {
    final selectedAccount = await showDialog<Account?>(
      context: context,
      builder: (context) => const AccountSelectDialog(),
    );
    if (selectedAccount == null) return;
    if (!context.mounted) return;
    await navigateToUserPage(context, user, account: selectedAccount);
  }
}
