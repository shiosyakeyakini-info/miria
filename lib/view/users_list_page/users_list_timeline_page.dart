import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/users_list_page/users_list_timeline.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class UsersListTimelinePage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final UsersList list;

  const UsersListTimelinePage(this.accountContext, this.list, {super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(list.name ?? ""),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () async => context.pushRoute(
              UsersListDetailRoute(
                accountContext: accountContext,
                listId: list.id,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: UsersListTimeline(listId: list.id),
      ),
    );
  }
}
