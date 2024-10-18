import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";

@RoutePage<Account>()
class AccountSelectDialog extends HookConsumerWidget {
  const AccountSelectDialog({super.key, this.host, this.remoteHost});

  /// nullではないとき, 指定されたサーバーのアカウントのみ表示する
  final String? host;

  /// 相手先のホスト
  final String? remoteHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    final navigateAsRemote = useHandledFuture(() async {
      final remoteHost = this.remoteHost;
      if (remoteHost == null) return;
      final meta =
          await ref.read(misskeyWithoutAccountProvider(remoteHost)).meta();

      await ref
          .read(appRouterProvider)
          .maybePop(Account.demoAccount(remoteHost, meta));
    });

    return AlertDialog(
      title: Text(S.of(context).openAsOtherAccount),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView(
          children: [
            if (remoteHost != null)
              switch (navigateAsRemote.value) {
                AsyncLoading() => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                _ => ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("相手先のサーバー（ログインなし）"),
                    onTap: navigateAsRemote.executeOrNull,
                  ),
              },
            for (final account in accounts
                .where((account) => host == null || account.host == host))
              AccountContextScope.as(
                account: account,
                child: ListTile(
                  leading: AvatarIcon(user: account.i),
                  title: SimpleMfmText(
                    account.i.name ?? account.i.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    account.acct.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(account);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
