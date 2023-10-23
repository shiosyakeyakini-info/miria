import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/drive_page/drive_file_modal_sheet.dart';
import 'package:miria/view/drive_page/drive_file_page/drive_file_details.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class DriveFilePage extends ConsumerWidget {
  const DriveFilePage({
    super.key,
    required this.account,
    required this.file,
  });

  final Account account;
  final DriveFile file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final file = ref.watch(
          driveFilesNotifierProvider((misskey, this.file.folderId)).select(
            (files) => files.valueOrNull
                ?.firstWhereOrNull((e) => e.id == this.file.id),
          ),
        ) ??
        this.file;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).fileDetails),
          actions: [
            IconButton(
              onPressed: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => DriveFileModalSheet(
                    account: account,
                    file: file,
                  ),
                );
                final misskey = ref.read(misskeyProvider(account));
                final siblings = await ref.read(
                  driveFilesNotifierProvider((misskey, file.folderId)).future,
                );
                // ファイルが削除されたら一つ上のフォルダに戻る
                if (siblings.every((e) => e.id != file.id)) {
                  ref.read(drivePageNotifierProvider.notifier).pop();
                }
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).info),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DriveFileDetails(account: account, file: file),
          ],
        ),
      ),
    );
  }
}
