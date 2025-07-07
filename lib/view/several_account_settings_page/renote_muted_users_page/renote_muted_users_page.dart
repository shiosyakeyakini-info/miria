import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/renote_muted_users_page/renote_muted_users_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/error_detail.dart";

@RoutePage()
class RenoteMutedUsersPage extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const RenoteMutedUsersPage({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renoteMuted = ref.watch(renoteMutedUsersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).renoteMutedUsers)),
      body: switch (renoteMuted) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        AsyncError(:final error, :final stackTrace) => Center(
          child: ErrorDetail(error: error, stackTrace: stackTrace),
        ),
        AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final renoteMuting = value[index];
            return HookBuilder(
              builder: (context) {
                final unmute = useAsync(
                  () async => ref
                      .read(renoteMutedUsersNotifierProvider.notifier)
                      .delete(renoteMuting.muteeId),
                );
                return ListTile(
                  leading: AvatarIcon(user: renoteMuting.mutee),
                  title: Text(renoteMuting.mutee.name ?? renoteMuting.mutee.username),
                  subtitle: Text(
                    "@${renoteMuting.mutee.username}${renoteMuting.mutee.host != null ? "@${renoteMuting.mutee.host}" : ""}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.repeat_rounded),
                    tooltip: S.of(context).deleteRenoteMute,
                    onPressed: unmute.executeOrNull,
                  ),
                  onTap: () async => context.pushRoute(
                    UserRoute(
                      userId: renoteMuting.mutee.id,
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