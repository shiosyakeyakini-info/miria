import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/muted_users_page/muted_users_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/error_detail.dart";

@RoutePage()
class MutedUsersPage extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const MutedUsersPage({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = ref.watch(mutedUsersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).mutedUsers)),
      body: switch (muted) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        AsyncError(:final error, :final stackTrace) => Center(
          child: ErrorDetail(error: error, stackTrace: stackTrace),
        ),
        AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final muting = value[index];
            return HookBuilder(
              builder: (context) {
                final unmute = useAsync(
                  () async => ref
                      .read(mutedUsersNotifierProvider.notifier)
                      .delete(muting.muteeId),
                );
                return ListTile(
                  leading: AvatarIcon(user: muting.mutee),
                  title: Text(muting.mutee.name ?? muting.mutee.username),
                  subtitle: Text(
                    "@${muting.mutee.username}${muting.mutee.host != null ? "@${muting.mutee.host}" : ""}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: unmute.executeOrNull,
                  ),
                  onTap: () async => context.pushRoute(
                    UserRoute(
                      userId: muting.mutee.id,
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
