import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/users_list_settings.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UsersListsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<UsersList>, Misskey> {
  @override
  Future<List<UsersList>> build(Misskey arg) async {
    final response = await _misskey.users.list.list();
    return response.toList();
  }

  Misskey get _misskey => arg;

  Future<void> create(UsersListSettings settings) async {
    final list = await _misskey.users.list.create(
      UsersListsCreateRequest(
        name: settings.name,
      ),
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
  }

  Future<void> delete(String listId) async {
    await _misskey.users.list.delete(UsersListsDeleteRequest(listId: listId));
    state = AsyncValue.data(
      state.valueOrNull?.where((e) => e.id != listId).toList() ?? [],
    );
  }

  Future<void> push(
    String listId,
    User user,
  ) async {
    await _misskey.users.list.push(
      UsersListsPushRequest(
        listId: listId,
        userId: user.id,
      ),
    );
    state = AsyncValue.data(
      state.valueOrNull
              ?.map(
                (list) => (list.id == listId)
                    ? list.copyWith(
                        userIds: [...list.userIds, user.id],
                      )
                    : list,
              )
              .toList() ??
          [],
    );
  }

  Future<void> pull(
    String listId,
    User user,
  ) async {
    await _misskey.users.list.pull(
      UsersListsPullRequest(
        listId: listId,
        userId: user.id,
      ),
    );
    state = AsyncValue.data(
      state.valueOrNull
              ?.map(
                (list) => (list.id == listId)
                    ? list.copyWith(
                        userIds: list.userIds
                            .where((userId) => userId != user.id)
                            .toList(),
                      )
                    : list,
              )
              .toList() ??
          [],
    );
  }
}
