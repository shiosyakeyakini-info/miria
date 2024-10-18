import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/antenna_page/antennas_notifier.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";

class AntennaList extends ConsumerWidget {
  const AntennaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antennas = ref.watch(antennasNotifierProvider);

    return switch (antennas) {
      AsyncData(value: final antennas) => ListView.builder(
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
                        .read(antennasNotifierProvider.notifier)
                        .delete(antenna.id);
                  }
                },
              ),
              onTap: () async => context.pushRoute(
                AntennaNotesRoute(
                  antenna: antenna,
                  accountContext: ref.read(accountContextProvider),
                ),
              ),
            );
          },
        ),
      AsyncError(error: final e, stackTrace: final st) =>
        Center(child: ErrorDetail(error: e, stackTrace: st)),
      AsyncLoading() => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
    };
  }
}
