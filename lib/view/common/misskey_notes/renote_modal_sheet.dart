import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class RenoteModalSheet extends ConsumerWidget {
  final Note note;
  final Account account;

  const RenoteModalSheet({
    super.key,
    required this.note,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          onTap: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final navigator = Navigator.of(context);
            await ref
                .read(misskeyProvider(account))
                .notes
                .create(NotesCreateRequest(renoteId: note.id));
            scaffoldMessenger
                .showSnackBar(const SnackBar(content: Text("Renoteしました。")));
            navigator.pop();
          },
          title: const Text("Renote"),
        ),
        ListTile(
            onTap: () {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              context.pushRoute(
                  NoteCreateRoute(renote: note, initialAccount: account));
              scaffoldMessenger
                  .showSnackBar(const SnackBar(content: Text("Renoteしました。")));
              navigator.pop();
            },
            title: const Text("引用Renote")),
        const ListTile(title: Text("チャンネルへRenote")),
        const ListTile(title: Text("チャンネルへ引用Renote")),
      ],
    );
  }
}
