import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/misskey_file_view.dart';
import 'package:miria/view/common/text_form_field_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveFileDetails extends ConsumerWidget {
  const DriveFileDetails({
    super.key,
    required this.account,
    required this.file,
  });

  final Account account;
  final DriveFile file;

  Future<void> changeName(WidgetRef ref, DriveFile file) async {
    final misskey = ref.read(misskeyProvider(account));
    final name = await showDialog<String>(
      context: ref.context,
      builder: (context) => TextFormFieldDialog(
        title: Text(S.of(context).changeFileName),
        initialValue: file.name,
      ),
    );
    if (name != null && name != file.name) {
      await ref
          .read(
            driveFilesNotifierProvider((misskey, file.folderId)).notifier,
          )
          .updateFile(fileId: file.id, name: name);
    }
  }

  Future<void> changeCaption(WidgetRef ref, DriveFile file) async {
    final misskey = ref.read(misskeyProvider(account));
    final comment = await showDialog<String>(
      context: ref.context,
      builder: (context) => TextFormFieldDialog(
        title: Text(S.of(context).changeCaption),
        initialValue: file.comment,
        maxLines: null,
      ),
    );
    if (comment != null && comment != file.comment) {
      await ref
          .read(
            driveFilesNotifierProvider((misskey, file.folderId)).notifier,
          )
          .updateFile(fileId: file.id, comment: comment);
    }
  }

  Future<void> changeIsSensitive(WidgetRef ref, bool? isSensitive) async {
    if (isSensitive == null) return;
    final misskey = ref.read(misskeyProvider(account));
    await ref
        .read(
          driveFilesNotifierProvider((misskey, file.folderId)).notifier,
        )
        .updateFile(fileId: file.id, isSensitive: isSensitive);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MisskeyFileView(
            files: [file],
            height: 400,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(S.of(context).fileName)),
                    DataCell(
                      Text(file.name),
                      showEditIcon: true,
                      onTap: () => changeName(ref, file).expectFailure(context),
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: file.name));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(S.of(context).doneCopy)),
                        );
                      },
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(S.of(context).caption)),
                    DataCell(
                      Text(file.comment ?? "(${S.of(context).none})"),
                      placeholder: file.comment == null,
                      showEditIcon: true,
                      onTap: () =>
                          changeCaption(ref, file).expectFailure(context),
                      onLongPress: file.comment != null
                          ? () {
                              Clipboard.setData(
                                ClipboardData(text: file.comment!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(S.of(context).doneCopy)),
                              );
                            }
                          : null,
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(S.of(context).sensitive)),
                    DataCell(
                      Checkbox(
                        value: file.isSensitive,
                        onChanged: (isSensitive) =>
                            changeIsSensitive(ref, isSensitive)
                                .expectFailure(context),
                      ),
                      showEditIcon: true,
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(S.of(context).fileCreatedAt)),
                    DataCell(
                      Text(
                        "${file.createdAt.formatUntilSeconds(context)} "
                        "(${file.createdAt.differenceNow(context)})",
                      ),
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                file.createdAt.formatUntilMilliSeconds(context),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(S.of(context).doneCopy)),
                        );
                      },
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(S.of(context).fileType)),
                    DataCell(
                      Text(file.type),
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: file.type));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(S.of(context).doneCopy)),
                        );
                      },
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(S.of(context).fileSize)),
                    DataCell(
                      Text("${NumberFormat.compact().format(file.size)}B"),
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                "${NumberFormat.compact().format(file.size)}B",
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(S.of(context).doneCopy)),
                        );
                      },
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
