import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/router/app_router.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: const Text("全般設定"),
            leading: const Icon(Icons.settings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushRoute(const GeneralSettingsRoute()),
          ),
          ListTile(
            title: const Text("アカウント設定"),
            leading: const Icon(Icons.account_circle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushRoute(const AccountListRoute()),
          ),
          ListTile(
            title: const Text("タブ設定"),
            leading: const Icon(Icons.tab),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushRoute(const TabSettingsListRoute()),
          ),
          ListTile(
            title: const Text("設定のインポート・エクスポート"),
            leading: const Icon(Icons.import_export),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushRoute(const ImportExportRoute()),
          ),
          ListTile(
            title: const Text("このアプリについて"),
            leading: const Icon(Icons.info),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushRoute(const AppInfoRoute()),
          )
        ],
      ),
    );
  }
}
