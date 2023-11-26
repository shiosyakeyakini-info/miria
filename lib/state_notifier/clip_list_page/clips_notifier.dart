import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/clip_settings.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ClipsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Clip>, Misskey> {
  @override
  Future<List<Clip>> build(Misskey arg) async {
    final response = await _misskey.clips.list();
    return response.toList();
  }

  Misskey get _misskey => arg;

  Future<void> create(ClipSettings settings) async {
    final list = await _misskey.clips.create(
      ClipsCreateRequest(
        name: settings.name,
        description: settings.description,
        isPublic: settings.isPublic,
      ),
    );
    state = AsyncValue.data([...?state.valueOrNull, list]);
  }

  Future<void> delete(String clipId) async {
    await _misskey.clips.delete(ClipsDeleteRequest(clipId: clipId));
    state = AsyncValue.data(
      state.valueOrNull?.where((e) => e.id != clipId).toList() ?? [],
    );
  }

  Future<void> updateClip(
    String clipId,
    ClipSettings settings,
  ) async {
    final clip = await _misskey.clips.update(
      ClipsUpdateRequest(
        clipId: clipId,
        name: settings.name,
        description: settings.description,
        isPublic: settings.isPublic,
      ),
    );
    state = AsyncValue.data(
      state.valueOrNull
              ?.map(
                (e) => (e.id == clipId) ? clip : e,
              )
              .toList() ??
          [],
    );
  }
}
