import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
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
        const ListTile(title: Text("引用Renote")),
        const ListTile(title: Text("チャンネルへRenote")),
        const ListTile(title: Text("チャンネルへ引用Renote")),
      ],
    );
  }
}
