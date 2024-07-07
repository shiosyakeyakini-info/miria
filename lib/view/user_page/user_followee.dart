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
class UserFolloweePage extends ConsumerWidget implements AutoRouteWrapper {
  final String userId;
  final AccountContext accountContext;

  const UserFolloweePage({
    required this.userId,
    required this.accountContext,
    super.key,
  });
  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).follow)),
      body: PushableListView<Following>(
        initializeFuture: () async {
          final response = await ref
              .read(misskeyGetContextProvider)
              .users
              .following(UsersFollowingRequest(userId: userId));
          return response.toList();
        },
        nextFuture: (lastItem, _) async {
          final response =
              await ref.read(misskeyGetContextProvider).users.following(
                    UsersFollowingRequest(
                      userId: userId,
                      untilId: lastItem.id,
                    ),
                  );
          return response.toList();
        },
        itemBuilder: (context, item) => UserListItem(
          user: item.followee!,
          isDetail: true,
        ),
      ),
    );
  }
}
