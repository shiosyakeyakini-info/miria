import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";

class DriveFolderWidget extends ConsumerWidget {
  const DriveFolderWidget({
    required this.folder,
    super.key,
    this.onTap,
    this.onLongPress,
  });

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
              padding: EdgeInsets.all(8.0),
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
              onPressed: () async => await context.pushRoute(
                DriveFolderModalRoute(folder: folder),
              ),
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
