import "package:auto_route/auto_route.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/drive_page/drive_files_notifier.dart";
import "package:miria/state_notifier/drive_page/drive_folders_notifier.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class DriveCreateModalSheet extends ConsumerWidget {
  const DriveCreateModalSheet({required this.folder, super.key});

  final DriveFolder? folder;

  Future<void> _upload(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      compressionQuality: 0,
    );
    if (result == null || result.files.isEmpty) return;
    final fileSystem = ref.read(fileSystemProvider);
    await ref
        .read(dialogStateNotifierProvider.notifier)
        .guard(
          () => Future.wait(
            result.files.map((file) async {
              final path = file.path;
              if (path != null) {
                await ref
                    .read(driveFilesNotifierProvider(folder?.id).notifier)
                    .upload(fileSystem.file(path));
              }
            }),
          ),
        );
    if (!ref.context.mounted) return;
    Navigator.of(ref.context).pop();
  }

  Future<void> _createFolder(WidgetRef ref) async {
    final name = await ref.context.pushRoute<String>(
      TextFormFieldRoute(
        title: Text(S.of(ref.context).createFolder),
        labelText: S.of(ref.context).folderName,
      ),
    );
    if (name != null) {
      await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(driveFoldersNotifierProvider(folder?.id).notifier)
                .create(name),
          );
      if (!ref.context.mounted) return;
      Navigator.of(ref.context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: const Icon(Icons.upload),
          title: Text(S.of(context).uploadFile),
          onTap: () async => await _upload(ref),
        ),
        ListTile(
          leading: const Icon(Icons.folder),
          title: Text(S.of(context).createFolder),
          onTap: () async => await _createFolder(ref),
        ),
      ],
    );
  }
}
