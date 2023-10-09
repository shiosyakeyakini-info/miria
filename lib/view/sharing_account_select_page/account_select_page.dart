import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/avatar_icon.dart';

@RoutePage()
class SharingAccountSelectPage extends ConsumerStatefulWidget {
  final String? sharingText;
  final List<String>? filePath;

  const SharingAccountSelectPage({super.key, this.sharingText, this.filePath});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SharingAccountSelectPageState();
}

class SharingAccountSelectPageState
    extends ConsumerState<SharingAccountSelectPage> {
  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountRepository).account.toList();
    return Scaffold(
      appBar: AppBar(title: const Text("共有するアカウントを選択")),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return ListTile(
            onTap: () {
              context.replaceRoute(NoteCreateRoute(
                initialAccount: account,
                initialText: widget.sharingText,
                initialMediaFiles: widget.filePath,
              ));
            },
            leading: AvatarIcon(user: account.i),
            title: Text(account.i.name ?? account.i.username,
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              "@${account.userId}@${account.host}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        },
      ),
    );
  }
}
