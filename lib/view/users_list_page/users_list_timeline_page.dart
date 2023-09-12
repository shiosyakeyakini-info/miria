import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/users_list_page/users_list_timeline.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class UsersListTimelinePage extends ConsumerWidget {
  final Account account;
  final UsersList list;

  const UsersListTimelinePage(this.account, this.list, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(list.name ?? ""),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => context.pushRoute(
              UsersListDetailRoute(
                account: account,
                listId: list.id,
              ),
            ),
          ),
        ],
      ),
      body: AccountScope(
        account: account,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: UsersListTimeline(listId: list.id),
        ),
      ),
    );
  }
}
