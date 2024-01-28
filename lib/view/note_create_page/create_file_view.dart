import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/misskey_post_file.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/note_create_page/file_settings_dialog.dart';
import 'package:miria/view/note_create_page/thumbnail.dart';

class CreateFileView extends ConsumerWidget {
  final int index;
  final MisskeyPostFile file;

  const CreateFileView({
    super.key,
    required this.file,
    required this.index,
  });

  Future<void> onTap(BuildContext context, WidgetRef ref) async {
    Future<Uint8List?> getDriveImage(String url) async {
      final response = await ref.read(dioProvider).get<Uint8List>(
            url,
            options: Options(responseType: ResponseType.bytes),
          );
      return response.data;
    }

    final account = AccountScope.of(context);
    final initialImage = switch (file) {
      PostFile(:final file) => await file.readAsBytes(),
      AlreadyPostedFile(:final file) => await getDriveImage(file.url),
    };
    if (initialImage == null) return;
    if (!context.mounted) return;

    context.pushRoute<Uint8List?>(
      PhotoEditRoute(
        account: account,
        initialImage: initialImage,
        onSubmit: (result) {
          ref
              .read(noteCreateProvider(account).notifier)
              .setFileContent(file, result);
        },
      ),
    );
  }

  Future<void> detailTap(BuildContext context, WidgetRef ref) async {
    final account = AccountScope.of(context);
    final result = await showDialog<FileSettingsDialogResult?>(
        context: context, builder: (context) => FileSettingsDialog(file: file));
    if (result == null) return;

    ref
        .read(noteCreateProvider(account).notifier)
        .setFileMetaData(index, result);
  }

  void delete(BuildContext context, WidgetRef ref) {
    ref
        .read(noteCreateProvider(AccountScope.of(context)).notifier)
        .deleteFile(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = file.type;
    final isImage = file.type?.startsWith("image") ?? false;
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: GestureDetector(
            onTap: isImage &&
                    (defaultTargetPlatform == TargetPlatform.iOS ||
                        defaultTargetPlatform == TargetPlatform.macOS ||
                        defaultTargetPlatform == TargetPlatform.android)
                ? () => onTap(context, ref)
                : null,
            child: switch (file) {
              PostFile(:final file) =>
                isImage ? Image.file(file) : Thumbnail(type: type),
              AlreadyPostedFile(:final file) => Thumbnail.driveFile(file),
            },
          ),
        ),
        Row(
          children: [
            if (file.isNsfw) const Icon(Icons.warning_amber),
            Text(file.fileName),
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
    );
  }
}
