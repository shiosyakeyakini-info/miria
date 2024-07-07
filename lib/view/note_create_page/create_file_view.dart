import "package:auto_route/auto_route.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/note_create_page/file_settings_dialog.dart";

class CreateFileView extends ConsumerWidget {
  final int index;
  final MisskeyPostFile file;

  const CreateFileView({
    required this.file,
    required this.index,
    super.key,
  });

  Future<void> onTap(BuildContext context, WidgetRef ref) async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      final account = ref.read(accountContextProvider).postAccount;
      await context.pushRoute<Uint8List?>(
        PhotoEditRoute(
          accountContext: ref.read(accountContextProvider),
          file: file,
          onSubmit: (result) {
            ref
                .read(noteCreateNotifierProvider(account).notifier)
                .setFileContent(file, result);
          },
        ),
      );
    }
  }

  Future<void> detailTap(BuildContext context, WidgetRef ref) async {
    final account = AccountScope.of(context);
    final result = await showDialog<FileSettingsDialogResult?>(
      context: context,
      builder: (context) => FileSettingsDialog(file: file),
    );
    if (result == null) return;

    ref
        .read(noteCreateNotifierProvider(account).notifier)
        .setFileMetaData(index, result);
  }

  void delete(BuildContext context, WidgetRef ref) {
    ref
        .read(noteCreateNotifierProvider(AccountScope.of(context)).notifier)
        .deleteFile(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = file;

    switch (data) {
      case ImageFile():
        return Card.outlined(
          child: SizedBox(
            width: 210,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    height: 200,
                    child: GestureDetector(
                      onTap: () async => await onTap(context, ref),
                      child: Image.memory(data.data),
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (data.isNsfw) const Icon(Icons.details_rounded),
                    if (!data.isNsfw) const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        data.fileName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => detailTap(context, ref),
                      icon: const Icon(Icons.more_vert),
                    ),
                    IconButton(
                      onPressed: () => delete(context, ref),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      case ImageFileAlreadyPostedFile():
        return Column(
          children: [
            SizedBox(
              height: 200,
              child: GestureDetector(
                onTap: () async => await onTap(context, ref),
                child: Image.memory(data.data),
              ),
            ),
            Row(
              children: [
                if (data.isNsfw) const Icon(Icons.details_rounded),
                Text(data.fileName),
                IconButton(
                  onPressed: () async => detailTap(context, ref),
                  icon: const Icon(Icons.more_vert),
                ),
                IconButton(
                  onPressed: () => delete(context, ref),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        );
      case UnknownFile():
        return Text(data.fileName);
      case UnknownAlreadyPostedFile():
        return Text(data.fileName);
    }
  }
}
