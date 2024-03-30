import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class OpenLocalOnlyNoteFromRemoteException implements Exception {}

class MisskeyNoteNotifier extends FamilyNotifier<void, Account> {
  @override
  void build(Account arg) {
    return;
  }

  Account get _account => arg;

  /// 指定したアカウントから見たNoteを返す
  Future<Note> lookupNote({
    required Account account,
    required Note note,
  }) async {
    if (account.host == _account.host) {
      return note;
    }

    if (note.localOnly) {
      throw OpenLocalOnlyNoteFromRemoteException();
    }

    final host = note.user.host ?? _account.host;

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
      final response = await ref.read(misskeyProvider(account)).ap.show(
            ApShowRequest(
              uri: note.uri ??
                  Uri(
                    scheme: "https",
                    host: host,
                    pathSegments: ["notes", note.id],
                  ),
            ),
          );
      return Note.fromJson(response.object);
    }
  }

  /// 指定したアカウントから見たUserを返す
  Future<User> lookupUser({
    required Account account,
    required User user,
  }) async {
    if (account.host == _account.host) {
      return user;
    }

    final host = user.host ?? _account.host;

    try {
      return ref.read(misskeyProvider(account)).users.showByName(
            UsersShowByUserNameRequest(
              userName: user.username,
              host: host,
            ),
          );
    } catch (e) {
      // 最終手段として、連合で照会する
      // `users/show` で自動的に照会されるから必要ない
      final response = await ref.read(misskeyProvider(account)).ap.show(
            ApShowRequest(
              uri: Uri(
                scheme: "https",
                host: user.host,
                pathSegments: ["@$host"],
              ),
            ),
          );
      return UserDetailed.fromJson(response.object);
    }
  }

  Future<void> navigateToNoteDetailPage(
    BuildContext context,
    Note note,
    Account? loginAs,
  ) async {
    final foundNote = loginAs == null
        ? note
        : await lookupNote(
            note: note,
            account: loginAs,
          );
    if (!context.mounted) return;
    context.pushRoute(
      NoteDetailRoute(
        note: foundNote,
        account: loginAs ?? _account,
      ),
    );
  }

  Future<void> navigateToUserPage(
    BuildContext context,
    User user,
    Account? loginAs,
  ) async {
    final foundUser = loginAs == null
        ? user
        : await lookupUser(
            account: loginAs,
            user: user,
          );
    if (!context.mounted) return;
    context.pushRoute(
      UserRoute(
        userId: foundUser.id,
        account: loginAs ?? _account,
      ),
    );
  }

  Future<void> openNoteInOtherAccount(BuildContext context, Note note) async {
    final selectedAccount = await showDialog<Account?>(
      context: context,
      builder: (context) => AccountSelectDialog(
        host: note.localOnly ? _account.host : null,
      ),
    );
    if (selectedAccount == null) return;
    if (!context.mounted) return;
    await navigateToNoteDetailPage(context, note, selectedAccount);
  }

  Future<void> openUserInOtherAccount(BuildContext context, User user) async {
    final selectedAccount = await showDialog<Account?>(
      context: context,
      builder: (context) => const AccountSelectDialog(),
    );
    if (selectedAccount == null) return;
    if (!context.mounted) return;
    await navigateToUserPage(context, user, selectedAccount);
  }
}
