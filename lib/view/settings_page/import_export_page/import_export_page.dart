import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';

@RoutePage()
class ImportExportPage extends ConsumerStatefulWidget {
  const ImportExportPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ImportExportPageState();
}

class ImportExportPageState extends ConsumerState<ImportExportPage> {
  Account? selectedImportAccount;
  Account? selectedExportAccount;

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("設定のインポート・エクスポート")),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "設定のインポート",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text(
                "設定ファイルをドライブから読み込みます。設定ファイルには保存されたときのすべてのアカウントの設定情報が記録されていますが、そのうちこの端末でログインしているアカウントの情報のみを読み込みます。",
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      items: [
                        for (final account in accounts)
                          DropdownMenuItem(
                            value: account,
                            child: Text(account.acct.toString()),
                          ),
                      ],
                      value: selectedImportAccount,
                      onChanged: (Account? value) {
                        setState(() {
                          selectedImportAccount = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final account = selectedImportAccount;
                      if (account == null) {
                        await SimpleMessageDialog.show(context, "アカウントを選んでや");
                        return;
                      }
                      await ref
                          .read(importExportRepository)
                          .import(context, account);
                    },
                    child: const Text("選択"),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Text(
                "設定のエクスポート",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text(
                "設定ファイルをドライブに保存します。設定ファイルにはこの端末でログインしているすべてのアカウントの、ログイン情報以外の情報が記録されます。",
              ),
              const Text("設定ファイルは1回のエクスポートにつき1つのアカウントに対して保存します。"),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      items: [
                        for (final account in accounts)
                          DropdownMenuItem(
                            value: account,
                            child: Text(account.acct.toString()),
                          ),
                      ],
                      value: selectedExportAccount,
                      onChanged: (Account? value) {
                        setState(() {
                          selectedExportAccount = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final account = selectedExportAccount;
                        if (account == null) {
                          SimpleMessageDialog.show(
                            context,
                            "設定ファイルを保存するアカウントを選んでや",
                          );
                          return;
                        }
                        ref
                            .read(importExportRepository)
                            .export(context, account);
                      },
                      child: const Text("保存")),
                ],
              ),
            ]),
      ),
    );
  }
}
