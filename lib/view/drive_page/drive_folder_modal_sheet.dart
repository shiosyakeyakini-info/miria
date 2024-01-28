import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/text_form_field_dialog.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/drive_page/drive_folder_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveFolderModalSheet extends ConsumerWidget {
  const DriveFolderModalSheet({
    super.key,
    required this.account,
    required this.folder,
  });

  final Account account;
  final DriveFolder folder;

  Future<void> changeName(WidgetRef ref) async {
    final context = ref.context;
    final misskey = ref.read(misskeyProvider(account));
    final name = await showDialog<String>(
      context: context,
      builder: (context) => TextFormFieldDialog(
        title: Text(S.of(context).changeFolderName),
        labelText: S.of(context).folderName,
        initialValue: folder.name,
      ),
    );
    if (name != null && name != folder.name) {
      await ref
          .read(
            driveFoldersNotifierProvider((misskey, folder.parentId)).notifier,
          )
          .updateName(folder.id, name);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> move(WidgetRef ref) async {
    final context = ref.context;
    final misskey = ref.read(misskeyProvider(account));
    final result = await showDialog<(DriveFolder?,)>(
      context: context,
      builder: (context) => DriveFolderSelectDialog(account: account),
    );
    if (result == null) return;
    await ref
        .read(driveFoldersNotifierProvider((misskey, folder.parentId)).notifier)
        .move(
          folderId: folder.id,
          parentId: result.$1?.id,
        );
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
      message: S.of(context).confirmDeleteFolder,
      primary: S.of(context).willDelete,
      secondary: S.of(context).cancel,
    );
    if (result ?? false) {
      await ref
          .read(
            driveFoldersNotifierProvider((misskey, folder.parentId)).notifier,
          )
          .delete(folder.id);
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
        ListTile(
          leading: const Icon(
            Icons.folder,
            size: 50,
          ),
          title: Text(folder.name),
          subtitle: Text(folder.createdAt.formatUntilSeconds(context)),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(S.of(context).changeFolderName),
          onTap: () => changeName(ref).expectFailure(context),
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
