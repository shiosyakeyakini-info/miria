import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/futable_list_builder.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class FolderResult {
  const FolderResult(this.folder);

  final DriveFolder? folder;
}

@RoutePage<FolderResult>()
class FolderSelectDialog extends ConsumerStatefulWidget {
  final Account account;
  final List<String>? fileShowTarget;
  final String confirmationText;

  const FolderSelectDialog({
    required this.account,
    required this.fileShowTarget,
    required this.confirmationText,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FolderSelectDialogState();
}

class FolderSelectDialogState extends ConsumerState<FolderSelectDialog> {
  final List<DriveFolder> path = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(S.of(context).selectFolder),
          Row(
            children: [
              if (path.isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() {
                      path.removeLast();
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              Expanded(child: Text(path.map((e) => e.name).join("/"))),
            ],
          ),
        ],
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
                hideIsEmpty: true,
                initializeFuture: () async {
                  final misskey = ref.read(misskeyProvider(widget.account));
                  final response = await misskey.drive.folders.folders(
                    DriveFoldersRequest(
                      folderId: path.isEmpty ? null : path.last.id,
                    ),
                  );
                  return response.toList();
                },
                nextFuture: (lastItem, _) async {
                  final misskey = ref.read(misskeyProvider(widget.account));
                  final response = await misskey.drive.folders.folders(
                    DriveFoldersRequest(
                      untilId: lastItem.id,
                      folderId: path.isEmpty ? null : path.last.id,
                    ),
                  );
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
                },
              ),
              if (widget.fileShowTarget != null)
                FutureListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  future: () async {
                    final list = [];
                    for (final element in widget.fileShowTarget!) {
                      list.addAll(
                        await ref
                            .read(misskeyProvider(widget.account))
                            .drive
                            .files
                            .find(
                              DriveFilesFindRequest(
                                folderId: path.lastOrNull?.id,
                                name: element,
                              ),
                            ),
                      );
                    }
                    return list.toList();
                  }(),
                  builder: (context, item) => Row(
                    children: [
                      const Icon(Icons.description),
                      Expanded(child: Text(item.name)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(FolderResult(path.lastOrNull));
          },
          child: Text(widget.confirmationText),
        ),
      ],
    );
  }
}
