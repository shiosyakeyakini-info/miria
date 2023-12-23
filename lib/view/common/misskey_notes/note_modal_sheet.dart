import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/abuse_dialog.dart';
import 'package:miria/view/common/misskey_notes/clip_modal_sheet.dart';
import 'package:miria/view/common/misskey_notes/translate_note_modal_sheet.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/note_create_page/note_create_page.dart';
import 'package:miria/view/user_page/user_control_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final noteModalSheetSharingModeProviding = StateProvider((ref) => false);

class NoteModalSheet extends ConsumerWidget {
  final Note baseNote;
  final Note targetNote;
  final Account account;
  final GlobalKey noteBoundaryKey;

  const NoteModalSheet({
    super.key,
    required this.baseNote,
    required this.targetNote,
    required this.account,
    required this.noteBoundaryKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountRepositoryProvider);
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(S.of(context).detail),
          onTap: () {
            context
                .pushRoute(NoteDetailRoute(note: targetNote, account: account));
          },
        ),
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(S.of(context).copyContents),
          onTap: () {
            Clipboard.setData(ClipboardData(text: targetNote.text ?? ""));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).doneCopy), duration: const Duration(seconds: 1)),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(S.of(context).copyLinks),
          onTap: () {
            Clipboard.setData(
              ClipboardData(
                text: "https://${account.host}/notes/${targetNote.id}",
              ),
            );
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).doneCopy), duration: const Duration(seconds: 1)),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(S.of(context).user),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            final response = await ref
                .read(misskeyProvider(account))
                .users
                .show(UsersShowRequest(userId: targetNote.userId));
            if (!context.mounted) return;
            showModalBottomSheet<void>(
              context: context,
              builder: (context) => UserControlDialog(
                account: account,
                response: response,
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: Text(S.of(context).openBrowsers),
          onTap: () async {
            launchUrlString(
              "https://${account.host}/notes/${targetNote.id}",
              mode: LaunchMode.inAppWebView,
            );

            Navigator.of(context).pop();
          },
        ),
        if (targetNote.user.host != null)
          ListTile(
            leading: const Icon(Icons.rocket_launch),
            title: Text(S.of(context).openBrowsersAsRemote),
            onTap: () async {
              final uri = targetNote.url ?? targetNote.uri;
              if (uri == null) return;
              launchUrl(uri, mode: LaunchMode.inAppWebView);

              Navigator.of(context).pop();
            },
          ),
        // ノートが連合なしのときは現在のアカウントと同じサーバーのアカウントが複数ある場合のみ表示する
        if (!targetNote.localOnly ||
            accounts.where((e) => e.host == account.host).length > 1)
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: Text(S.of(context).openInAnotherAccount),
            onTap: () => ref
                .read(misskeyNoteNotifierProvider(account).notifier)
                .openNoteInOtherAccount(context, targetNote)
                .expectFailure(context),
          ),
        ListTile(
          leading: const Icon(Icons.share),
          title: Text(S.of(context).shareNotes),
          onTap: () {
            ref.read(noteModalSheetSharingModeProviding.notifier).state = true;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Future(() async {
                final box = context.findRenderObject() as RenderBox?;
                final boundary = noteBoundaryKey.currentContext
                    ?.findRenderObject() as RenderRepaintBoundary;
                final image = await boundary.toImage(
                  pixelRatio: View.of(context).devicePixelRatio,
                );
                final byteData =
                    await image.toByteData(format: ImageByteFormat.png);
                ref.read(noteModalSheetSharingModeProviding.notifier).state =
                    false;

                final path =
                    "${(await getApplicationDocumentsDirectory()).path}${separator}share.png";
                final file = File(path);
                await file.writeAsBytes(
                  byteData!.buffer.asUint8List(
                    byteData.offsetInBytes,
                    byteData.lengthInBytes,
                  ),
                );

                final xFile = XFile(path, mimeType: "image/png");
                await Share.shareXFiles(
                  [xFile],
                  text: "https://${account.host}/notes/${targetNote.id}",
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
              });
            });
          },
        ),
        if (account.i.policies.canUseTranslator &&
            (account.meta?.translatorAvailable ?? false))
          ListTile(
            leading: const Icon(Icons.translate),
            title: const Text("ノートを翻訳"),
            onTap: () {
              Navigator.of(context).pop();
              showModalBottomSheet<void>(
                context: context,
                builder: (context) => TranslateNoteModalSheet(
                  account: account,
                  note: targetNote,
                ),
              );
            },
          ),
        FutureBuilder(
          future: ref
              .read(misskeyProvider(account))
              .notes
              .state(NotesStateRequest(noteId: targetNote.id)),
          builder: (_, snapshot) {
            final data = snapshot.data;
            return (data == null)
                ? const Center(child: CircularProgressIndicator())
                : ListTile(
                    leading: const Icon(Icons.star_rounded),
                    onTap: () async {
                      if (data.isFavorited) {
                        ref
                            .read(misskeyProvider(account))
                            .notes
                            .favorites
                            .delete(
                              NotesFavoritesDeleteRequest(
                                noteId: targetNote.id,
                              ),
                            );

                        Navigator.of(context).pop();
                      } else {
                        ref
                            .read(misskeyProvider(account))
                            .notes
                            .favorites
                            .create(
                              NotesFavoritesCreateRequest(
                                noteId: targetNote.id,
                              ),
                            );
                        Navigator.of(context).pop();
                      }
                    },
                    title: Text(data.isFavorited
                        ? S.of(context).deleteFavorite
                        : S.of(context).favorite),
                  );
          },
        ),
        ListTile(
          leading: const Icon(Icons.attach_file),
          title: Text(S.of(context).clip),
          onTap: () {
            Navigator.of(context).pop();

            showModalBottomSheet(
              context: context,
              builder: (context2) =>
                  ClipModalSheet(account: account, noteId: targetNote.id),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.repeat_rounded),
          title: Text(S.of(context).notesAfterRenote),
          onTap: () {
            context.pushRoute(
              NotesAfterRenoteRoute(
                note: targetNote,
                account: account,
              ),
            );
          },
        ),
        if (baseNote.user.host == null &&
            baseNote.user.username == account.userId &&
            !(baseNote.text == null &&
                baseNote.renote != null &&
                baseNote.poll == null &&
                baseNote.files.isEmpty)) ...[
          if (account.i.policies.canEditNote)
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(S.of(context).edit),
              onTap: () async {
                Navigator.of(context).pop();
                context.pushRoute(
                  NoteCreateRoute(
                    initialAccount: account,
                    note: targetNote,
                    noteCreationMode: NoteCreationMode.update,
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(S.of(context).delete),
            onTap: () async {
              if (await showDialog(
                    context: context,
                    builder: (context) => SimpleConfirmDialog(
                      message: S.of(context).confirmDelete,
                      primary: S.of(context).doDeleting,
                      secondary: S.of(context).cancel,
                    ),
                  ) ==
                  true) {
                await ref
                    .read(misskeyProvider(account))
                    .notes
                    .delete(NotesDeleteRequest(noteId: baseNote.id));
                ref.read(notesProvider(account)).delete(baseNote.id);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(S.of(context).deletedRecreate),
            onTap: () async {
              if (await showDialog(
                    context: context,
                    builder: (context) => SimpleConfirmDialog(
                      message: S.of(context).confirmDeletedRecreate,
                      primary: S.of(context).doDeleting,
                      secondary: S.of(context).cancel,
                    ),
                  ) ==
                  true) {
                await ref
                    .read(misskeyProvider(account))
                    .notes
                    .delete(NotesDeleteRequest(noteId: targetNote.id));
                ref.read(notesProvider(account)).delete(targetNote.id);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                context.pushRoute(
                  NoteCreateRoute(
                    initialAccount: account,
                    note: targetNote,
                    noteCreationMode: NoteCreationMode.recreate,
                  ),
                );
              }
            },
          ),
        ],
        if (baseNote.user.host == null &&
            baseNote.user.username == account.userId &&
            baseNote.renote != null &&
            baseNote.files.isEmpty &&
            baseNote.poll == null) ...[
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(S.of(context).deleteRenote),
            onTap: () async {
              await ref
                  .read(misskeyProvider(account))
                  .notes
                  // unrenote ではないらしい
                  .delete(NotesDeleteRequest(noteId: baseNote.id));
              ref.read(notesProvider(account)).delete(baseNote.id);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
        ],
        if (baseNote.user.host != null ||
            (baseNote.user.host == null &&
                baseNote.user.username != account.userId))
          ListTile(
            leading: const Icon(Icons.report),
            title: Text(S.of(context).reportAbuse),
            onTap: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => AbuseDialog(
                  account: account,
                  targetUser: targetNote.user,
                  defaultText:
                      "Note:\nhttps://${account.host}/notes/${targetNote.id}\n-----",
                ),
              );
            },
          ),
      ],
    );
  }
}
