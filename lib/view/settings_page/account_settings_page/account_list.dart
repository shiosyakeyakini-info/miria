import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AccountListPage extends ConsumerStatefulWidget {
  const AccountListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AccountListPageState();
}

class AccountListPageState extends ConsumerState<AccountListPage> {
  @override
  Widget build(BuildContext context) {
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
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) => ListTile(
                leading: AvatarIcon.fromIResponse(accounts[index].i),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: const Text("ほんまに削除してええな？"),
                            actions: [
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("やっぱりせえへん")),
                              ElevatedButton(
                                  onPressed: () async {
                                    await ref
                                        .read(
                                          accountRepositoryProvider.notifier,
                                        )
                                        .remove(accounts[index]);
                                    if (!mounted) return;
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("ええで"))
                            ],
                          ));
                },
                title: Text(
                    accounts[index].i.name ?? accounts[index].i.username,
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  "@${accounts[index].userId}@${accounts[index].host}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
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
                  child: const Text("アカウント設定をおわる")),
            ),
          )
        ],
      ),
    );
  }
}
