import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "blocked_users_notifier.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class BlockedUsersNotifier extends _$BlockedUsersNotifier {
  @override
  Future<List<Blocking>> build() async {
    final response = await ref
        .read(misskeyPostContextProvider)
        .blocking
        .list(const BlockingListRequest());
    return response.toList();
  }

  Future<void> delete(String userId) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref
          .read(misskeyPostContextProvider)
          .blocking
          .delete(BlockDeleteRequest(userId: userId));
      state = AsyncValue.data([
        ...?state.value?.where((e) => e.blockeeId != userId),
      ]);
    });
  }
}
