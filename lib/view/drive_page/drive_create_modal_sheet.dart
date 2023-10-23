import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/text_form_field_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveCreateModalSheet extends ConsumerWidget {
  const DriveCreateModalSheet({
    super.key,
    required this.account,
    required this.folder,
  });

  final Account account;
  final DriveFolder? folder;

  Future<void> upload(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result == null || result.files.isEmpty) return;

    final context = ref.context;
    final misskey = ref.read(misskeyProvider(account));
    final fileSystem = ref.read(fileSystemProvider);
    await Future.wait(
      result.files.map((file) async {
        final path = file.path;
        if (path != null) {
          ref
              .read(driveFilesNotifierProvider((misskey, folder?.id)).notifier)
              .upload(fileSystem.file(path));
        }
      }),
    );
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> createFolder(WidgetRef ref) async {
    final context = ref.context;
    final misskey = ref.read(misskeyProvider(account));
    final name = await showDialog<String>(
      context: context,
      builder: (context) => TextFormFieldDialog(
        title: Text(S.of(context).createFolder),
        labelText: S.of(context).folderName,
      ),
    );
    if (name != null) {
      await ref
          .read(
            driveFoldersNotifierProvider((misskey, folder?.id)).notifier,
          )
          .create(name);
      if (!context.mounted) return;
      Navigator.of(context).pop();
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
          onTap: () => upload(ref).expectFailure(context),
        ),
        ListTile(
          leading: const Icon(Icons.folder),
          title: Text(S.of(context).createFolder),
          onTap: () => createFolder(ref).expectFailure(context),
        ),
      ],
    );
  }
}
