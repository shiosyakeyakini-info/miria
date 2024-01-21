import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DriveFileSelectDialog extends ConsumerStatefulWidget {
  final Account account;
  final bool allowMultiple;

  const DriveFileSelectDialog({
    super.key,
    required this.account,
    this.allowMultiple = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      DriveFileSelectDialogState();
}

class DriveFileSelectDialogState extends ConsumerState<DriveFileSelectDialog> {
  final List<DriveFolder> path = [];
  final List<DriveFile> files = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppBar(
        leading: IconButton(
          onPressed: path.isEmpty
              ? null
              : () {
                  setState(() {
                    path.removeLast();
                  });
                },
          icon: const Icon(Icons.arrow_back),
        ),
        title: path.isEmpty
            ? Text(S.of(context).chooseFile)
            : Text(path.map((e) => e.name).join("/")),
        actions: [
          if (files.isNotEmpty)
            Center(
              child: Text(
                "(${files.length})",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (widget.allowMultiple)
            IconButton(
              onPressed:
                  files.isEmpty ? null : () => Navigator.of(context).pop(files),
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  showAd: false,
                  initializeFuture: () async {
                    final misskey = ref.read(misskeyProvider(widget.account));
                    final response = await misskey.drive.folders.folders(
                        DriveFoldersRequest(
                            folderId: path.isEmpty ? null : path.last.id));
                    return response.toList();
                  },
                  nextFuture: (lastItem, _) async {
                    final misskey = ref.read(misskeyProvider(widget.account));
                    final response = await misskey.drive.folders.folders(
                        DriveFoldersRequest(
                            untilId: lastItem.id,
                            folderId: path.isEmpty ? null : path.last.id));
                    return response.toList();
                  },
                  listKey: path.map((e) => e.id).join("/"),
                  itemBuilder: (context, item) {
                    return ListTile(
                      leading: const Icon(Icons.folder),
                      title: Text(item.name),
                      onTap: () {
                        setState(() {
                          path.add(item);
                        });
                      },
                    );
                  }),
              PushableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                showAd: false,
                initializeFuture: () async {
                  final misskey = ref.read(misskeyProvider(widget.account));
                  final response = await misskey.drive.files.files(
                    DriveFilesRequest(
                      folderId: path.isEmpty ? null : path.last.id,
                    ),
                  );
                  return response.toList();
                },
                nextFuture: (lastItem, _) async {
                  final misskey = ref.read(misskeyProvider(widget.account));
                  final response = await misskey.drive.files.files(
                    DriveFilesRequest(
                      untilId: lastItem.id,
                      folderId: path.isEmpty ? null : path.last.id,
                    ),
                  );
                  return response.toList();
                },
                listKey: path.map((e) => e.id).join("/"),
                itemBuilder: (context, item) {
                  final isSelected = files.any((file) => file.id == item.id);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onTap: () {
                        if (widget.allowMultiple) {
                          setState(() {
                            if (isSelected) {
                              files.removeWhere((file) => file.id == item.id);
                            } else {
                              files.add(item);
                            }
                          });
                        } else {
                          Navigator.of(context).pop(item);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: (widget.allowMultiple && isSelected)
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
