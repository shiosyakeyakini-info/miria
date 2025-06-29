import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/blocked_users_page/blocked_users_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/error_detail.dart";

@RoutePage()
class BlockedUsersPage extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const BlockedUsersPage({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocking = ref.watch(blockedUsersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).blockedUsers)),
      body: switch (blocking) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        AsyncError(:final error, :final stackTrace) => Center(
          child: ErrorDetail(error: error, stackTrace: stackTrace),
        ),
        AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final block = value[index];
            return HookBuilder(
              builder: (context) {
                final unblock = useAsync(
                  () async => ref
                      .read(blockedUsersNotifierProvider.notifier)
                      .delete(block.blockeeId),
                );
                return ListTile(
                  leading: AvatarIcon(user: block.blockee),
                  title: Text(block.blockee.name ?? block.blockee.username),
                  subtitle: Text(
                    "@${block.blockee.username}${block.blockee.host != null ? "@${block.blockee.host}" : ""}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.block_rounded),
                    tooltip: S.of(context).unblock,
                    onPressed: unblock.executeOrNull,
                  ),
                  onTap: () async => context.pushRoute(
                    UserRoute(
                      userId: block.blockee.id,
                      accountContext: ref.read(accountContextProvider),
                    ),
                  ),
                );
              },
            );
          },
        ),
      },
    );
  }
}
