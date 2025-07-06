import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/users_lists_show_response_extension.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/users_list_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "users_list_detail_page.g.dart";

@riverpod
class _UsersListNotifier extends _$UsersListNotifier {
  @override
  Future<UsersList> build(Misskey misskey, String listId) async {
    final response = await misskey.users.list.show(
      UsersListsShowRequest(listId: listId),
    );
    return response.toUsersList();
  }

  Future<void> updateList(
    UsersListSettings settings,
    Misskey misskey,
    String listId,
  ) async {
    await misskey.users.list.update(
      UsersListsUpdateRequest(
        listId: listId,
        name: settings.name,
        isPublic: settings.isPublic,
      ),
    );
    final list = state.value;
    if (list != null) {
      state = AsyncValue.data(
        list.copyWith(name: settings.name, isPublic: settings.isPublic),
      );
    }
  }
}

@riverpod
class _UsersListUsers extends _$UsersListUsers {
  @override
  Future<List<User>> build(Misskey misskey, String listId) async {
    final list = await ref.watch(
      _usersListNotifierProvider(misskey, listId).future,
    );
    final response = await misskey.users.showByIds(
      UsersShowByIdsRequest(userIds: list.userIds),
    );
    return response.toList();
  }

  Future<void> push(User user, Misskey misskey, String listId) async {
    await misskey.users.list.push(
      UsersListsPushRequest(listId: listId, userId: user.id),
    );
    state = AsyncValue.data([...?state.value, user]);
  }

  Future<void> pull(User user, Misskey misskey, String listId) async {
    await misskey.users.list.pull(
      UsersListsPullRequest(listId: listId, userId: user.id),
    );
    state = AsyncValue.data(
      state.value?.where((e) => e.id != user.id).toList() ?? [],
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
    final list = ref.watch(_usersListNotifierProvider(misskey, listId));
    final users = ref.watch(_usersListUsersProvider(misskey, listId));

    return Scaffold(
      appBar: list.maybeWhen(
        data: (list) => AppBar(
          title: Text(list.name ?? ""),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final settings = await context.pushRoute<UsersListSettings>(
                  UsersListSettingsRoute(
                    title: Text(S.of(context).edit),
                    initialSettings: UsersListSettings.fromUsersList(list),
                  ),
                );
                if (!context.mounted) return;
                if (settings == null) return;

                await ref.read(dialogStateNotifierProvider.notifier).guard(
                  () async {
                    await ref
                        .read(
                          _usersListNotifierProvider(misskey, listId).notifier,
                        )
                        .updateList(settings, misskey, listId);
                  },
                );
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
                    S
                        .of(context)
                        .listCapacity(
                          users.length,
                          accountContext
                              .postAccount
                              .i
                              .policies
                              .userEachUserListsLimit,
                        ),
                  ),
                  trailing: ElevatedButton(
                    child: Text(S.of(context).addUser),
                    onPressed: () async {
                      final user = await context.pushRoute<User>(
                        UserSelectRoute(accountContext: accountContext),
                      );
                      if (user == null) return;
                      if (!context.mounted) return;
                      await ref
                          .read(dialogStateNotifierProvider.notifier)
                          .guard(() async {
                            await ref
                                .read(
                                  _usersListUsersProvider(
                                    misskey,
                                    listId,
                                  ).notifier,
                                )
                                .push(user, misskey, listId);
                          });
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
                          Expanded(child: UserListItem(user: user)),
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
                                    .read(dialogStateNotifierProvider.notifier)
                                    .guard(() async {
                                      await ref
                                          .read(
                                            _usersListUsersProvider(
                                              misskey,
                                              listId,
                                            ).notifier,
                                          )
                                          .pull(user, misskey, listId);
                                    });
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
          error: (e, st) => Center(
            child: ErrorDetail(error: e, stackTrace: st),
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}
