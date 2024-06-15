import "package:miria/model/users_list_settings.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "users_lists_notifier.g.dart";

@riverpod
class UsersListsNotifier extends _$UsersListsNotifier {
  @override
  Future<List<UsersList>> build(Misskey misskey) async {
    final response = await misskey.users.list.list();
    return response.toList();
  }

  Future<void> create(UsersListSettings settings) async {
    final list = await misskey.users.list.create(
      UsersListsCreateRequest(
        name: settings.name,
      ),
    );
    if (settings.isPublic) {
      await misskey.users.list.update(
        UsersListsUpdateRequest(
          listId: list.id,
          isPublic: settings.isPublic,
        ),
      );
    }
    state = AsyncValue.data([...?state.valueOrNull, list]);
  }

  Future<void> delete(String listId) async {
    await misskey.users.list.delete(UsersListsDeleteRequest(listId: listId));
    state = AsyncValue.data(
      [...?state.valueOrNull?.where((e) => e.id != listId)],
    );
  }

  Future<void> push(
    String listId,
    User user,
  ) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(
      () async {
        await misskey.users.list.push(
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
    await misskey.users.list.pull(
      UsersListsPullRequest(
        listId: listId,
        userId: user.id,
      ),
    );
    state = AsyncValue.data([
      for (final list in [...?state.valueOrNull])
        list.id == listId
            ? list.copyWith(
                userIds: [...list.userIds.where((userId) => userId != user.id)],
              )
            : list,
    ]);
  }
}
