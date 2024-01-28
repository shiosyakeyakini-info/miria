import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSelectDialog extends ConsumerWidget {
  const AccountSelectDialog({super.key, this.host});

  /// nullではないとき, 指定されたサーバーのアカウントのみ表示する
  final String? host;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    return AlertDialog(
      title: Text(S.of(context).openAsOtherAccount),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView(
          children: accounts
              .where((account) => host == null || account.host == host)
              .map(
                (account) => AccountScope(
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
              )
              .toList(),
        ),
      ),
    );
  }
}
