import "dart:async";
import "dart:io";
import "dart:ui";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/common/misskey_notes/misskey_note_notifier.dart";
import "package:miria/view/clip_modal_sheet/clip_modal_sheet.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/copy_modal_sheet/copy_note_modal_sheet.dart";
import "package:miria/view/note_create_page/note_create_page.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:share_plus/share_plus.dart";
import "package:url_launcher/url_launcher.dart";
import "package:url_launcher/url_launcher_string.dart";

part "note_modal_sheet.freezed.dart";
part "note_modal_sheet.g.dart";

@freezed
class NoteModalSheetState with _$NoteModalSheetState {
  factory NoteModalSheetState({
    required AsyncValue<NotesStateResponse> noteState,
    @Default(false) bool isSharingMode,
    AsyncValue<UserDetailed>? user,
    AsyncValue<void>? delete,
    AsyncValue<void>? deleteRecreate,
    AsyncValue<void>? favorite,
  }) = _NoteModalSheetState;

  const NoteModalSheetState._();

  bool get isLoading =>
      noteState is AsyncLoading ||
      user is AsyncLoading ||
      delete is AsyncLoading ||
      deleteRecreate is AsyncLoading ||
      favorite is AsyncLoading;
}

@Riverpod(
  keepAlive: false,
  dependencies: [
    misskeyPostContext,
    misskeyGetContext,
    accountContext,
    notesWith,
  ],
)
class NoteModalSheetNotifier extends _$NoteModalSheetNotifier {
  @override
  NoteModalSheetState build(Note note) {
    state = NoteModalSheetState(noteState: const AsyncLoading());
    if (ref.read(accountContextProvider).isSame) unawaited(_status());
    return state;
  }

  Future<void> _status() async {
    state = state.copyWith(
      noteState: await ref.read(dialogStateNotifierProvider.notifier).guard(
            () async => ref
                .read(misskeyPostContextProvider)
                .notes
                .state(NotesStateRequest(noteId: note.id)),
          ),
    );
  }

  Future<void> user() async {
    state = state.copyWith(user: const AsyncLoading());
    state = state.copyWith(
      user: await ref.read(dialogStateNotifierProvider.notifier).guard(
            () async => await ref.read(misskeyGetContextProvider).users.show(
                  UsersShowRequest(userId: note.userId),
                ),
          ),
    );
  }

  Future<void> favorite() async {
    final isFavorited = state.noteState.valueOrNull?.isFavorited;
    if (isFavorited == null) return;
    state = state.copyWith(favorite: const AsyncLoading());
    state = state.copyWith(
      favorite:
          await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        if (isFavorited) {
          await ref.read(misskeyPostContextProvider).notes.favorites.delete(
                NotesFavoritesDeleteRequest(noteId: note.id),
              );
        } else {
          await ref.read(misskeyPostContextProvider).notes.favorites.create(
                NotesFavoritesCreateRequest(noteId: note.id),
              );
        }
      }),
    );
  }

  Future<void> copyAsImage(
    RenderBox box,
    RenderRepaintBoundary boundary,
    double devicePixelRatio,
  ) async {
    final image = await boundary.toImage(pixelRatio: devicePixelRatio);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    state = state.copyWith(isSharingMode: false);
    final host = ref.read(accountContextProvider).postAccount.host;

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
      text: "https://$host/notes/${note.id}",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future<void> unRenote() async {
    state = state.copyWith(delete: const AsyncLoading());
    state = state.copyWith(
      delete: await ref.read(dialogStateNotifierProvider.notifier).guard(
            () async => await ref
                .read(misskeyPostContextProvider)
                .notes
                .delete(NotesDeleteRequest(noteId: note.id)),
          ),
    );
  }

  Future<void> delete() async {
    final confirm =
        await ref.read(dialogStateNotifierProvider.notifier).showDialog(
              message: (context) => S.of(context).confirmDelete,
              actions: (context) => [
                S.of(context).doDeleting,
                S.of(context).cancel,
              ],
            );
    if (confirm != 0) return;
    state = state.copyWith(delete: const AsyncLoading());
    state = state.copyWith(
      delete: await ref.read(dialogStateNotifierProvider.notifier).guard(
        () async {
          await ref
              .read(misskeyPostContextProvider)
              .notes
              .delete(NotesDeleteRequest(noteId: note.id));
          ref.read(notesWithProvider).delete(note.id);
        },
      ),
    );
  }

  Future<void> deleteRecreate() async {
    final confirm =
        await ref.read(dialogStateNotifierProvider.notifier).showDialog(
              message: (context) => S.of(context).confirmDeletedRecreate,
              actions: (context) => [
                S.of(context).doDeleting,
                S.of(context).cancel,
              ],
            );
    if (confirm != 0) return;
    state = state.copyWith(deleteRecreate: const AsyncLoading());
    state = state.copyWith(
      deleteRecreate:
          await ref.read(dialogStateNotifierProvider.notifier).guard(
        () async {
          await ref
              .read(misskeyPostContextProvider)
              .notes
              .delete(NotesDeleteRequest(noteId: note.id));
          ref.read(notesWithProvider).delete(note.id);
        },
      ),
    );
  }
}

@RoutePage()
class NoteModalSheet extends ConsumerWidget implements AutoRouteWrapper {
  final Note baseNote;
  final Note targetNote;
  final AccountContext accountContext;
  final GlobalKey noteBoundaryKey;

  const NoteModalSheet({
    required this.baseNote,
    required this.targetNote,
    required this.accountContext,
    required this.noteBoundaryKey,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountRepositoryProvider);
    final notifierProvider = noteModalSheetNotifierProvider(targetNote);

    ref.listen(notifierProvider.select((value) => value.user), (_, next) async {
      switch (next) {
        case AsyncData<UserDetailed>(:final value):
          await context.pushRoute(
            UserControlRoute(
              account: accountContext.postAccount,
              response: value,
            ),
          );
        case null:
        case AsyncLoading<UserDetailed>():
        case AsyncError<UserDetailed>():
      }
    });
    final noteStatus =
        ref.watch(notifierProvider.select((value) => value.noteState));

    if (ref.read(notifierProvider).isLoading) {
      return const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(S.of(context).detail),
          onTap: () async => context.pushRoute(
            NoteDetailRoute(
              note: targetNote,
              accountContext: accountContext,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(S.of(context).copyContents),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: targetNote.text ?? ""));
            if (!context.mounted) return;
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).doneCopy),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          trailing: IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await showModalBottomSheet(
                context: context,
                builder: (context) => CopyNoteModalSheet(
                  note: targetNote.text ?? "",
                ),
              );
            },
            icon: const Icon(Icons.edit_note),
            tooltip: S.of(context).detail,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(S.of(context).copyLinks),
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(
                text:
                    "https://${accountContext.getAccount.host}/notes/${targetNote.id}",
              ),
            );
            if (!context.mounted) return;
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).doneCopy),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(S.of(context).user),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async => ref.read(notifierProvider.notifier).user(),
        ),
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: Text(S.of(context).openBrowsers),
          onTap: () async {
            await launchUrlString(
              "https://${accountContext.getAccount.host}/notes/${targetNote.id}",
              mode: LaunchMode.externalApplication,
            );

            if (!context.mounted) return;
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
              launchUrl(uri, mode: LaunchMode.externalApplication);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
        // ノートが連合なしのときは現在のアカウントと同じサーバーのアカウントが複数ある場合のみ表示する
        if (!targetNote.localOnly ||
            accounts
                    .where((e) => e.host == accountContext.postAccount.host)
                    .length >
                1)
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: Text(S.of(context).openInAnotherAccount),
            onTap: () async => ref
                .read(misskeyNoteNotifierProvider.notifier)
                .openNoteInOtherAccount(targetNote),
          ),
        ListTile(
          leading: const Icon(Icons.share),
          title: Text(S.of(context).shareNotes),
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Future(() async {
                final box = context.findRenderObject() as RenderBox?;
                if (box == null) return;
                final boundary = noteBoundaryKey.currentContext!
                    .findRenderObject()! as RenderRepaintBoundary;
                await ref.read(notifierProvider.notifier).copyAsImage(
                      box,
                      boundary,
                      View.of(context).devicePixelRatio,
                    );
              });
            });
          },
        ),
        if (accountContext.isSame)
          switch (noteStatus) {
            AsyncLoading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            AsyncError() => Text(S.of(context).thrownError),
            AsyncData(:final value) => ListTile(
                leading: const Icon(Icons.star_rounded),
                onTap: () async {
                  await ref.read(notifierProvider.notifier).favorite();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                title: Text(
                  value.isFavorited
                      ? S.of(context).deleteFavorite
                      : S.of(context).favorite,
                ),
              )
          },
        if (accountContext.isSame)
          ListTile(
            leading: const Icon(Icons.attach_file),
            title: Text(S.of(context).clip),
            onTap: () async {
              Navigator.of(context).pop();

              await showModalBottomSheet(
                context: context,
                builder: (context2) => ClipModalSheet(
                  account: accountContext.postAccount,
                  noteId: targetNote.id,
                ),
              );
            },
          ),
        ListTile(
          leading: const Icon(Icons.repeat_rounded),
          title: Text(S.of(context).notesAfterRenote),
          onTap: () async => context.pushRoute(
            NotesAfterRenoteRoute(
              note: targetNote,
              accountContext: accountContext,
            ),
          ),
        ),
        if (accountContext.isSame &&
            baseNote.user.host == null &&
            baseNote.user.username == accountContext.postAccount.userId &&
            !(baseNote.text == null &&
                baseNote.renote != null &&
                baseNote.poll == null &&
                baseNote.files.isEmpty)) ...[
          if (accountContext.postAccount.i.policies.canEditNote)
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(S.of(context).edit),
              onTap: () async {
                Navigator.of(context).pop();
                await context.pushRoute(
                  NoteCreateRoute(
                    initialAccount: accountContext.postAccount,
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
                await ref.read(notifierProvider.notifier).delete();
                if (!context.mounted) return;
                Navigator.of(context).pop();
              }),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(S.of(context).deletedRecreate),
            onTap: () async {
              await ref.read(notifierProvider.notifier).deleteRecreate();
              if (!context.mounted) return;
              Navigator.of(context).pop();
              await context.pushRoute(
                NoteCreateRoute(
                  initialAccount: accountContext.postAccount,
                  noteCreationMode: NoteCreationMode.recreate,
                  note: targetNote,
                ),
              );
            },
          ),
        ],
        if (accountContext.isSame &&
            baseNote.user.host == null &&
            baseNote.user.username == accountContext.postAccount.userId &&
            baseNote.renote != null &&
            baseNote.files.isEmpty &&
            baseNote.poll == null) ...[
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(S.of(context).deleteRenote),
            onTap: () async => ref.read(notifierProvider.notifier).unRenote(),
          ),
        ],
        if (accountContext.isSame && baseNote.user.host != null ||
            (baseNote.user.host == null &&
                baseNote.user.username != accountContext.postAccount.userId))
          ListTile(
            leading: const Icon(Icons.report),
            title: Text(S.of(context).reportAbuse),
            onTap: () async {
              // Navigator.of(context).pop();
              await context.pushRoute(
                AbuseRoute(
                  account: accountContext.postAccount,
                  targetUser: targetNote.user,
                  defaultText:
                      "Note:\nhttps://${accountContext.postAccount.host}/notes/${targetNote.id}\n-----",
                ),
              );
            },
          ),
      ],
    );
  }
}
