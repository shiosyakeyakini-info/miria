import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/users_list_settings.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/user_list_page/users_lists_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class UsersListModalSheet extends ConsumerWidget implements AutoRouteWrapper {
  const UsersListModalSheet({
    required this.account,
    required this.user,
    super.key,
  });

  final Account account;
  final User user;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(usersListsNotifierProvider);

    return lists.when(
      data: (lists) {
        return ListView.builder(
          itemCount: lists.length + 1,
          itemBuilder: (context, index) {
            if (index < lists.length) {
              final list = lists[index];
              return CheckboxListTile(
                value: list.userIds.contains(user.id),
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  if (value) {
                    await ref
                        .read(usersListsNotifierProvider.notifier)
                        .push(list.id, user);
                  } else {
                    await ref
                        .read(usersListsNotifierProvider.notifier)
                        .pull(list.id, user);
                  }
                },
                title: Text(list.name ?? ""),
              );
            } else {
              return ListTile(
                leading: const Icon(Icons.add),
                title: Text(S.of(context).createList),
                onTap: () async {
                  final settings = await context.pushRoute<UsersListSettings>(
                    UsersListSettingsRoute(title: Text(S.of(context).create)),
                  );
                  if (!context.mounted) return;
                  if (settings == null) return;
                  await ref
                      .read(usersListsNotifierProvider.notifier)
                      .create(settings);
                },
              );
            }
          },
        );
      },
      error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
