import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AntennaList extends ConsumerWidget {
  const AntennaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    final misskey = ref.watch(misskeyProvider(account));
    final antennas = ref.watch(antennasNotifierProvider(misskey));

    return antennas.when(
      data: (antennas) {
        return ListView.builder(
          itemCount: antennas.length,
          itemBuilder: (context, index) {
            final antenna = antennas[index];
            return ListTile(
              title: Text(antenna.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final result = await SimpleConfirmDialog.show(
                    context: context,
                    message: S.of(context).confirmDeletingAntenna,
                    primary: S.of(context).delete,
                    secondary: S.of(context).cancel,
                  );
                  if (!context.mounted) return;
                  if (result ?? false) {
                    await ref
                        .read(
                          antennasNotifierProvider(misskey).notifier,
                        )
                        .delete(antenna.id)
                        .expectFailure(context);
                  }
                },
              ),
              onTap: () => context.pushRoute(
                AntennaNotesRoute(
                  antenna: antenna,
                  account: account,
                ),
              ),
            );
          },
        );
      },
      error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
