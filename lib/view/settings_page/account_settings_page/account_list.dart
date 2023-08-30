import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AccountListPage extends ConsumerWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("アカウント設定"),
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
                return ReorderableDragStartListener(
                  key: Key("$index"),
                  index: index,
                  child: ListTile(
                    leading: AvatarIcon.fromIResponse(account.i),
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
                                content: const Text("ほんまに削除してええな？"),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("やっぱりせえへん"),
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
                                    child: const Text("ええで"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Icon(Icons.drag_handle),
                      ],
                    ),
                  ),
                );
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
                child: const Text("アカウント設定をおわる"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
