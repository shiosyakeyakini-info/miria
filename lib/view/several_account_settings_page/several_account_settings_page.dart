import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/router/app_router.dart';

@RoutePage()
class SeveralAccountSettingsPage extends StatelessWidget {
  final Account account;

  const SeveralAccountSettingsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("${account.i.name ?? account.i.username} の設定")),
      body: ListView(
        children: [
          ListTile(
              onTap: () {
                context.pushRoute(ReactionDeckRoute(account: account));
              },
              title: const Text("リアクションデッキ")),
          // ListTile(onTap: () {}, title: const Text("ソフトミュート")),
          ListTile(
            onTap: () {
              context.pushRoute(HardMuteRoute(account: account));
            },
            title: const Text("ハードミュート"),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(InstanceMuteRoute(account: account));
            },
            title: const Text("インスタンスミュート"),
          )
        ],
      ),
    );
  }
}
