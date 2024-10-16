import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/users_lists_show_response_extension.dart";
import "package:miria/model/users_list_settings.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/error_dialog_handler.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:miria/view/user_select_dialog.dart";
import "package:miria/view/users_list_page/users_list_settings_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";

final _usersListNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    _UsersListNotifier, UsersList, (Misskey, String)>(_UsersListNotifier.new);

class _UsersListNotifier
    extends AutoDisposeFamilyAsyncNotifier<UsersList, (Misskey, String)> {
  @override
  Future<UsersList> build((Misskey, String) arg) async {
    final response = await _misskey.users.list.show(
      UsersListsShowRequest(listId: _listId),
    );
    return response.toUsersList();
  }

  Misskey get _misskey => arg.$1;

  String get _listId => arg.$2;

  Future<void> updateList(UsersListSettings settings) async {
    await _misskey.users.list.update(
      UsersListsUpdateRequest(
        listId: _listId,
        name: settings.name,
        isPublic: settings.isPublic,
      ),
    );
    final list = state.valueOrNull;
    if (list != null) {
      state = AsyncValue.data(
        list.copyWith(
          name: settings.name,
          isPublic: settings.isPublic,
        ),
      );
    }
  }
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
    return response.toList();
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
class UsersListDetailPage extends ConsumerWidget implements AutoRouteWrapper {
  const UsersListDetailPage({
    required this.accountContext,
    required this.listId,
    super.key,
  });

  final AccountContext accountContext;
  final String listId;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyGetContextProvider);
    final arg = (misskey, listId);
    final list = ref.watch(_usersListNotifierProvider(arg));
    final users = ref.watch(_usersListUsersProvider(arg));

    return Scaffold(
      appBar: list.maybeWhen(
        data: (list) => AppBar(
          title: Text(list.name ?? ""),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final settings = await showDialog<UsersListSettings>(
                  context: context,
                  builder: (context) => UsersListSettingsDialog(
                    title: Text(S.of(context).edit),
                    initialSettings: UsersListSettings.fromUsersList(list),
                  ),
                );
                if (!context.mounted) return;
                if (settings != null) {
                  await ref
                      .read(_usersListNotifierProvider(arg).notifier)
                      .updateList(settings)
                      .expectFailure(context);
                }
              },
            ),
          ],
        ),
        orElse: () => AppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: users.when(
          data: (users) {
            return Column(
              children: [
                ListTile(
                  title: Text(S.of(context).members),
                  subtitle: Text(
                    S.of(context).listCapacity(
                          users.length,
                          accountContext
                              .postAccount.i.policies.userEachUserListsLimit,
                        ),
                  ),
                  trailing: ElevatedButton(
                    child: Text(S.of(context).addUser),
                    onPressed: () async {
                      final user = await showDialog<User>(
                        context: context,
                        builder: (context) => UserSelectDialog(
                          accountContext: accountContext,
                        ),
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
                                message: S.of(context).confirmRemoveUser,
                                primary: S.of(context).removeUser,
                                secondary: S.of(context).cancel,
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
            );
          },
          error: (e, st) =>
              Center(child: ErrorDetail(error: e, stackTrace: st)),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }
}
