import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/exported_setting.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/settings_page/import_export_page/folder_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ImportExportRepository extends ChangeNotifier {
  final T Function<T>(ProviderListenable<T> provider) reader;

  ImportExportRepository(this.reader);

  Future<Iterable<DriveFile>> findExportedFiles(
    Account account,
    String? folderId,
  ) async {
    final files = await Future.wait([
      reader(misskeyProvider(account)).drive.files.find(
            DriveFilesFindRequest(
              name: "miria.json",
              folderId: folderId,
            ),
          ),
      reader(misskeyProvider(account)).drive.files.find(
            DriveFilesFindRequest(
              name: "miria.json.unknown",
              folderId: folderId,
            ),
          ),
    ]);
    return files.flattened;
  }

  Future<void> import(BuildContext context, Account account) async {
    final result = await showDialog<FolderResult>(
      context: context,
      builder: (context2) => FolderSelectDialog(
        account: account,
        fileShowTarget: const ["miria.json", "miria.json.unknown"],
        confirmationText: S.of(context).importFromThisFolder,
      ),
    );
    if (result == null) return;

    final folder = result.folder;

    final alreadyExists = await findExportedFiles(account, folder?.id);

    if (!context.mounted) return;
    if (alreadyExists.isEmpty) {
      await SimpleMessageDialog.show(
          context, S.of(context).exportedFileNotFound);
      return;
    }

    final importFile = alreadyExists.sortedBy((file) => file.createdAt).last;

    final response = await reader(dioProvider)
        .get(importFile.url, options: Options(responseType: ResponseType.json));

    final json = jsonDecode(response.data);

    final importedSettings = ExportedSetting.fromJson(json);

    // アカウント設定よみこみ
    final accounts = reader(accountsProvider);
    for (final accountSetting in importedSettings.accountSettings) {
      // この端末でログイン済みのアカウントであれば
      if (accounts.any((account) => account.acct == accountSetting.acct)) {
        reader(accountSettingsRepositoryProvider).save(accountSetting);
      }
    }

    // 全般設定
    reader(generalSettingsRepositoryProvider)
        .update(importedSettings.generalSettings);

    // タブ設定
    final tabSettings = <TabSetting>[];

    for (final tabSetting in importedSettings.tabSettings) {
      final account = accounts
          .firstWhereOrNull((account) => tabSetting.acct == account.acct);

      if (account == null) {
        continue;
      }

      tabSettings.add(tabSetting);
    }
    reader(tabSettingsRepositoryProvider).save(tabSettings);

    if (!context.mounted) return;
    await SimpleMessageDialog.show(context, S.of(context).importCompleted);

    if (!context.mounted) return;
    context.router
      ..removeWhere((route) => true)
      ..push(const SplashRoute());
  }

  Future<void> export(BuildContext context, Account account) async {
    final result = await showDialog<FolderResult>(
      context: context,
      builder: (context2) => FolderSelectDialog(
        account: account,
        fileShowTarget: const ["miria.json", "miria.json.unknown"],
        confirmationText: S.of(context).exportToThisFolder,
      ),
    );
    if (result == null) return;

    final folder = result.folder;

    final alreadyExists = await findExportedFiles(account, folder?.id);

    if (!context.mounted) return;
    if (alreadyExists.isNotEmpty) {
      final alreadyConfirm = await SimpleConfirmDialog.show(
        context: context,
        message: S.of(context).confirmOverwrite,
        primary: S.of(context).overwrite,
        secondary: S.of(context).cancel,
      );
      if (alreadyConfirm != true) return;

      for (final element in alreadyExists) {
        await reader(misskeyProvider(account))
            .drive
            .files
            .delete(DriveFilesDeleteRequest(fileId: element.id));
      }
    }

    final packageInfo = await PackageInfo.fromPlatform();

    final data = {
      ...ExportedSetting(
        generalSettings: reader(generalSettingsRepositoryProvider).settings,
        tabSettings: reader(tabSettingsRepositoryProvider).tabSettings.toList(),
        accountSettings:
            reader(accountSettingsRepositoryProvider).accountSettings.toList(),
      ).toJson(),
      "metadata": {
        "createdAt": DateTime.now().toUtc().toIso8601String(),
        "packageInfo": packageInfo.data,
        "platform": defaultTargetPlatform.name,
      },
    };

    if (!context.mounted) return;
    await reader(misskeyProvider(account)).drive.files.createAsBinary(
          DriveFilesCreateRequest(
            folderId: folder?.id,
            name: "miria.json",
            comment: S.of(context).exportedFileComment,
            force: true,
          ),
          Uint8List.fromList(utf8.encode(jsonEncode(data))),
        );

    if (!context.mounted) return;
    await SimpleMessageDialog.show(context, S.of(context).exportCompleted);
  }
}
