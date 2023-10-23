import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/pagination_bottom_item.dart';
import 'package:miria/view/drive_page/breadcrumbs.dart';
import 'package:miria/view/drive_page/drive_file_grid_item.dart';
import 'package:miria/view/drive_page/drive_folder_grid_item.dart';
import 'package:miria/view/drive_page/drive_folder_modal_sheet.dart';

@RoutePage()
class DrivePage extends ConsumerWidget {
  const DrivePage({super.key, required this.account});

  final Account account;

  static const itemMaxCrossAxisExtent = 400.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final last = ref.watch(
      drivePageNotifierProvider.select((state) => state.breadcrumbs.lastOrNull),
    );
    final folderId = last?.id;
    final arg = (misskey, folderId);
    final currentFolder = ref.watch(
          driveFoldersNotifierProvider((misskey, last?.parentId)).select(
            (folders) => folders.valueOrNull
                ?.firstWhereOrNull((folder) => folder.id == folderId),
          ),
        ) ??
        last;
    final folders = ref.watch(driveFoldersNotifierProvider(arg));
    final files = ref.watch(driveFilesNotifierProvider(arg));
    final loadAutomatically = ref.watch(
      generalSettingsRepositoryProvider.select(
        (repository) =>
            repository.settings.automaticPush == AutomaticPush.automatic,
      ),
    );

    return PopScope(
      canPop: currentFolder == null,
      onPopInvoked: (_) {
        if (currentFolder != null) {
          ref.read(drivePageNotifierProvider.notifier).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).drive),
          actions: [
            if (currentFolder != null)
              IconButton(
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    builder: (context) => DriveFolderModalSheet(
                      account: account,
                      folder: currentFolder,
                    ),
                  );
                  final siblings = await ref.read(
                    driveFoldersNotifierProvider(
                      (misskey, currentFolder.parentId),
                    ).future,
                  );
                  final updated = siblings.firstWhereOrNull(
                    (folder) => folder.id == currentFolder.id,
                  );
                  if (updated == null) {
                    // フォルダが削除されたら一つ上のフォルダに戻る
                    ref.read(drivePageNotifierProvider.notifier).pop();
                  } else if (updated != currentFolder) {
                    // フォルダが更新されたら現在のフォルダを置き換える
                    ref
                        .read(drivePageNotifierProvider.notifier)
                        .replace(updated);
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
              child: Breadcrumbs(account: account),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.wait([
            ref.refresh(driveFoldersNotifierProvider(arg).future),
            ref.refresh(driveFilesNotifierProvider(arg).future),
          ]),
          child: CustomScrollView(
            slivers: [
              folders.when(
                data: (folders) => SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: itemMaxCrossAxisExtent,
                      mainAxisExtent: 100,
                    ),
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      if (index == folders.length - 1 &&
                          loadAutomatically &&
                          !folders.isLoading &&
                          !folders.isLastLoaded) {
                        Future(() {
                          ref
                              .read(driveFoldersNotifierProvider(arg).notifier)
                              .loadMore()
                              .expectFailure(context);
                        });
                        return const SizedBox.shrink();
                      }
                      final folder = folders[index];
                      return DriveFolderGridItem(
                        account: account,
                        folder: folder,
                        onTap: () => ref
                            .read(drivePageNotifierProvider.notifier)
                            .push(folder),
                        onLongPress: () => showModalBottomSheet<void>(
                          context: context,
                          builder: (context) => DriveFolderModalSheet(
                            account: account,
                            folder: folder,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                error: (e, st) => SliverToBoxAdapter(
                  child: Center(child: ErrorDetail(error: e, stackTrace: st)),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              SliverToBoxAdapter(
                child: folders.maybeWhen(
                  data: (folders) => Center(
                    child: PaginationBottomItem(
                      paginationState: folders,
                      child: !loadAutomatically
                          ? IconButton(
                              onPressed: ref
                                  .read(
                                    driveFoldersNotifierProvider(arg).notifier,
                                  )
                                  .loadMore
                                  .expectFailure(context),
                              icon: const Icon(Icons.keyboard_arrow_down),
                            )
                          : null,
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
              if (folders.valueOrNull?.isNotEmpty ?? true)
                const SliverToBoxAdapter(child: Divider()),
              files.when(
                data: (files) => SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: itemMaxCrossAxisExtent,
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      if (index == files.length - 1 &&
                          loadAutomatically &&
                          !files.isLoading &&
                          !files.isLastLoaded) {
                        Future(() {
                          ref
                              .read(driveFilesNotifierProvider(arg).notifier)
                              .loadMore()
                              .expectFailure(context);
                        });
                        return const SizedBox.shrink();
                      }
                      return DriveFileGridItem(
                        account: account,
                        file: files[index],
                      );
                    },
                  ),
                ),
                error: (e, st) => SliverToBoxAdapter(
                  child: Center(child: ErrorDetail(error: e, stackTrace: st)),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              SliverToBoxAdapter(
                child: files.maybeWhen(
                  data: (files) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: PaginationBottomItem(
                        paginationState: files,
                        noItemsLabel: Text(S.of(context).noFiles),
                        child: !loadAutomatically
                            ? IconButton(
                                onPressed: ref
                                    .read(
                                      driveFilesNotifierProvider(arg).notifier,
                                    )
                                    .loadMore
                                    .expectFailure(context),
                                icon: const Icon(Icons.keyboard_arrow_down),
                              )
                            : null,
                      ),
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
