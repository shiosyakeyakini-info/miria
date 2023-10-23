import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/view/note_create_page/thumbnail.dart";
import "package:misskey_dart/misskey_dart.dart" hide Clip;

class DriveFileWidget extends ConsumerWidget {
  const DriveFileWidget({
    required this.file,
    super.key,
    this.onTap,
    this.onLongPress,
  });

  final DriveFile file;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          children: [
            Expanded(child: Thumbnail.driveFile(file, fit: BoxFit.contain)),
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
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
