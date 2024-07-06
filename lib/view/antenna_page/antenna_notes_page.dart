import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/antenna_settings.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/antenna_page/antenna_notes.dart";
import "package:miria/view/antenna_page/antennas_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class AntennaNotesPage extends ConsumerWidget implements AutoRouteWrapper {
  final Antenna antenna;
  final Account account;

  const AntennaNotesPage({
    required this.antenna,
    required this.account,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antenna = ref.watch(
          antennasNotifierProvider.select(
            (antennas) => antennas.valueOrNull
                ?.firstWhereOrNull((e) => e.id == this.antenna.id),
          ),
        ) ??
        this.antenna;

    return Scaffold(
      appBar: AppBar(
        title: Text(antenna.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final settings = await context.pushRoute<AntennaSettings>(
                AntennaSettingsRoute(
                  title: Text(S.of(context).edit),
                  initialSettings: AntennaSettings.fromAntenna(antenna),
                  account: account,
                ),
              );
              if (!context.mounted) return;
              if (settings == null) return;
              await ref
                  .read(antennasNotifierProvider.notifier)
                  .updateAntenna(antenna.id, settings);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: AntennaNotes(antennaId: antenna.id),
      ),
    );
  }
}
