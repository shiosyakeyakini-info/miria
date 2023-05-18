import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/not_implements_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NoteModalSheet extends ConsumerWidget {
  final Note note;
  final Account account;

  const NoteModalSheet({
    super.key,
    required this.note,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref
          .read(misskeyProvider(account))
          .notes
          .state(NotesStateRequest(noteId: note.id)),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: [
            ListTile(
              title: Text("詳細"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => NotImplementationDialog());
              },
            ),
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
                Clipboard.setData(ClipboardData(
                    text:
                        "https://${AccountScope.of(context).host}/notes/${note.id}"));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
                title: const Text("ユーザー名をコピー"),
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: note.user.name ?? note.user.username));
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
            ListTile(
                title: const Text("ブラウザで開く"),
                onTap: () async {
                  launchUrlString("https://${account.host}/notes/${note.id}",
                      mode: LaunchMode.inAppWebView);

                  Navigator.of(context).pop();
                }),
            ListTile(
              title: const Text("ノートを共有"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => NotImplementationDialog());
              },
            ), //TODO: 未実装
            ListTile(
                onTap: () async {
                  if (data.isFavorited) {
                    ref
                        .read(misskeyProvider(account))
                        .notes
                        .favorites
                        .delete(NotesFavoritesDeleteRequest(noteId: note.id));

                    Navigator.of(context).pop();
                  } else {
                    ref
                        .read(misskeyProvider(account))
                        .notes
                        .favorites
                        .create(NotesFavoritesCreateRequest(noteId: note.id));
                    Navigator.of(context).pop();
                  }
                },
                title:
                    Text(data.isFavorited ? "お気に入り解除" : "お気に入り")), //TODO: 未実装
            ListTile(
              title: const Text("クリップ"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => NotImplementationDialog());
              },
            ), //TODO: 未実装
          ],
        );
      },
    );
  }
}
