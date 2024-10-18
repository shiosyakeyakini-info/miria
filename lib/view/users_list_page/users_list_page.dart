import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/users_list_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/user_list_page/users_lists_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";

@RoutePage()
class UsersListPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const UsersListPage(this.accountContext, {super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(usersListsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).list),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final settings = await context.pushRoute<UsersListSettings>(
                UsersListSettingsRoute(title: Text(S.of(context).create)),
              );
              if (settings == null) return;
              await ref
                  .read(usersListsNotifierProvider.notifier)
                  .create(settings);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: list.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final list = data[index];
                return ListTile(
                  title: Text(list.name ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async => ref
                        .read(usersListsNotifierProvider.notifier)
                        .delete(list.id),
                  ),
                  onTap: () async => context.pushRoute(
                    UsersListTimelineRoute(
                      accountContext: ref.read(accountContextProvider),
                      list: list,
                    ),
                  ),
                );
              },
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
