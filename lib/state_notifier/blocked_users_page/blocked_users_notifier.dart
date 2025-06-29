import "package:miria/l10n/app_localizations.dart";
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
      // ユーザー名を取得
      final user = state.value?.firstWhere((e) => e.blockeeId == userId);
      final userName = user?.blockee.name ?? user?.blockee.username ?? "";

      final result = await ref
          .read(dialogStateNotifierProvider.notifier)
          .showDialog(
            message: (context) => S.of(context).confirmUnblockUser(userName),
            actions: (context) => [S.of(context).unblock, S.of(context).cancel],
          );

      if (result == 0) {
        await ref
            .read(misskeyPostContextProvider)
            .blocking
            .delete(BlockDeleteRequest(userId: userId));
        state = AsyncValue.data([
          ...?state.value?.where((e) => e.blockeeId != userId),
        ]);
      }
    });
  }
}
