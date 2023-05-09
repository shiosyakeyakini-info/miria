import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/pushable_listview.dart';
import 'package:flutter_misskey_app/view/user_page/user_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class UserFollowerPage extends ConsumerWidget {
  final String userId;
  final Account account;

  const UserFollowerPage({
    super.key,
    required this.userId,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
      account: account,
      child: Scaffold(
        appBar: AppBar(title: Text("フォロワー")),
        body: PushableListView<Following>(
          initializeFuture: () async {
            final response = await ref
                .read(misskeyProvider(account))
                .users
                .followers(UsersFollowersRequest(userId: userId));
            return response.toList();
          },
          nextFuture: (lastItem) async {
            final response = await ref
                .read(misskeyProvider(account))
                .users
                .followers(UsersFollowersRequest(
                    userId: userId, untilId: lastItem.id));
            return response.toList();
          },
          itemBuilder: (context, item) => UserListItem(user: item.follower!),
        ),
      ),
    );
  }
}
