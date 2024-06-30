import "package:miria/model/users_list_settings.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

part "users_lists_notifier.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class UsersListsNotifier extends _$UsersListsNotifier {
  late final _misskey = ref.read(misskeyPostContextProvider);

  @override
  Future<List<UsersList>> build() async {
    final response = await _misskey.users.list.list();
    return response.toList();
  }

  Future<void> create(UsersListSettings settings) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      final list = await _misskey.users.list.create(
        UsersListsCreateRequest(name: settings.name),
      );
      if (settings.isPublic) {
        await _misskey.users.list.update(
          UsersListsUpdateRequest(
            listId: list.id,
            isPublic: settings.isPublic,
          ),
        );
      }
      state = AsyncValue.data([...?state.valueOrNull, list]);
    });
  }

  Future<void> delete(String listId) async {
    final result =
        await ref.read(dialogStateNotifierProvider.notifier).showDialog(
              message: (context) => S.of(context).confirmDeleteList,
              actions: (context) => [
                S.of(context).doDeleting,
                S.of(context).cancel,
              ],
            );
    if (result != 0) return;

    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await _misskey.users.list.delete(UsersListsDeleteRequest(listId: listId));
      state = AsyncValue.data(
        [...?state.valueOrNull?.where((e) => e.id != listId)],
      );
    });
  }

  Future<void> push(
    String listId,
    User user,
  ) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(
      () async {
        await _misskey.users.list.push(
          UsersListsPushRequest(
            listId: listId,
            userId: user.id,
          ),
        );
        state = AsyncValue.data(
          [
            for (final list in [...?state.valueOrNull])
              list.id == listId
                  ? list.copyWith(userIds: [...list.userIds, user.id])
                  : list,
          ],
        );
      },
    );
  }

  Future<void> pull(
    String listId,
    User user,
  ) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await _misskey.users.list.pull(
        UsersListsPullRequest(
          listId: listId,
          userId: user.id,
        ),
      );
      state = AsyncValue.data([
        for (final list in [...?state.valueOrNull])
          list.id == listId
              ? list.copyWith(
                  userIds: [
                    ...list.userIds.where((userId) => userId != user.id),
                  ],
                )
              : list,
      ]);
    });
  }
}
