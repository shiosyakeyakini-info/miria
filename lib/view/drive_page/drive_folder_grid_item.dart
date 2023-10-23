import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/drive_page/drive_folder_modal_sheet.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveFolderGridItem extends ConsumerWidget {
  const DriveFolderGridItem({
    super.key,
    required this.account,
    required this.folder,
    this.onTap,
    this.onLongPress,
  });

  final Account account;
  final DriveFolder folder;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.folder),
            ),
            Expanded(
              child: Center(
                child: Text(
                  folder.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (context) => DriveFolderModalSheet(
                  account: account,
                  folder: folder,
                ),
              ),
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
