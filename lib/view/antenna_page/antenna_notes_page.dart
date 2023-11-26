import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/antenna_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/antenna_page/antenna_notes.dart';
import 'package:miria/view/antenna_page/antenna_settings_dialog.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class AntennaNotesPage extends ConsumerWidget {
  final Antenna antenna;
  final Account account;

  const AntennaNotesPage(
      {super.key, required this.antenna, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final antenna = ref.watch(
          antennasNotifierProvider(misskey).select(
            (antennas) => antennas.valueOrNull
                ?.firstWhereOrNull((e) => e.id == this.antenna.id),
          ),
        ) ??
        this.antenna;

    return AccountScope(
      account: account,
      child: Scaffold(
        appBar: AppBar(
          title: Text(antenna.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final settings = await showDialog<AntennaSettings>(
                  context: context,
                  builder: (context) => AntennaSettingsDialog(
                    title: Text(S.of(context).edit),
                    initialSettings: AntennaSettings.fromAntenna(antenna),
                    account: account,
                  ),
                );
                if (!context.mounted) return;
                if (settings != null) {
                  ref
                      .read(antennasNotifierProvider(misskey).notifier)
                      .updateAntenna(antenna.id, settings)
                      .expectFailure(context);
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: AntennaNotes(
            antennaId: antenna.id,
          ),
        ),
      ),
    );
  }
}
