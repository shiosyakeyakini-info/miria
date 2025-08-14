import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:misskey_dart/misskey_dart.dart";

enum ChatMessageMenuAction { reaction, copy, delete, detail, report }

@RoutePage()
class ChatMessageMenuSheet extends ConsumerWidget implements AutoRouteWrapper {
  final Account account;
  final ChatMessage message;
  final User user;

  const ChatMessageMenuSheet({
    required this.account,
    required this.message,
    required this.user,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountContext = ref.read(accountContextProvider);
    final isMyMessage = message.fromUserId == accountContext.postAccount.i.id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.add_reaction),
          title: Text(S.of(context).chatReaction),
          onTap: () => context.maybePop(ChatMessageMenuAction.reaction),
        ),
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(S.of(context).copyContents),
          onTap: () => context.maybePop(ChatMessageMenuAction.copy),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(S.of(context).detail),
          onTap: () => context.maybePop(ChatMessageMenuAction.detail),
        ),
        if (isMyMessage)
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => context.maybePop(ChatMessageMenuAction.delete),
          ),
        if (!isMyMessage)
          ListTile(
            leading: const Icon(Icons.report),
            title: Text(S.of(context).chatReport),
            onTap: () => context.maybePop(ChatMessageMenuAction.report),
          ),
      ],
    );
  }
}
