import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/drive_page/drive_folder_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveSelectedFilesModalSheet extends ConsumerWidget {
  const DriveSelectedFilesModalSheet({
    super.key,
    required this.account,
    required this.files,
  });

  final Account account;
  final List<DriveFile> files;

  Future<void> download(WidgetRef ref) async {
    final context = ref.context;
    await Future.wait(
      files.map(
        (file) =>
            ref.read(downloadFileNotifierProvider.notifier).downloadFile(file),
      ),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).fileDownloaded)),
    );
    Navigator.of(context).pop();
  }

  Future<void> move(WidgetRef ref) async {
    final context = ref.context;
    final misskey = ref.read(misskeyProvider(account));
    final result = await showDialog<(DriveFolder?,)>(
      context: context,
      builder: (context) => DriveFolderSelectDialog(account: account),
    );
    if (result == null) return;
    await Future.wait(
      files.map(
        (file) => ref
            .read(driveFilesNotifierProvider((misskey, file.folderId)).notifier)
            .move(
              fileId: file.id,
              folderId: result.$1?.id,
            ),
      ),
    );
    ref.read(drivePageNotifierProvider.notifier).deselectAll();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).moved)),
    );
    Navigator.of(context).pop();
  }

  Future<void> delete(WidgetRef ref) async {
    final context = ref.context;
    final misskey = ref.read(misskeyProvider(account));
    final result = await SimpleConfirmDialog.show(
      context: context,
      message: S.of(context).confirmDeleteFiles(files.length),
      primary: S.of(context).willDelete,
      secondary: S.of(context).cancel,
    );
    if (result ?? false) {
      await Future.wait(
        files.map(
          (file) => ref
              .read(
                driveFilesNotifierProvider((misskey, file.folderId)).notifier,
              )
              .delete(file.id),
        ),
      );
      ref.read(drivePageNotifierProvider.notifier).deselectAll();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).deleted)),
      );
      Navigator.of(context).pop();
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
            onTap: () => download(ref).expectFailure(context),
          ),
        ListTile(
          leading: const Icon(Icons.drive_file_move),
          title: Text(S.of(context).move),
          onTap: () => move(ref).expectFailure(context),
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: Text(S.of(context).delete),
          onTap: () => delete(ref).expectFailure(context),
        ),
      ],
    );
  }
}
