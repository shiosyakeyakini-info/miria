import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage<List<DriveFile>>()
class DriveFileSelectDialog extends HookConsumerWidget
    implements AutoRouteWrapper {
  final Account account;
  final bool allowMultiple;

  const DriveFileSelectDialog({
    required this.account,
    super.key,
    this.allowMultiple = false,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = useState<List<DriveFolder>>([]);
    final files = useState<List<DriveFile>>([]);

    return AlertDialog(
      title: AppBar(
        leading: IconButton(
          onPressed: path.value.isEmpty
              ? null
              : () => path.value = [...path.value..removeLast()],
          icon: const Icon(Icons.arrow_back),
        ),
        title: path.value.isEmpty
            ? Text(S.of(context).chooseFile)
            : Text(path.value.map((e) => e.name).join("/")),
        actions: [
          if (files.value.isNotEmpty)
            Center(
              child: Text(
                "(${files.value.length})",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (allowMultiple)
            IconButton(
              onPressed: files.value.isEmpty
                  ? null
                  : () => Navigator.of(context).pop(files.value),
              icon: const Icon(Icons.check),
            ),
        ],
        backgroundColor: Colors.transparent,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PushableListView(
                hideIsEmpty: true,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                showAd: false,
                initializeFuture: () async {
                  final misskey = ref.read(misskeyGetContextProvider);
                  final response = await misskey.drive.folders.folders(
                    DriveFoldersRequest(
                      folderId: path.value.isEmpty ? null : path.value.last.id,
                    ),
                  );
                  return response.toList();
                },
                nextFuture: (lastItem, _) async {
                  final misskey = ref.read(misskeyGetContextProvider);
                  final response = await misskey.drive.folders.folders(
                    DriveFoldersRequest(
                      untilId: lastItem.id,
                      folderId: path.value.isEmpty ? null : path.value.last.id,
                    ),
                  );
                  return response.toList();
                },
                listKey: path.value.map((e) => e.id).join("/"),
                itemBuilder: (context, item) {
                  return ListTile(
                    leading: const Icon(Icons.folder),
                    title: Text(item.name),
                    onTap: () => path.value = [...path.value, item],
                  );
                },
              ),
              PushableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                showAd: false,
                initializeFuture: () async {
                  final misskey = ref.read(misskeyGetContextProvider);
                  final response = await misskey.drive.files.files(
                    DriveFilesRequest(
                      folderId: path.value.isEmpty ? null : path.value.last.id,
                    ),
                  );
                  return response.toList();
                },
                nextFuture: (lastItem, _) async {
                  final misskey = ref.read(misskeyGetContextProvider);
                  final response = await misskey.drive.files.files(
                    DriveFilesRequest(
                      untilId: lastItem.id,
                      folderId: path.value.isEmpty ? null : path.value.last.id,
                    ),
                  );
                  return response.toList();
                },
                listKey: path.value.map((e) => e.id).join("/"),
                itemBuilder: (context, item) {
                  final isSelected =
                      files.value.any((file) => file.id == item.id);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onTap: () {
                        if (allowMultiple) {
                          if (isSelected) {
                            files.value = files.value
                                .where((file) => file.id != item.id)
                                .toList();
                          } else {
                            files.value = [...files.value, item];
                          }
                        } else {
                          Navigator.of(context).pop([item]);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: (allowMultiple && isSelected)
                            ? BoxDecoration(
                                color: AppTheme.of(context)
                                    .currentDisplayTabColor
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(5),
                              )
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: item.thumbnailUrl == null
                                  ? const SizedBox.shrink()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: NetworkImageView(
                                        fit: BoxFit.cover,
                                        url: item.thumbnailUrl!,
                                        type: ImageType.imageThumbnail,
                                      ),
                                    ),
                            ),
                            Text(item.name),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
