import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/futable_list_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class UsersListPage extends ConsumerWidget {
  final Account account;

  const UsersListPage(this.account, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("リスト")),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: FutureListView(
          future: ref.read(misskeyProvider(account)).users.list.list(),
          builder: (context, item) => ListTile(
            onTap: () => context.pushRoute(
              UsersListTimelineRoute(
                account: account,
                list: item,
              ),
            ),
            title: Text(item.name ?? ""),
          ),
        ),
      ),
    );
  }
}
