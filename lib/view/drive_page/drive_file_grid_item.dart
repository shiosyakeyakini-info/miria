import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/drive_page/drive_file_modal_sheet.dart';
import 'package:miria/view/note_create_page/thumbnail.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveFileGridItem extends ConsumerWidget {
  const DriveFileGridItem({
    super.key,
    required this.account,
    required this.file,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  final Account account;
  final DriveFile file;
  final bool isSelected;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: isSelected
          ? AppTheme.of(context).currentDisplayTabColor.withOpacity(0.7)
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          children: [
            Expanded(
              child: Thumbnail.driveFile(file, fit: BoxFit.cover),
            ),
            Row(
              children: [
                Visibility.maintain(
                  visible: file.isSensitive,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Tooltip(
                      message: S.of(context).sensitive,
                      child: const Icon(Icons.warning_amber),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      file.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (context) => DriveFileModalSheet(
                      account: account,
                      file: file,
                    ),
                  ),
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
