import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/user_extension.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/model/antenna_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/antenna_page/antennas_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/experimental/mutation.dart";

@RoutePage()
class AntennaModalSheet extends ConsumerWidget implements AutoRouteWrapper {
  const AntennaModalSheet({
    required this.account,
    required this.user,
    super.key,
  });

  final Account account;
  final User user;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antennas = ref.watch(antennasNotifierProvider);

    return switch (antennas) {
      AsyncError(:final error, :final stackTrace) => Center(
        child: ErrorDetail(error: error, stackTrace: stackTrace),
      ),
      AsyncLoading() => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      AsyncData(:final value) => _AntennaModalSheetBody(
        antennas: value,
        user: user,
      ),
    };
  }
}

class _AntennaModalSheetBody extends ConsumerWidget {
  final List<Antenna> antennas;
  final User user;
  const _AntennaModalSheetBody({required this.antennas, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAntennas = antennas.where(
      (antenna) => antenna.src == AntennaSource.users,
    );
    return ListView.builder(
      itemCount: usersAntennas.length + 1,
      itemBuilder: (context, index) {
        if (index < usersAntennas.length) {
          final antenna = usersAntennas.elementAt(index);
          return CheckboxListTile(
            value: antenna.users.contains(user.acct),
            onChanged: (value) async {
              if (value == null) {
                return;
              }
              if (value) {
                await ref
                    .read(antennasNotifierProvider.notifier)
                    .updateAntenna(
                      antenna.id,
                      AntennaSettings.fromAntenna(
                        antenna,
                      ).copyWith(users: [...antenna.users, user.acct]),
                    );
              } else {
                await ref
                    .read(antennasNotifierProvider.notifier)
                    .updateAntenna(
                      antenna.id,
                      AntennaSettings.fromAntenna(antenna).copyWith(
                        users: antenna.users
                            .where((acct) => acct != user.acct)
                            .toList(),
                      ),
                    );
              }
            },
            title: Text(antenna.name),
          );
        } else {
          return const _CreateAntennaTile();
        }
      },
    );
  }
}

class _CreateAntennaTile extends ConsumerWidget {
  const _CreateAntennaTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final create = ref.watch(antennasNotifierProvider.createAntenna);

    return ListTile(
      leading: const Icon(Icons.add),
      title: Text(S.of(context).createAntenna),
      onTap: create is PendingMutation
          ? null
          : () async {
              final settings = await context.pushRoute<AntennaSettings>(
                AntennaSettingsRoute(
                  title: Text(S.of(context).create),
                  initialSettings: const AntennaSettings(
                    src: AntennaSource.users,
                  ),
                  account: ref.read(accountContextProvider).postAccount,
                ),
              );
              if (!context.mounted) return;
              if (settings == null) return;
              await create.call(settings);
            },
    );
  }
}
