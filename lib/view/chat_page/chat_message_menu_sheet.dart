import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/view/common/account_scope.dart";
import "package:misskey_dart/misskey_dart.dart";

enum ChatMessageMenuAction { reaction, copy, report }

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.add_reaction),
          title: const Text("リアクション"),
          onTap: () => context.maybePop(ChatMessageMenuAction.reaction),
        ),
        ListTile(
          leading: const Icon(Icons.copy),
          title: const Text("内容をコピー"),
          onTap: () => context.maybePop(ChatMessageMenuAction.copy),
        ),
        ListTile(
          leading: const Icon(Icons.report),
          title: const Text("通報"),
          onTap: () => context.maybePop(ChatMessageMenuAction.report),
        ),
      ],
    );
  }
}
