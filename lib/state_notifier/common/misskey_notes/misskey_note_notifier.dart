import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "misskey_note_notifier.g.dart";

@riverpod
class MisskeyNoteNotifier extends _$MisskeyNoteNotifier {
  @override
  void build(Account account) {
    return;
  }

  /// 指定したアカウントから見たNoteを返す
  Future<Note?> lookupNote({
    required Account account,
    required Note note,
  }) async {
    if (account.host == this.account.host) {
      return note;
    }

    if (note.localOnly) {
      await ref.read(dialogStateNotifierProvider.notifier).showSimpleDialog(
            message: (context) =>
                S.of(context).cannotOpenLocalOnlyNoteFromRemote,
          );
      return null;
    }

    final host = note.user.host ?? this.account.host;

    try {
      // まず、自分のサーバーの直近のノートに該当のノートが含まれているか見る
      final user = await ref.read(misskeyProvider(account)).users.showByName(
            UsersShowByUserNameRequest(
              userName: note.user.username,
              host: host,
            ),
          );

      final userNotes = await ref.read(misskeyProvider(account)).users.notes(
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
                () async => await ref.read(misskeyProvider(account)).ap.show(
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
    required Account account,
    required User user,
  }) async {
    if (account.host == this.account.host) {
      return user;
    }

    final host = user.host ?? this.account.host;

    final response = await ref.read(dialogStateNotifierProvider.notifier).guard(
          () async => ref.read(misskeyProvider(account)).users.showByName(
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
    Note note,
    Account? loginAs,
  ) async {
    final foundNote =
        loginAs == null ? note : await lookupNote(note: note, account: loginAs);
    if (!context.mounted) return;
    if (foundNote == null) return;
    await context.pushRoute(
      NoteDetailRoute(note: foundNote, account: loginAs ?? this.account),
    );
  }

  Future<void> navigateToUserPage(
    BuildContext context,
    User user,
    Account? loginAs,
  ) async {
    final foundUser =
        loginAs == null ? user : await lookupUser(account: loginAs, user: user);
    if (foundUser == null) return;
    if (!context.mounted) return;
    await context.pushRoute(
      UserRoute(userId: foundUser.id, account: loginAs ?? this.account),
    );
  }

  Future<void> openNoteInOtherAccount(BuildContext context, Note note) async {
    final selectedAccount = await context.pushRoute<Account>(
      AccountSelectRoute(
        host: note.localOnly ? this.account.host : null,
      ),
    );
    if (selectedAccount == null) return;
    if (!context.mounted) return;
    await navigateToNoteDetailPage(context, note, selectedAccount);
  }

  Future<void> openUserInOtherAccount(BuildContext context, User user) async {
    final selectedAccount = await context.pushRoute<Account>(
      AccountSelectRoute(),
    );

    if (selectedAccount == null) return;
    if (!context.mounted) return;
    await navigateToUserPage(context, user, selectedAccount);
  }
}
