import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/drive_page/drive_files_notifier.dart";
import "package:miria/view/drive_page/drive_file_page/drive_file_info.dart";
import "package:miria/view/drive_page/drive_file_page/drive_file_notes.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class DriveFilePage extends ConsumerWidget {
  const DriveFilePage({required this.file, super.key});

  final DriveFile file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file =
        ref.watch(
          driveFilesNotifierProvider(this.file.folderId).select(
            (files) => files.value?.items.firstWhereOrNull(
              (e) => e.id == this.file.id,
            ),
          ),
        ) ??
        this.file;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).fileDetails),
          actions: [
            IconButton(
              onPressed: () async {
                await context.pushRoute(DriveFileModalRoute(file: file));
                final siblings = await ref.read(
                  driveFilesNotifierProvider(file.folderId).future,
                );
                if (!context.mounted) return;
                if (siblings.items.every((e) => e.id != file.id)) {
                  await context.maybePop();
                }
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).info),
              Tab(text: S.of(context).attachedNotes),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DriveFileInfo(file: file),
            DriveFileNotes(file: file),
          ],
        ),
      ),
    );
  }
}
