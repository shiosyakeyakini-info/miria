import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/acct.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";

class CommonDrawer extends ConsumerWidget {
  final Acct initialOpenAcct;

  const CommonDrawer({required this.initialOpenAcct, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            for (final account in accounts) ...[
              AccountContextScope.as(
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
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
                          NotificationRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.star),
                      title: Text(S.of(context).favorite),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
                          FavoritedNoteRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.list),
                      title: Text(S.of(context).list),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
                          UsersListRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_input_antenna),
                      title: Text(S.of(context).antenna),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
                          AntennaRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.attach_file),
                      title: Text(S.of(context).clip),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
                          ClipListRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.tv),
                      title: Text(S.of(context).channel),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
                          ChannelsRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.search),
                      title: Text(S.of(context).search),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(SearchRoute(
                            accountContext: AccountContext.as(account)));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.tag),
                      title: Text(S.of(context).explore),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
                          ExploreRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.gamepad),
                      title: Text(S.of(context).misskeyGames),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
                          MisskeyGamesRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(
                        S.of(context).accountSetting(
                              account.i.name ?? account.i.username,
                            ),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await context.pushRoute(
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
              onTap: () async {
                Navigator.of(context).pop();
                await context.pushRoute(const SettingsRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}
