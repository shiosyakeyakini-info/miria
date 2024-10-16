import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/user_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/model/antenna_settings.dart";
import "package:miria/view/antenna_page/antenna_settings_dialog.dart";
import "package:miria/view/antenna_page/antennas_notifier.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class AntennaModalSheet extends ConsumerWidget {
  const AntennaModalSheet({
    required this.account,
    required this.user,
    super.key,
  });

  final Account account;
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antennas = ref.watch(antennasNotifierProvider);

    return antennas.when(
      data: (antennas) {
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
                          AntennaSettings.fromAntenna(antenna).copyWith(
                            users: [...antenna.users, user.acct],
                          ),
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
              return ListTile(
                leading: const Icon(Icons.add),
                title: Text(S.of(context).createAntenna),
                onTap: () async {
                  final settings = await showDialog<AntennaSettings>(
                    context: context,
                    builder: (context) => AntennaSettingsDialog(
                      title: Text(S.of(context).create),
                      initialSettings: const AntennaSettings(
                        src: AntennaSource.users,
                      ),
                      account: account,
                    ),
                  );
                  if (!context.mounted) return;
                  if (settings != null) {
                    await ref
                        .read(antennasNotifierProvider.notifier)
                        .create(settings);
                  }
                },
              );
            }
          },
        );
      },
      error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
