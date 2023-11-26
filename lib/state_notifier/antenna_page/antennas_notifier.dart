import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/antenna_settings.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AntennasNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Antenna>, Misskey> {
  @override
  Future<List<Antenna>> build(Misskey arg) async {
    final response = await _misskey.antennas.list();
    return response.toList();
  }

  Misskey get _misskey => arg;

  Future<void> create(AntennaSettings settings) async {
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
    state = AsyncValue.data([...?state.valueOrNull, antenna]);
  }

  Future<void> delete(String antennaId) async {
    await _misskey.antennas.delete(AntennasDeleteRequest(antennaId: antennaId));
    state = AsyncValue.data(
      state.valueOrNull?.where((e) => e.id != antennaId).toList() ?? [],
    );
  }

  Future<void> updateAntenna(
    String antennaId,
    AntennaSettings settings,
  ) async {
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
    state = AsyncValue.data(
      state.valueOrNull
              ?.map(
                (antenna) => (antenna.id == antennaId)
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
              )
              .toList() ??
          [],
    );
  }
}
