import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/drive_page/drive_files_notifier.dart";
import "package:miria/state_notifier/drive_page/drive_folders_notifier.dart";
import "package:miria/view/common/pagination_bottom_widget.dart";
import "package:miria/view/drive_page/drive_file_widget.dart";
import "package:miria/view/drive_page/drive_folder_widget.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class DrivePage extends HookConsumerWidget {
  const DrivePage({super.key});

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
        appBar: AppBar(title: Text(S.of(context).drive)),
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
                    return DriveFileWidget(file: file);
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
      ),
    );
  }
}
