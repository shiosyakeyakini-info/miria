import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/antenna_page/antennas_notifier.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/experimental/mutation.dart";

class AntennaList extends ConsumerWidget {
  const AntennaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antennas = ref.watch(antennasNotifierProvider);

    return switch (antennas) {
      AsyncData(value: final antennas) => ListView.builder(
        itemCount: antennas.length,
        itemBuilder: (context, index) =>
            AntennaListItem(antenna: antennas[index]),
      ),
      AsyncError(error: final e, stackTrace: final st) => Center(
        child: ErrorDetail(error: e, stackTrace: st),
      ),
      AsyncLoading() => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    };
  }
}

class AntennaListItem extends ConsumerWidget {
  final Antenna antenna;

  const AntennaListItem({required this.antenna, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteAntenna = ref.watch(antennasNotifierProvider.deleteAntenna);

    return ListTile(
      title: Text(antenna.name),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: deleteAntenna is PendingMutation
            ? null
            : () async => deleteAntenna.call(antenna.id),
      ),
    );
  }
}
