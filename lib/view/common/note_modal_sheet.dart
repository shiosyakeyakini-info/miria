import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteModalSheet extends ConsumerWidget {
  final Note note;

  const NoteModalSheet({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(title: Text("詳細")),
        ListTile(
          title: const Text("内容をコピー"),
          onTap: () {
            Clipboard.setData(ClipboardData(text: note.text ?? ""));
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: const Text("リンクをコピー"),
          onTap: () {
            //FIXME: 固定のドメインをなおす
            Clipboard.setData(
                ClipboardData(text: "https://misskey.io/notes/${note.id}"));
            Navigator.of(context).pop();
          },
        ),
        ListTile(
            title: const Text("ユーザー名をコピー"),
            onTap: () {
              Clipboard.setData(
                  ClipboardData(text: note.user.name ?? note.user.username));
              Navigator.of(context).pop();
            }),
        ListTile(
          title: const Text("ユーザースクリーン名をコピー"),
          onTap: () {
            Clipboard.setData(ClipboardData(
                text:
                    "@${note.user.username}${note.user.host != null ? "@${note.user.host}" : ""}"));
            Navigator.of(context).pop();
          },
        ),
        ListTile(title: const Text("ノートを共有")), //TODO: 未実装
        ListTile(title: Text("お気に入り")), //TODO: 未実装
        ListTile(title: Text("クリップ")), //TODO: 未実装
      ],
    );
  }
}
