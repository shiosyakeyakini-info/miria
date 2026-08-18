import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "muted_users_notifier.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class MutedUsersNotifier extends _$MutedUsersNotifier {
  /// 一覧そのものは `PushableListView` が持つので、ここでは状態を持たない。
  @override
  void build() {}

  /// ミュート済みユーザーを1ページ分取得する。
  ///
  /// `mute/list` は `untilId` に [Muting] の id を渡してページングする。
  /// ミュートされている側のユーザーIDではない。
  Future<List<Muting>> fetch({String? untilId}) async {
    final response = await ref
        .read(misskeyPostContextProvider)
        .mute
        .list(MuteListRequest(untilId: untilId));
    return response.toList();
  }

  /// ミュートを解除する。解除したら `true`。
  Future<bool> delete(Muting muting) async {
    var deleted = false;
    await ref.read(dialogStateProvider.notifier).guard(() async {
      final userName = muting.mutee.name ?? muting.mutee.username;
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
            .delete(MuteDeleteRequest(userId: muting.muteeId));
        deleted = true;
      }
    });
    return deleted;
  }
}
