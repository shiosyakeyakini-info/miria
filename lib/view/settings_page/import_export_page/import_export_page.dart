import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppBar(title: Text(S.of(context).settingsImportAndExport)),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).importSettings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(S.of(context).importSettingsDescription),
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
                        await SimpleMessageDialog.show(
                          context,
                          S.of(context).pleaseSelectAccount,
                        );
                        return;
                      }
                      await ref
                          .read(importExportRepository)
                          .import(context, account)
                          .expectFailure(context);
                    },
                    child: Text(S.of(context).select),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Text(
                S.of(context).exportSettings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(S.of(context).exportSettingsDescription1),
              Text(S.of(context).exportSettingsDescription2),
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
                            S.of(context).pleaseSelectAccountToExportSettings,
                          );
                          return;
                        }
                        ref
                            .read(importExportRepository)
                            .export(context, account)
                            .expectFailure(context);
                      },
                      child: Text(S.of(context).save)),
                ],
              ),
            ]),
      ),
    );
  }
}
