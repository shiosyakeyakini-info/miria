import "package:auto_route/auto_route.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/misskey_post_file.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/note_create_page/file_settings_dialog.dart";
import "package:miria/view/note_create_page/thumbnail.dart";

class CreateFileView extends ConsumerWidget {
  final int index;
  final MisskeyPostFile file;

  const CreateFileView({required this.file, required this.index, super.key});

  Future<void> onTap(BuildContext context, WidgetRef ref) async {
    Future<Uint8List?> getDriveImage(String url) async {
      final response = await ref
          .read(dioProvider)
          .get<Uint8List>(
            url,
            options: Options(responseType: ResponseType.bytes),
          );
      return response.data;
    }

    final initialImage = switch (file) {
      PostFile(:final file) => await file.readAsBytes(),
      AlreadyPostedFile(:final file) => await getDriveImage(file.url),
    };
    if (initialImage == null) return;
    if (!context.mounted) return;

    await context.pushRoute<Uint8List?>(
      PhotoEditRoute(
        accountContext: ref.read(accountContextProvider),
        initialImage: initialImage,
        onSubmit: (result) {
          ref
              .read(noteCreateNotifierProvider.notifier)
              .setFileContent(file, result);
        },
      ),
    );
  }

  Future<void> detailTap(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<FileSettingsDialogResult?>(
      context: context,
      builder: (context) => FileSettingsDialog(file: file),
    );
    if (result == null) return;

    ref
        .read(noteCreateNotifierProvider.notifier)
        .setFileMetaData(index, result);
  }

  void delete(BuildContext context, WidgetRef ref) {
    ref.read(noteCreateNotifierProvider.notifier).deleteFile(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = file.type;
    final isImage = type?.startsWith("image") ?? false;

    return Card.outlined(
      child: SizedBox(
        width: 210,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 200,
                child: GestureDetector(
                  onTap:
                      isImage &&
                          (defaultTargetPlatform == TargetPlatform.iOS ||
                              defaultTargetPlatform == TargetPlatform.macOS ||
                              defaultTargetPlatform == TargetPlatform.android)
                      ? () async => await onTap(context, ref)
                      : null,
                  child: switch (file) {
                    PostFile(:final file) =>
                      isImage ? Image.file(file) : Thumbnail(type: type),
                    AlreadyPostedFile(:final file) => Thumbnail.driveFile(file),
                  },
                ),
              ),
            ),
            Row(
              children: [
                if (file.isNsfw)
                  const Icon(Icons.details_rounded)
                else
                  const SizedBox(width: 5),
                Expanded(
                  child: Text(file.fileName, overflow: TextOverflow.ellipsis),
                ),
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
        ),
      ),
    );
  }
}
