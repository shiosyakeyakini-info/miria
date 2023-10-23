import "package:auto_route/auto_route.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/common/download_file_notifier.dart";
import "package:miria/state_notifier/drive_page/drive_files_notifier.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:miria/view/note_create_page/file_settings_dialog.dart";
import "package:miria/view/note_create_page/thumbnail.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:url_launcher/url_launcher.dart";

@RoutePage()
class DriveFileModalSheet extends ConsumerWidget {
  const DriveFileModalSheet({required this.file, super.key});

  final DriveFile file;

  Future<void> _editFile(WidgetRef ref) async {
    final result = await showDialog<FileSettingsDialogResult>(
      context: ref.context,
      builder: (context) => FileSettingsDialog(
        file: UnknownAlreadyPostedFile(
          url: file.url,
          id: file.id,
          fileName: file.name,
          isNsfw: file.isSensitive,
          caption: file.comment,
        ),
      ),
    );
    if (result == null ||
        (result.fileName == file.name &&
            result.isNsfw == file.isSensitive &&
            result.caption == file.comment)) {
      return;
    }
    await ref
        .read(dialogStateNotifierProvider.notifier)
        .guard(
          () => ref
              .read(driveFilesNotifierProvider(file.folderId).notifier)
              .updateFile(
                fileId: file.id,
                name: result.fileName,
                isSensitive: result.isNsfw,
                comment: result.caption,
              ),
        );
    if (!ref.context.mounted) return;
    await ref.context.maybePop();
  }

  Future<void> _editImage(WidgetRef ref) async {
    final response = await ref
        .read(dioProvider)
        .get<Uint8List>(
          file.url,
          options: Options(responseType: ResponseType.bytes),
        );
    final initialImage = response.data;
    if (initialImage == null) return;
    if (!ref.context.mounted) return;
    await ref.context.pushRoute(
      PhotoEditRoute(
        accountContext: ref.read(accountContextProvider),
        file: ImageFileAlreadyPostedFile(
          data: initialImage,
          id: file.id,
          fileName: file.name,
        ),
        onSubmit: (image) => ref
            .read(dialogStateNotifierProvider.notifier)
            .guard(
              () => ref
                  .read(driveFilesNotifierProvider(file.folderId).notifier)
                  .uploadBinary(
                    image,
                    name: file.name,
                    comment: file.comment,
                    isSensitive: file.isSensitive,
                  ),
            ),
      ),
    );
    if (!ref.context.mounted) return;
    await ref.context.maybePop();
  }

  Future<void> _download(WidgetRef ref) async {
    if (defaultTargetPlatform
        case TargetPlatform.android || TargetPlatform.iOS) {
      final result = await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(downloadFileNotifierProvider.notifier)
                .downloadFile(file),
          );
      if (!ref.context.mounted) return;
      if (result.value case DownloadFileResult.succeeded) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text(S.of(ref.context).fileDownloaded),
            duration: const Duration(seconds: 1),
          ),
        );
        await ref.context.maybePop();
      } else {
        await ref
            .read(dialogStateNotifierProvider.notifier)
            .showSimpleDialog(
              message: (context) =>
                  "${S.of(context).failedFileSave}\n[$result]",
            );
      }
    } else {
      await launchUrl(
        Uri.parse(file.url),
        mode: LaunchMode.externalApplication,
      );
    }
    if (!ref.context.mounted) return;
    await ref.context.maybePop();
  }

  Future<void> _move(WidgetRef ref) async {
    final result = await ref.context.pushRoute(
      DriveShellRoute(
        accountContext: ref.read(accountContextProvider),
        children: [DriveRoute(selectFolder: true)],
      ),
    );
    if (result case (final DriveFolder? folder,)) {
      if (folder?.id == file.folderId) return;
      final result = await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(driveFilesNotifierProvider(file.folderId).notifier)
                .move(fileId: file.id, folderId: folder?.id),
          );
      if (result.hasError) return;
      if (!ref.context.mounted) return;
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(
          content: Text(S.of(ref.context).moved),
          duration: const Duration(seconds: 1),
        ),
      );
      await ref.context.maybePop();
    }
  }

  Future<void> _delete(WidgetRef ref) async {
    final result = await SimpleConfirmDialog.show(
      context: ref.context,
      message: S.of(ref.context).confirmDeleteFile,
      primary: S.of(ref.context).willDelete,
      secondary: S.of(ref.context).cancel,
    );
    if (result ?? false) {
      final result = await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(driveFilesNotifierProvider(file.folderId).notifier)
                .delete(file.id),
          );
      if (result.hasError) return;
      if (!ref.context.mounted) return;
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(
          content: Text(S.of(ref.context).deleted),
          duration: const Duration(seconds: 1),
        ),
      );
      await ref.context.maybePop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: AspectRatio(
            aspectRatio: 1,
            child: Thumbnail.driveFile(file),
          ),
          title: Text(file.name),
          subtitle: Text(file.createdAt.formatUntilSeconds(context)),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(S.of(context).editFile),
          onTap: () async => await _editFile(ref),
        ),
        if (defaultTargetPlatform
            case TargetPlatform.android ||
                TargetPlatform.iOS ||
                TargetPlatform.macOS when file.type.startsWith("image/"))
          ListTile(
            leading: const Icon(Icons.crop),
            title: Text(S.of(context).editImage),
            onTap: () async => await _editImage(ref),
          ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: Text(S.of(context).createNoteFromThisFile),
          onTap: () async => await context.pushRoute(
            NoteCreateRoute(
              initialAccount: ref.read(accountContextProvider).postAccount,
              initialDriveFiles: [file],
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(S.of(context).copyLinks),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: file.url));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).doneCopy),
                duration: const Duration(seconds: 1),
              ),
            );
            await ref.context.maybePop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: Text(S.of(context).download),
          onTap: () async => await _download(ref),
        ),
        ListTile(
          leading: const Icon(Icons.drive_file_move),
          title: Text(S.of(context).move),
          onTap: () async => await _move(ref),
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: Text(S.of(context).delete),
          onTap: () async => await _delete(ref),
          iconColor: Theme.of(context).colorScheme.error,
          textColor: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }
}
