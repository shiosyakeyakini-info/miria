import "package:flutter/foundation.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "misskey_note_notifier.g.dart";

@Riverpod(dependencies: [accountContext, misskeyGetContext], keepAlive: true)
class MisskeyNoteNotifier extends _$MisskeyNoteNotifier {
  @override
  void build() {
    return;
  }

  /// 指定したアカウントから見たNoteを返す
  Future<Note?> lookupNote({
    required Note note,
    required AccountContext accountContext,
  }) async {
    if (note.user.host == null &&
        ref.read(accountContextProvider).getAccount.host ==
            accountContext.getAccount.host) {
      return note;
    }

    if (note.localOnly) {
      await ref.read(dialogStateNotifierProvider.notifier).showSimpleDialog(
            message: (context) =>
                S.of(context).cannotOpenLocalOnlyNoteFromRemote,
          );
      return null;
    }

    final host = note.url?.host ??
        note.user.host ??
        ref.read(accountContextProvider).getAccount.host;

    try {
      // まず、自分のサーバーの直近のノートに該当のノートが含まれているか見る
      final user = await ref
          .read(misskeyProvider(accountContext.getAccount))
          .users
          .showByName(
            UsersShowByUserNameRequest(
              userName: note.user.username,
              host: host,
            ),
          );

      final userNotes = await ref
          .read(misskeyProvider(accountContext.getAccount))
          .users
          .notes(
            UsersNotesRequest(
              userId: user.id,
              untilDate: note.createdAt.add(const Duration(seconds: 1)),
            ),
          );

      return userNotes
          .firstWhere((e) => e.id == note.uri?.pathSegments.lastOrNull);
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }

      // 最終手段として、連合で照会する
      final response =
          await ref.read(dialogStateNotifierProvider.notifier).guard(
                () async => await ref
                    .read(misskeyProvider(accountContext.getAccount))
                    .ap
                    .show(
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
    required AccountContext accountContext,
  }) async {
    final accountContextHost = ref.read(accountContextProvider).getAccount.host;
    if (user.host == null &&
        accountContextHost == accountContext.getAccount.host) {
      return user;
    }

    final host = user.host ?? accountContext.getAccount.host;

    final response = await ref.read(dialogStateNotifierProvider.notifier).guard(
          () async => ref
              .read(misskeyProvider(accountContext.getAccount))
              .users
              .showByName(
                UsersShowByUserNameRequest(userName: user.username, host: host),
              ),
        );
    return response.valueOrNull;
  }

  Future<void> navigateToNoteDetailPage(
    Note note, {
    Account? account,
  }) async {
    final router = ref.read(appRouterProvider);
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      final accountContext = account != null
          ? AccountContext(
              getAccount: account,
              postAccount: account.isDemoAccount
                  ? ref.read(accountContextProvider).postAccount
                  : account,
            )
          : ref.read(accountContextProvider);
      final foundNote = note.user.host == null &&
              note.uri?.host == accountContext.getAccount.host
          ? note
          : await lookupNote(
              note: note,
              accountContext: accountContext,
            );
      if (foundNote == null) return;
      await router.push(
        NoteDetailRoute(note: foundNote, accountContext: accountContext),
      );
    });
  }

  Future<void> navigateToUserPage(
    User user, {
    Account? account,
  }) async {
    final router = ref.read(appRouterProvider);
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      final accountContext = account != null
          ? AccountContext(
              getAccount: account,
              postAccount: account.isDemoAccount
                  ? ref.read(accountContextProvider).postAccount
                  : account,
            )
          : ref.read(accountContextProvider);
      final foundUser = user.host == null &&
              accountContext.getAccount ==
                  ref.read(accountContextProvider).getAccount
          ? user
          : await lookupUser(user: user, accountContext: accountContext);
      if (foundUser == null) return;
      await router.push(
        UserRoute(userId: foundUser.id, accountContext: accountContext),
      );
    });
  }

  Future<void> openNoteInOtherAccount(Note note) async {
    final accountContext = ref.read(accountContextProvider);
    final selectedAccount = await ref.read(appRouterProvider).push<Account>(
          AccountSelectRoute(
            host: note.localOnly ? accountContext.getAccount.host : null,
            remoteHost: note.user.host != accountContext.getAccount.host &&
                    note.user.host != null
                ? note.user.host
                : null,
          ),
        );
    if (selectedAccount == null) return;
    await navigateToNoteDetailPage(note, account: selectedAccount);
  }

  Future<void> openUserInOtherAccount(User user) async {
    final accountContext = ref.read(accountContextProvider);
    final selectedAccount = await ref.read(appRouterProvider).push<Account>(
          AccountSelectRoute(
            remoteHost:
                user.host != accountContext.getAccount.host && user.host != null
                    ? user.host
                    : null,
          ),
        );

    if (selectedAccount == null) return;
    await navigateToUserPage(user, account: selectedAccount);
  }
}
