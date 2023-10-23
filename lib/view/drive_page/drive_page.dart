import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/drive_page/drive_files_notifier.dart";
import "package:miria/state_notifier/drive_page/drive_folders_notifier.dart";
import "package:miria/view/common/pagination_bottom_widget.dart";
import "package:miria/view/drive_page/drive_file_widget.dart";
import "package:miria/view/drive_page/drive_folder_widget.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class DrivePage extends HookConsumerWidget {
  const DrivePage({this.selectFolder = false, super.key});

  final bool selectFolder;

  static const itemMaxCrossAxisExtent = 300.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hierarchyFolders = useState(<DriveFolder>[]);
    final folderId = hierarchyFolders.value.lastOrNull?.id;
    final parentId = hierarchyFolders.value.lastOrNull?.parentId;
    final currentFolder =
        ref.watch(
          driveFoldersNotifierProvider(parentId).select(
            (folders) => folders.value?.items.firstWhereOrNull(
              (folder) => folder.id == folderId,
            ),
          ),
        ) ??
        hierarchyFolders.value.lastOrNull;
    final folders = ref.watch(driveFoldersNotifierProvider(folderId));
    final files = ref.watch(driveFilesNotifierProvider(folderId));
    final enableInfiniteScroll = ref.watch(
      generalSettingsRepositoryProvider.select(
        (repository) =>
            repository.settings.automaticPush == AutomaticPush.automatic,
      ),
    );
    // https://github.com/flutter/flutter/blob/3.24.3/packages/flutter/lib/src/material/app_bar.dart#L2346
    // TODO: Material 3 にするときに `onSurface` に変更する。
    final appBarForegroundColor =
        Theme.of(context).appBarTheme.foregroundColor ??
        switch (Theme.of(context).brightness) {
          Brightness.light => Theme.of(context).colorScheme.onPrimary,
          Brightness.dark => Theme.of(context).colorScheme.onSurface,
        };
    final controller = useScrollController();
    final isAtBottom = useState(false);
    useEffect(() {
      Future<void> callback() async {
        if (controller.position.extentAfter < 100) {
          if (!isAtBottom.value) {
            isAtBottom.value = true;
            await Future.wait([
              ref
                  .read(driveFoldersNotifierProvider(folderId).notifier)
                  .loadMore(),
              ref
                  .read(driveFilesNotifierProvider(folderId).notifier)
                  .loadMore(),
            ]);
          }
        } else {
          isAtBottom.value = false;
        }
      }

      if (enableInfiniteScroll) {
        controller.addListener(callback);
      }
      return () => controller.removeListener(callback);
    }, [enableInfiniteScroll]);

    return PopScope(
      canPop: currentFolder == null,
      onPopInvokedWithResult: (_, _) {
        if (currentFolder != null) {
          hierarchyFolders.value = hierarchyFolders.value.sublist(
            0,
            hierarchyFolders.value.length - 1,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () async => await context.maybePop()),
          title: selectFolder
              ? Text(S.of(context).selectFolder)
              : Text(S.of(context).drive),
          actions: [
            if (!selectFolder)
              IconButton(
                onPressed: () async => await context.pushRoute(
                  DriveCreateModalRoute(folder: currentFolder),
                ),
                icon: const Icon(Icons.add),
              ),
            if (currentFolder != null)
              IconButton(
                onPressed: () async {
                  await context.pushRoute(
                    DriveFolderModalRoute(folder: currentFolder),
                  );
                  final siblings = await ref.read(
                    driveFoldersNotifierProvider(parentId).future,
                  );
                  final updated = siblings.items.firstWhereOrNull(
                    (folder) => folder.id == currentFolder.id,
                  );
                  if (updated == null) {
                    // フォルダが削除されたら一つ上のフォルダに戻る
                    hierarchyFolders.value = hierarchyFolders.value.sublist(
                      0,
                      hierarchyFolders.value.length - 1,
                    );
                  } else if (updated != currentFolder) {
                    // フォルダが更新されたら現在のフォルダを置き換える
                    hierarchyFolders.value = [
                      ...hierarchyFolders.value.sublist(
                        0,
                        hierarchyFolders.value.length - 1,
                      ),
                      updated,
                    ];
                  }
                },
                icon: const Icon(Icons.more_vert),
              ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // `reverse: true` とすると [SingleChildScrollView] は子が長くても
                // 右端のウィジェットを表示する。そのためネストが深くなっても現在の
                // フォルダを表示させることができる。
                reverse: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: hierarchyFolders.value.isNotEmpty
                            ? () => hierarchyFolders.value = []
                            : null,
                        icon: Icon(
                          Icons.cloud,
                          color: hierarchyFolders.value.isNotEmpty
                              ? appBarForegroundColor.withValues(alpha: 0.8)
                              : appBarForegroundColor,
                        ),
                      ),
                    ),
                    ...hierarchyFolders.value
                        .mapIndexed(
                          (index, folder) => [
                            Icon(
                              Icons.navigate_next,
                              color: appBarForegroundColor.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            TextButton(
                              onPressed: folder.id != folderId
                                  ? () => hierarchyFolders.value =
                                        hierarchyFolders.value.sublist(
                                          0,
                                          index + 1,
                                        )
                                  : null,
                              style: TextButton.styleFrom(
                                foregroundColor: appBarForegroundColor
                                    .withValues(alpha: 0.8),
                                disabledForegroundColor: appBarForegroundColor,
                              ),
                              child: Text(
                                folder.name,
                                style: TextStyle(
                                  fontWeight: folder.id == folderId
                                      ? FontWeight.bold
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        )
                        .flattened,
                  ],
                ),
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async => await Future.wait([
            ref.refresh(driveFoldersNotifierProvider(folderId).future),
            ref.refresh(driveFilesNotifierProvider(folderId).future),
          ]),
          child: CustomScrollView(
            controller: controller,
            slivers: [
              if (folders.value?.items case final folders?)
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: itemMaxCrossAxisExtent,
                    mainAxisExtent: 100,
                  ),
                  itemCount: folders.length,
                  itemBuilder: (context, index) => DriveFolderWidget(
                    folder: folders[index],
                    onTap: () => hierarchyFolders.value = [
                      ...hierarchyFolders.value,
                      folders[index],
                    ],
                    onLongPress: () async => await context.pushRoute(
                      DriveFolderModalRoute(folder: folders[index]),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: PaginationBottomWidget(
                  paginationState: folders,
                  loadMore: () async => await ref
                      .read(driveFoldersNotifierProvider(folderId).notifier)
                      .loadMore(skipError: true),
                ),
              ),
              if (files.value?.items case final files?)
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: itemMaxCrossAxisExtent,
                  ),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files.elementAt(index);
                    return DriveFileWidget(
                      file: file,
                      onTap: () async =>
                          await context.pushRoute(DriveFileRoute(file: file)),
                    );
                  },
                ),
              SliverToBoxAdapter(
                child: PaginationBottomWidget(
                  paginationState: files,
                  loadMore: () async => await ref
                      .read(driveFilesNotifierProvider(folderId).notifier)
                      .loadMore(skipError: true),
                  noItemsLabel: S.of(context).nothingHere,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: selectFolder
              ? () async =>
                    await context.router.parent()?.maybePop((currentFolder,))
              : () async => await context.pushRoute(
                  DriveCreateModalRoute(folder: currentFolder),
                ),
          child: selectFolder ? const Icon(Icons.check) : const Icon(Icons.add),
        ),
      ),
    );
  }
}
