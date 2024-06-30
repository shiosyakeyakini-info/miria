import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class UserFollowerPage extends ConsumerWidget implements AutoRouteWrapper {
  final String userId;
  final Account account;

  const UserFollowerPage({
    required this.userId,
    required this.account,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).follower)),
      body: PushableListView<Following>(
        initializeFuture: () async {
          final response = await ref
              .read(misskeyGetContextProvider)
              .users
              .followers(UsersFollowersRequest(userId: userId));
          return response.toList();
        },
        nextFuture: (lastItem, _) async {
          final response =
              await ref.read(misskeyGetContextProvider).users.followers(
                    UsersFollowersRequest(
                      userId: userId,
                      untilId: lastItem.id,
                    ),
                  );
          return response.toList();
        },
        itemBuilder: (context, item) => UserListItem(
          user: item.follower!,
          isDetail: true,
        ),
      ),
    );
  }
}
