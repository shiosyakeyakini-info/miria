import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/user_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/antenna_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/antenna_page/antenna_settings_dialog.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AntennaModalSheet extends ConsumerWidget {
  const AntennaModalSheet({
    super.key,
    required this.account,
    required this.user,
  });

  final Account account;
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final antennas = ref.watch(antennasNotifierProvider(misskey));

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
                        .read(antennasNotifierProvider(misskey).notifier)
                        .updateAntenna(
                          antenna.id,
                          AntennaSettings.fromAntenna(antenna).copyWith(
                            users: [...antenna.users, user.acct],
                          ),
                        )
                        .expectFailure(context);
                  } else {
                    await ref
                        .read(antennasNotifierProvider(misskey).notifier)
                        .updateAntenna(
                          antenna.id,
                          AntennaSettings.fromAntenna(antenna).copyWith(
                            users: antenna.users
                                .where((acct) => acct != user.acct)
                                .toList(),
                          ),
                        )
                        .expectFailure(context);
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
                        .read(antennasNotifierProvider(misskey).notifier)
                        .create(settings)
                        .expectFailure(context);
                  }
                },
              );
            }
          },
        );
      },
      error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
