import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/avatar_icon.dart';

@RoutePage()
class SharingAccountSelectPage extends ConsumerWidget {
  final String? sharingText;
  final List<String>? filePath;

  const SharingAccountSelectPage({super.key, this.sharingText, this.filePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).selectAccountToShare)),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return ListTile(
            onTap: () {
              context.replaceRoute(
                NoteCreateRoute(
                  initialAccount: account,
                  initialText: sharingText,
                  initialMediaFiles: filePath,
                  exitOnNoted: defaultTargetPlatform == TargetPlatform.iOS,
                ),
              );
            },
            leading: AvatarIcon(user: account.i),
            title: Text(account.i.name ?? account.i.username,
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              account.acct.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        },
      ),
    );
  }
}
