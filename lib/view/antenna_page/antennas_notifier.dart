import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/antenna_settings.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/experimental/mutation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "antennas_notifier.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class AntennasNotifier extends _$AntennasNotifier {
  late final _misskey = ref.read(misskeyPostContextProvider);

  @override
  Future<List<Antenna>> build() async {
    final response = await _misskey.antennas.list();
    return response.toList();
  }

  @mutation
  Future<void> createAntenna(AntennaSettings settings) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      final antenna = await _misskey.antennas.create(
        AntennasCreateRequest(
          name: settings.name,
          src: settings.src,
          keywords: settings.keywords,
          excludeKeywords: settings.excludeKeywords,
          users: settings.users,
          caseSensitive: settings.caseSensitive,
          withReplies: settings.withReplies,
          withFile: settings.withFile,
          notify: settings.notify,
          localOnly: settings.localOnly,
        ),
      );
      state = AsyncValue.data([...?state.value, antenna]);
    });
  }

  @mutation
  Future<void> deleteAntenna(String antennaId) async {
    final result = await ref
        .read(dialogStateNotifierProvider.notifier)
        .showDialog(
          message: (context) => S.of(context).confirmDeletingAntenna,
          actions: (context) => [S.of(context).delete, S.of(context).cancel],
        );

    if (result != 0) return;

    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await _misskey.antennas.delete(
        AntennasDeleteRequest(antennaId: antennaId),
      );
      state = AsyncValue.data([
        ...?state.value?.where((e) => e.id != antennaId),
      ]);
    });
  }

  @mutation
  Future<void> updateAntenna(String antennaId, AntennaSettings settings) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await _misskey.antennas.update(
        AntennasUpdateRequest(
          antennaId: antennaId,
          name: settings.name,
          src: settings.src,
          keywords: settings.keywords,
          excludeKeywords: settings.excludeKeywords,
          users: settings.users,
          caseSensitive: settings.caseSensitive,
          withReplies: settings.withReplies,
          withFile: settings.withFile,
          notify: settings.notify,
          localOnly: settings.localOnly,
        ),
      );
    });

    state = AsyncValue.data([
      for (final antenna in [...?state.value])
        antenna.id == antennaId
            ? antenna.copyWith(
                name: settings.name,
                src: settings.src,
                keywords: settings.keywords,
                excludeKeywords: settings.excludeKeywords,
                users: settings.users,
                caseSensitive: settings.caseSensitive,
                withReplies: settings.withReplies,
                withFile: settings.withFile,
                notify: settings.notify,
                localOnly: settings.localOnly,
              )
            : antenna,
    ]);
  }
}
