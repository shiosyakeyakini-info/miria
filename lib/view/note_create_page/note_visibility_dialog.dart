import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteVisibilityDialog extends ConsumerWidget {
  final Account account;

  const NoteVisibilityDialog({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            if (ref
                .read(noteCreateProvider(account).notifier)
                .validateNoteVisibility(NoteVisibility.public, context)) {
              Navigator.of(context).pop(NoteVisibility.public);
            }
          },
          leading: const Icon(Icons.public),
          title: const Text("パブリック"),
          subtitle: const Text("みんなに公開"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.home);
          },
          leading: const Icon(Icons.home),
          title: const Text("ホーム"),
          subtitle: const Text("ホームタイムラインのみに公開"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.followers);
          },
          leading: const Icon(Icons.lock_outline),
          title: const Text("フォロワー"),
          subtitle: const Text("自分のフォロワーのみに公開"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.specified);
          },
          leading: const Icon(Icons.mail),
          title: const Text("ダイレクト"),
          subtitle: const Text("選択したユーザーのみに公開"),
        ),
      ],
    );
  }
}
