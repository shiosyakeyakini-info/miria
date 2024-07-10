import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "clips_notifier.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class ClipsNotifier extends _$ClipsNotifier {
  @override
  Future<List<Clip>> build() async {
    final response = await ref.read(misskeyPostContextProvider).clips.list();
    return response.toList();
  }

  Future<void> create(ClipSettings settings) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      final list = await ref.read(misskeyPostContextProvider).clips.create(
            ClipsCreateRequest(
              name: settings.name,
              description: settings.description,
              isPublic: settings.isPublic,
            ),
          );
      state = AsyncValue.data([...?state.valueOrNull, list]);
    });
  }

  Future<void> delete(String clipId) async {
    final result =
        await ref.read(dialogStateNotifierProvider.notifier).showDialog(
              message: (context) => S.of(context).confirmDeleteClip,
              actions: (context) =>
                  [S.of(context).willDelete, S.of(context).cancel],
            );
    if (result != 0) return;

    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref
          .read(misskeyPostContextProvider)
          .clips
          .delete(ClipsDeleteRequest(clipId: clipId));
      state = AsyncValue.data(
        [...?state.valueOrNull?.where((e) => e.id != clipId)],
      );
    });
  }

  Future<void> updateClip(
    String clipId,
    ClipSettings settings,
  ) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      final clip = await ref.read(misskeyPostContextProvider).clips.update(
            ClipsUpdateRequest(
              clipId: clipId,
              name: settings.name,
              description: settings.description,
              isPublic: settings.isPublic,
            ),
          );
      state = AsyncValue.data([
        for (final e in [...?state.valueOrNull]) e.id == clipId ? clip : e,
      ]);
    });
  }
}
