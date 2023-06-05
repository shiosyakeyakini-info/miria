import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/abuse_dialog.dart';
import 'package:miria/view/common/misskey_notes/clip_modal_sheet.dart';
import 'package:miria/view/common/not_implements_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';

class NoteModalSheet extends ConsumerWidget {
  final Note note;
  final Account account;
  final GlobalKey noteBoundaryKey;

  const NoteModalSheet({
    super.key,
    required this.note,
    required this.account,
    required this.noteBoundaryKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref
          .read(misskeyProvider(account))
          .notes
          .state(NotesStateRequest(noteId: note.id)),
      builder: (context2, snapshot) {
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
                    text: "https://${account.host}/notes/${note.id}"));
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
              onTap: () async {
                final box = context2.findRenderObject() as RenderBox?;
                final boundary = noteBoundaryKey.currentContext
                    ?.findRenderObject() as RenderRepaintBoundary;
                final image = await boundary.toImage();
                final byteData =
                    await image.toByteData(format: ImageByteFormat.png);

                final path =
                    "${(await getApplicationDocumentsDirectory()).path}${separator}share.png";
                final file = File(path);
                await file.writeAsBytes(byteData!.buffer.asUint8List(
                    byteData.offsetInBytes, byteData.lengthInBytes));

                final xFile = XFile(path, mimeType: "image/png");
                await Share.shareXFiles([xFile],
                    text: "https://${account.host}/notes/${note.id}",
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              },
            ),
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
                Navigator.of(context).pop();

                showModalBottomSheet(
                  context: context,
                  builder: (context2) =>
                      ClipModalSheet(account: account, noteId: note.id),
                );
              },
            ), //TODO: 未実装
            if (note.user.host == null &&
                note.user.username == account.userId) ...[
              ListTile(
                  title: const Text("削除する"),
                  onTap: () async {
                    if (await showDialog(
                            context: context,
                            builder: (context) => const SimpleConfirmDialog(
                                message: "ほんまに消してええな？",
                                primary: "消す！",
                                secondary: "消さへん")) ==
                        true) {
                      await ref
                          .read(misskeyProvider(account))
                          .notes
                          .delete(NotesDeleteRequest(noteId: note.id));
                      ref.read(notesProvider(account)).delete(note.id);
                      Navigator.of(context).pop();
                    }
                  }),
              ListTile(
                  title: const Text("削除してなおす"),
                  onTap: () async {
                    if (await showDialog(
                            context: context,
                            builder: (context) => const SimpleConfirmDialog(
                                message:
                                    "このノート消してなおす？ついたリアクション、Renote、返信は消えて戻らへんで？",
                                primary: "消す！",
                                secondary: "消さへん")) ==
                        true) {
                      await ref
                          .read(misskeyProvider(account))
                          .notes
                          .delete(NotesDeleteRequest(noteId: note.id));
                      ref.read(notesProvider(account)).delete(note.id);
                      Navigator.of(context).pop();
                      context.pushRoute(NoteCreateRoute(
                        initialAccount: account,
                        deletedNote: note,
                      ));
                    }
                  }),
            ],

            if (note.user.host != null ||
                (note.user.host == null &&
                    note.user.username != account.userId))
              ListTile(
                title: const Text("通報する"),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => AbuseDialog(
                            account: account,
                            targetUser: note.user,
                            defaultText:
                                "Note:\nhttps://${account.host}/notes/${note.id}\n-----",
                          ));
                },
              )
          ],
        );
      },
    );
  }
}
