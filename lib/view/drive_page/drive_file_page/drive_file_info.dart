import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/drive_page/drive_files_notifier.dart";
import "package:miria/util/pretty_bytes.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/misskey_file_view.dart";
import "package:misskey_dart/misskey_dart.dart";

class DriveFileInfo extends ConsumerWidget {
  const DriveFileInfo({required this.file, super.key});

  final DriveFile file;

  Future<void> _setName(WidgetRef ref, DriveFile file) async {
    final name = await ref.context.pushRoute<String>(
      TextFormFieldRoute(
        title: Text(S.of(ref.context).changeFileName),
        labelText: S.of(ref.context).fileName,
        initialValue: file.name,
      ),
    );
    if (name != null && name != file.name) {
      await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(driveFilesNotifierProvider(file.folderId).notifier)
                .updateFile(fileId: file.id, name: name),
          );
    }
  }

  Future<void> _setComment(WidgetRef ref, DriveFile file) async {
    final comment = await ref.context.pushRoute<String>(
      TextFormFieldRoute(
        title: Text(S.of(ref.context).changeCaption),
        initialValue: file.comment,
        maxLines: null,
      ),
    );
    if (comment != null && comment != file.comment) {
      await ref
          .read(dialogStateNotifierProvider.notifier)
          .guard(
            () => ref
                .read(driveFilesNotifierProvider(file.folderId).notifier)
                .updateFile(fileId: file.id, comment: comment),
          );
    }
  }

  Future<void> _setIsSensitive(WidgetRef ref, bool? isSensitive) async {
    if (isSensitive == null) return;
    await ref
        .read(dialogStateNotifierProvider.notifier)
        .guard(
          () => ref
              .read(driveFilesNotifierProvider(file.folderId).notifier)
              .updateFile(fileId: file.id, isSensitive: isSensitive),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MisskeyFileView(files: [file], height: 400),
          ),
          IconTheme(
            data: IconThemeData(
              color: Theme.of(context).colorScheme.primary,
              size: 18.0,
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3.0),
                1: FlexColumnWidth(7.0),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(S.of(context).fileName),
                    ),
                    InkWell(
                      onTap: () async => await _setName(ref, file),
                      onLongPress: () async {
                        await Clipboard.setData(ClipboardData(text: file.name));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).doneCopy),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(
                          TextSpan(
                            text: file.name,
                            children: const [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(S.of(context).caption),
                    ),
                    InkWell(
                      onTap: () async => await _setComment(ref, file),
                      onLongPress: file.comment != null
                          ? () async {
                              await Clipboard.setData(
                                ClipboardData(text: file.comment!),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).doneCopy),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(
                          TextSpan(
                            text: file.comment ?? "(${S.of(context).none})",
                            children: const [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(Icons.edit),
                              ),
                            ],
                            style: TextStyle(
                              color: file.comment == null
                                  ? Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.5)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(S.of(context).sensitive),
                    ),
                    Checkbox(
                      value: file.isSensitive,
                      onChanged: (isSensitive) async =>
                          await _setIsSensitive(ref, isSensitive),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(S.of(context).fileCreatedAt),
                    ),
                    InkWell(
                      onLongPress: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: file.createdAt.formatUntilMilliSeconds(
                              context,
                            ),
                          ),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).doneCopy),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${file.createdAt.formatUntilSeconds(context)} "
                          "(${file.createdAt.differenceNow(context)})",
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(S.of(context).fileType),
                    ),
                    InkWell(
                      onLongPress: () async {
                        await Clipboard.setData(ClipboardData(text: file.type));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).doneCopy),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(file.type),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(S.of(context).fileSize),
                    ),
                    InkWell(
                      onLongPress: () async {
                        await Clipboard.setData(
                          ClipboardData(text: prettyBytes(file.size)),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).doneCopy),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(prettyBytes(file.size)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
