import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            title: Text(S.of(context).generalSettings),
            onTap: () => context.pushRoute(const GeneralSettingsRoute()),
          ),
          ListTile(
            title: Text(S.of(context).accountSettings),
            onTap: () => context.pushRoute(const AccountListRoute()),
          ),
          ListTile(
            title: Text(S.of(context).tabSettings),
            onTap: () => context.pushRoute(const TabSettingsListRoute()),
          ),
          ListTile(
            title: Text(S.of(context).settingsImportAndExport),
            onTap: () => context.pushRoute(const ImportExportRoute()),
          ),
          ListTile(
            title: Text(S.of(context).aboutMiria),
            onTap: () => context.pushRoute(const AppInfoRoute()),
          )
        ],
      ),
    );
  }
}
