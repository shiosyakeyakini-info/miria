import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/antenna_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/antenna_page/antenna_list.dart';
import 'package:miria/view/antenna_page/antenna_settings_dialog.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class AntennaPage extends ConsumerWidget {
  final Account account;

  const AntennaPage({required this.account, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));

    return AccountScope(
      account: account,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).antenna),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final settings = await showDialog<AntennaSettings>(
                  context: context,
                  builder: (context) => AntennaSettingsDialog(
                    title: Text(S.of(context).create),
                    account: account,
                  ),
                );
                if (!context.mounted) return;
                if (settings != null) {
                  await ref
                      .read(antennasNotifierProvider(misskey).notifier)
                      .create(settings)
                      .expectFailure(context);
                }
              },
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: AntennaList(),
        ),
      ),
    );
  }
}
