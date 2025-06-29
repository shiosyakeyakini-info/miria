import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "muted_users_notifier.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class MutedUsersNotifier extends _$MutedUsersNotifier {
  @override
  Future<List<Muting>> build() async {
    final response = await ref
        .read(misskeyPostContextProvider)
        .mute
        .list(const MuteListRequest());
    return response.toList();
  }

  Future<void> delete(String userId) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref
          .read(misskeyPostContextProvider)
          .mute
          .delete(MuteDeleteRequest(userId: userId));
      state = AsyncValue.data([
        ...?state.value?.where((e) => e.muteeId != userId),
      ]);
    });
  }
}
