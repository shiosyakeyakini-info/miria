import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/model/clip_settings.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "clips_notifier.g.dart";

@riverpod
class ClipsNotifier extends _$ClipsNotifier {
  @override
  Future<List<Clip>> build(Misskey misskey) async {
    final response = await misskey.clips.list();
    return response.toList();
  }

  Future<void> create(ClipSettings settings) async {
    final list = await misskey.clips.create(
      ClipsCreateRequest(
        name: settings.name,
        description: settings.description,
        isPublic: settings.isPublic,
      ),
    );
    state = AsyncValue.data([...?state.valueOrNull, list]);
  }

  Future<void> delete(String clipId) async {
    await misskey.clips.delete(ClipsDeleteRequest(clipId: clipId));
    state =
        AsyncValue.data([...?state.valueOrNull?.where((e) => e.id != clipId)]);
  }

  Future<void> updateClip(
    String clipId,
    ClipSettings settings,
  ) async {
    final clip = await misskey.clips.update(
      ClipsUpdateRequest(
        clipId: clipId,
        name: settings.name,
        description: settings.description,
        isPublic: settings.isPublic,
      ),
    );
    state = AsyncValue.data([
      for (final e in [...?state.valueOrNull]) e.id == clipId ? clip : e
    ]);
  }
}
