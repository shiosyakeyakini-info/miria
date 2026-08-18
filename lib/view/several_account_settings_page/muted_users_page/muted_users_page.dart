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
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class MutedUsersPage extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const MutedUsersPage({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // notifierを生かしておく。readだけだとautoDisposeで即座に破棄され、
    // 解除の確認ダイアログをawaitして戻ってきたときにはRefが死んでいる。
    // （#677と同じ壊れかた）
    ref.watch(mutedUsersProvider);

    // ミュートを解除したら一覧を取り直すためのキー。
    // PushableListViewは自分が持っている項目を外から消せない。
    final listKey = useState(0);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).mutedUsers)),
      // 以前は1ページ目を取ってそのままListViewに流していたので、
      // 「さらに読み込む」が出ず続きを見られなかった (#777)
      body: PushableListView<Muting>(
        listKey: listKey.value,
        showAd: false,
        initializeFuture: () async =>
            ref.read(mutedUsersProvider.notifier).fetch(),
        nextFuture: (lastItem, _) async =>
            ref.read(mutedUsersProvider.notifier).fetch(untilId: lastItem.id),
        itemBuilder: (context, muting) => HookBuilder(
          builder: (context) {
            final unmute = useAsync(() async {
              final deleted = await ref
                  .read(mutedUsersProvider.notifier)
                  .delete(muting);
              if (deleted) listKey.value++;
            });
            return ListTile(
              leading: AvatarIcon(user: muting.mutee),
              title: Text(muting.mutee.name ?? muting.mutee.username),
              subtitle: Text(
                "@${muting.mutee.username}${muting.mutee.host != null ? "@${muting.mutee.host}" : ""}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                tooltip: S.of(context).unmute,
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
        ),
      ),
    );
  }
}
