import "dart:io";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/common/download_file_notifier.dart";
import "package:miria/state_notifier/drive_page/drive_files_notifier.dart";
import "package:miria/state_notifier/drive_page/selected_drive_files_notifier_provider.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class DriveFilesModalSheet extends ConsumerWidget {
  const DriveFilesModalSheet({required this.files, super.key});

  final List<DriveFile> files;

  Future<void> _download(WidgetRef ref) async {
    await ref
        .read(dialogStateNotifierProvider.notifier)
        .guard(
          () => Future.wait(
            files.map(
              (file) => ref
                  .read(downloadFileNotifierProvider.notifier)
                  .downloadFile(file),
            ),
          ),
        );
    if (!ref.context.mounted) return;
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(
        content: Text(S.of(ref.context).fileDownloaded),
        duration: const Duration(seconds: 1),
      ),
    );
    await ref.context.maybePop();
  }

  Future<void> _move(WidgetRef ref) async {
    final result = await ref.context.pushRoute(
      DriveShellRoute(
        accountContext: ref.read(accountContextProvider),
        children: [DriveRoute(selectFolder: true)],
      ),
    );
    if (result case (final DriveFolder? parent,)) {
      final result = await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => Future.wait(
              files.map(
                (file) => ref
                    .read(driveFilesNotifierProvider(file.folderId).notifier)
                    .move(fileId: file.id, folderId: parent?.id),
              ),
            ),
          );
      if (result.hasError) return;
      if (!ref.context.mounted) return;
      ref.read(selectedDriveFilesNotifierProvider.notifier).removeAll();
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
      message: S.of(ref.context).confirmDeleteFiles(files.length),
      primary: S.of(ref.context).willDelete,
      secondary: S.of(ref.context).cancel,
    );
    if (result ?? false) {
      final result = await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => Future.wait(
              files.map(
                (file) => ref
                    .read(driveFilesNotifierProvider(file.folderId).notifier)
                    .delete(file.id),
              ),
            ),
          );
      if (result.hasError) return;
      if (!ref.context.mounted) return;
      ref.read(selectedDriveFilesNotifierProvider.notifier).removeAll();
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
        ListTile(title: Text(S.of(context).nFiles(files.length))),
        if (Platform.isAndroid || Platform.isIOS)
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
