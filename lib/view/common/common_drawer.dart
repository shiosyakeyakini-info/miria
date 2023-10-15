import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/acct.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonDrawer extends ConsumerWidget {
  final Acct initialOpenAcct;

  const CommonDrawer({super.key, required this.initialOpenAcct});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            for (final account in accounts) ...[
              AccountScope(
                account: account,
                child: ExpansionTile(
                  leading: AvatarIcon(user: account.i),
                  initiallyExpanded: account.acct == initialOpenAcct,
                  title: SimpleMfmText(
                    account.i.name ?? account.i.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    account.acct.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(S.of(context).notification),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(NotificationRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.star),
                      title: Text(S.of(context).favorite),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(FavoritedNoteRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.list),
                      title: Text(S.of(context).list),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(UsersListRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_input_antenna),
                      title: Text(S.of(context).antenna),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(AntennaRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.attach_file),
                      title: Text(S.of(context).clip),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(ClipListRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.tv),
                      title: Text(S.of(context).channel),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(ChannelsRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.search),
                      title: Text(S.of(context).search),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(SearchRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.tag),
                      title: Text(S.of(context).explore),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(ExploreRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.gamepad),
                      title: Text(S.of(context).misskeyGames),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(MisskeyGamesRoute(account: account));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(S.of(context).accountSetting(
                          account.i.name ?? account.i.username)),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(
                          SeveralAccountSettingsRoute(account: account),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(S.of(context).settings),
              onTap: () {
                Navigator.of(context).pop();
                context.pushRoute(const SettingsRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}
