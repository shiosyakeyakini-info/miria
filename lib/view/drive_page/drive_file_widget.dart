import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/note_create_page/thumbnail.dart";
import "package:misskey_dart/misskey_dart.dart" hide Clip;

class DriveFileWidget extends ConsumerWidget {
  const DriveFileWidget({
    required this.file,
    super.key,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  final DriveFile file;
  final bool isSelected;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: isSelected ? theme.colorScheme.primary : null,
      child: IconTheme(
        data: IconThemeData(
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
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
                    IconButton(
                      onPressed: () async => await context.pushRoute(
                        DriveFileModalRoute(file: file),
                      ),
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
