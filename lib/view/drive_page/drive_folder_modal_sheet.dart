import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/drive_page/drive_folders_notifier.dart";
import "package:miria/state_notifier/drive_page/selected_drive_files_notifier_provider.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class DriveFolderModalSheet extends ConsumerWidget {
  const DriveFolderModalSheet({required this.folder, super.key});

  final DriveFolder folder;

  Future<void> _changeName(WidgetRef ref) async {
    final name = await ref.context.pushRoute<String>(
      TextFormFieldRoute(
        title: Text(S.of(ref.context).changeFolderName),
        labelText: S.of(ref.context).folderName,
        initialValue: folder.name,
      ),
    );
    if (!ref.context.mounted) return;
    if (name != null && name != folder.name) {
      await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(driveFoldersNotifierProvider(folder.parentId).notifier)
                .updateName(folder.id, name),
          );
      if (!ref.context.mounted) return;
      await ref.context.maybePop();
    }
  }

  Future<void> _move(WidgetRef ref) async {
    final result = await ref.context.pushRoute(
      DriveShellRoute(
        accountContext: ref.read(accountContextProvider),
        children: [DriveRoute(selectFolder: true)],
      ),
    );
    if (result case (final DriveFolder? parent,)) {
      if (parent?.id == folder.parentId) return;
      final result = await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(driveFoldersNotifierProvider(folder.parentId).notifier)
                .move(folderId: folder.id, parentId: parent?.id),
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
      message: S.of(ref.context).confirmDeleteFolder,
      primary: S.of(ref.context).willDelete,
      secondary: S.of(ref.context).cancel,
    );
    if (result ?? false) {
      final result = await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(driveFoldersNotifierProvider(folder.parentId).notifier)
                .delete(folder.id),
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
        ListTile(
          leading: const Icon(Icons.folder, size: 50),
          title: Text(folder.name),
          subtitle: Text(folder.createdAt.formatUntilSeconds(context)),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(S.of(context).changeFolderName),
          onTap: () async => await _changeName(ref),
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
