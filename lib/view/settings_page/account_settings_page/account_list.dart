import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/avatar_icon.dart';

@RoutePage()
class AccountListPage extends ConsumerWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).accountSettings),
        leading: Container(),
        actions: [
          IconButton(
            onPressed: () {
              context.pushRoute(const LoginRoute());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                if (Platform.isAndroid || Platform.isIOS) {
                  return ReorderableDelayedDragStartListener(
                    key: Key("$index"),
                    index: index,
                    child: AccountListItem(account),
                  );
                } else {
                  return ReorderableDragStartListener(
                    key: Key("$index"),
                    index: index,
                    child: AccountListItem(account),
                  );
                }
              },
              onReorder: ref.read(accountRepositoryProvider.notifier).reorder,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  context.router
                    ..removeWhere((route) => true)
                    ..push(const SplashRoute());
                },
                child: Text(S.of(context).quitAccountSettings),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountListItem extends ConsumerWidget {
  const AccountListItem(this.account, {super.key});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: AvatarIcon(user: account.i),
      title: Text(
        account.i.name ?? account.i.username,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        account.acct.toString(),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(S.of(context).confirmDelete),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(S.of(context).cancel),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(
                              accountRepositoryProvider.notifier,
                            )
                            .remove(account);
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: Text(S.of(context).doDeleting),
                    ),
                  ],
                ),
              );
            },
          ),
          const Icon(Icons.drag_handle),
        ],
      ),
    );
  }
}
