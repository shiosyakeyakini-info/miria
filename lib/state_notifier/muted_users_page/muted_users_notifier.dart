import "package:miria/l10n/app_localizations.dart";
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
    await ref.read(dialogStateProvider.notifier).guard(() async {
      // ユーザー名を取得
      final user = state.value?.firstWhere((e) => e.muteeId == userId);
      final userName = user?.mutee.name ?? user?.mutee.username ?? "";

      final result = await ref
          .read(dialogStateProvider.notifier)
          .showDialog(
            message: (context) => S.of(context).confirmUnmuteUser(userName),
            actions: (context) => [S.of(context).unmute, S.of(context).cancel],
          );

      if (result == 0) {
        await ref
            .read(misskeyPostContextProvider)
            .mute
            .delete(MuteDeleteRequest(userId: userId));
        state = AsyncValue.data([
          ...?state.value?.where((e) => e.muteeId != userId),
        ]);
      }
    });
  }
}
