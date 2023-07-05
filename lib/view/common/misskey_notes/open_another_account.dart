import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:misskey_dart/misskey_dart.dart';

class OpenAnotherAccount extends ConsumerStatefulWidget {
  final Note note;
  final Account beforeOpenAccount;
  const OpenAnotherAccount({
    super.key,
    required this.note,
    required this.beforeOpenAccount,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      OpenAnotherAccountState();
}

class OpenAnotherAccountState extends ConsumerState<OpenAnotherAccount> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("別のアカウントで開く"),
      onTap: () async {
        final account = await showDialog<Account?>(
            context: context,
            builder: (context2) => const AccountSelectDialog());

        if (account == null) return;

        try {
          // まず、自分のサーバーの直近のノートに該当のノートが含まれているか見る
          final myHostUserData = await ref
              .read(misskeyProvider(account))
              .users
              .showByName(UsersShowByUserNameRequest(
                  userName: widget.note.user.username,
                  host:
                      widget.note.user.host ?? widget.beforeOpenAccount.host));

          final myHostUserNotes = await ref
              .read(misskeyProvider(account))
              .users
              .notes(UsersNotesRequest(
                userId: myHostUserData.id,
                untilDate: widget.note.createdAt.millisecondsSinceEpoch + 1,
              ));

          final foundMyHostNote = myHostUserNotes.firstWhereOrNull(
              (e) => e.uri?.pathSegments.lastOrNull == widget.note.id);
          if (foundMyHostNote != null) {
            if (!mounted) return;
            context.pushRoute(
                NoteDetailRoute(note: foundMyHostNote, account: account));
            return;
          }
          throw Exception();
        } catch (e) {
          // 最終手段として、連合で照会する
          final result = await ref.read(misskeyProvider(account)).ap.show(
              ApShowRequest(
                  uri: widget.note.uri ??
                      Uri(
                          scheme: "https",
                          host: widget.beforeOpenAccount.host,
                          pathSegments: ["notes", widget.note.id])));
          // よくかんがえたら無駄
          final resultNote = await ref
              .read(misskeyProvider(account))
              .notes
              .show(NotesShowRequest(noteId: result.object["id"]));
          if (!mounted) return;
          context
              .pushRoute(NoteDetailRoute(note: resultNote, account: account));
        }
      },
    );
  }
}

class AccountSelectDialog extends ConsumerWidget {
  const AccountSelectDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts =
        ref.watch(accountRepository.select((value) => value.account));
    return AlertDialog(
      title: const Text("開くアカウント選んでや"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView(
          children: [
            for (final account in accounts)
              AccountScope(
                account: account,
                child: ListTile(
                  leading: AvatarIcon.fromIResponse(account.i),
                  title: SimpleMfmText(account.i.name ?? account.i.username,
                      style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text(
                    "@${account.userId}@${account.host}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(account);
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
