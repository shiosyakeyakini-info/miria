import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/several_account_settings_page/word_mute_page/word_mute_page.dart';

@RoutePage()
class SeveralAccountSettingsPage extends StatelessWidget {
  final Account account;

  const SeveralAccountSettingsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${account.i.name ?? account.i.username} の設定")),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              context.pushRoute(SeveralAccountGeneralSettingsRoute(account: account));
            },
            title: const Text("全般設定"),
            leading: const Icon(Icons.settings),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(ReactionDeckRoute(account: account));
            },
            title: const Text("リアクションデッキ"),
            // ハートのアイコン
            leading: const Icon(Icons.favorite),
            trailing: const Icon(Icons.chevron_right),
          ),
          // ListTile(onTap: () {}, title: const Text("ソフトミュート")),
          ListTile(
            onTap: () {
              context.pushRoute(WordMuteRoute(account: account, muteType: MuteType.soft));
            },
            title: const Text("ワードミュート"),
            leading: const Icon(Icons.comments_disabled),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(WordMuteRoute(account: account, muteType: MuteType.hard));
            },
            title: const Text("ハードワードミュート"),
            leading: const Icon(Icons.comments_disabled),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(InstanceMuteRoute(account: account));
            },
            title: const Text("インスタンスミュート"),
            leading: const Icon(Icons.visibility_off),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(CacheManagementRoute(account: account));
            },
            title: const Text("キャッシュ設定"),
            leading: const Icon(Icons.cached),
            trailing: const Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}
