import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/user_page/user_list_item.dart';
import 'package:miria/view/user_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

final _usersListNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    _UsersListNotifier, UsersList, (Misskey, String)>(_UsersListNotifier.new);

class _UsersListNotifier
    extends AutoDisposeFamilyAsyncNotifier<UsersList, (Misskey, String)> {
  @override
  Future<UsersList> build((Misskey, String) arg) {
    return _misskey.users.list.show(
      UsersListsShowRequest(listId: _listId),
    );
  }

  Misskey get _misskey => arg.$1;

  String get _listId => arg.$2;
}

final _usersListUsersProvider = AutoDisposeAsyncNotifierProviderFamily<
    _UsersListUsers, List<User>, (Misskey, String)>(
  _UsersListUsers.new,
);

class _UsersListUsers
    extends AutoDisposeFamilyAsyncNotifier<List<User>, (Misskey, String)> {
  @override
  Future<List<User>> build((Misskey, String) arg) async {
    final list = await ref.watch(_usersListNotifierProvider(arg).future);
    final response = await _misskey.users.showByIds(
      UsersShowByIdsRequest(
        userIds: list.userIds,
      ),
    );
    return response.map((e) => e.toUser()).toList();
  }

  Misskey get _misskey => arg.$1;

  String get _listId => arg.$2;

  Future<void> push(User user) async {
    await _misskey.users.list.push(
      UsersListsPushRequest(
        listId: _listId,
        userId: user.id,
      ),
    );
    state = AsyncValue.data([...?state.valueOrNull, user]);
  }

  Future<void> pull(User user) async {
    await _misskey.users.list.pull(
      UsersListsPullRequest(
        listId: _listId,
        userId: user.id,
      ),
    );
    state = AsyncValue.data(
      state.valueOrNull?.where((e) => e.id != user.id).toList() ?? [],
    );
  }
}

@RoutePage()
class UsersListDetailPage extends ConsumerWidget {
  const UsersListDetailPage({
    super.key,
    required this.account,
    required this.listId,
  });

  final Account account;
  final String listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final arg = (misskey, listId);
    final list = ref.watch(_usersListNotifierProvider(arg));
    final users = ref.watch(_usersListUsersProvider(arg));

    return Scaffold(
      appBar: AppBar(
        title: list.whenOrNull(data: (list) => Text(list.name ?? "")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: users.when(
          data: (users) {
            return AccountScope(
              account: account,
              child: Column(
                children: [
                  ListTile(
                    title: const Text("メンバー"),
                    subtitle: Text(
                      "${users.length}/${account.i.policies.userEachUserListsLimit} 人",
                    ),
                    trailing: ElevatedButton(
                      child: const Text("ユーザーを追加"),
                      onPressed: () async {
                        final user = await showDialog<User>(
                          context: context,
                          builder: (context) =>
                              UserSelectDialog(account: account),
                        );
                        if (user == null) {
                          return;
                        }
                        if (!context.mounted) return;
                        await ref
                            .read(_usersListUsersProvider(arg).notifier)
                            .push(user)
                            .expectFailure(context);
                      },
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Row(
                          children: [
                            Expanded(
                              child: UserListItem(user: user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () async {
                                final result = await SimpleConfirmDialog.show(
                                  context: context,
                                  message: "このユーザーをリストから外しますか？",
                                  primary: "外す",
                                  secondary: "やめる",
                                );
                                if (!context.mounted) return;
                                if (result ?? false) {
                                  await ref
                                      .read(
                                        _usersListUsersProvider(arg).notifier,
                                      )
                                      .pull(user)
                                      .expectFailure(context);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (e, st) =>
              Center(child: ErrorDetail(error: e, stackTrace: st)),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
