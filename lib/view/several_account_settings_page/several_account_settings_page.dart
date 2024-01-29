import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      appBar: AppBar(
        title: Text(
          S.of(context).accountSetting(account.i.name ?? account.i.username),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              context.pushRoute(
                  SeveralAccountGeneralSettingsRoute(account: account));
            },
            title: Text(S.of(context).generalSettings),
            leading: const Icon(Icons.settings),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(ReactionDeckRoute(account: account));
            },
            title: Text(S.of(context).reactionDeck),
            leading: const Icon(Icons.favorite),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(
                  WordMuteRoute(account: account, muteType: MuteType.soft));
            },
            title: Text(S.of(context).wordMute),
            leading: const Icon(Icons.comments_disabled),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(
                  WordMuteRoute(account: account, muteType: MuteType.hard));
            },
            title: Text(S.of(context).hardWordMute),
            leading: const Icon(Icons.comments_disabled),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(InstanceMuteRoute(account: account));
            },
            title: Text(S.of(context).instanceMute),
            leading: const Icon(Icons.comments_disabled),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              context.pushRoute(CacheManagementRoute(account: account));
            },
            title: Text(S.of(context).cacheSettings),
            leading: const Icon(Icons.cached),
            trailing: const Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}
