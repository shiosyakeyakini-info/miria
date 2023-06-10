import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:miria/view/user_page/user_list_item.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class ExploreRoleUsersPage extends ConsumerWidget {
  final RolesListResponse item;
  final Account account;

  const ExploreRoleUsersPage({
    super.key,
    required this.item,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
      account: account,
      child: Scaffold(
        appBar: AppBar(title: Text(item.name)),
        body: PushableListView(
          initializeFuture: () async {
            final response = await ref
                .read(misskeyProvider(account))
                .roles
                .users(RolesUsersRequest(roleId: item.id));
            return response.toList();
          },
          nextFuture: (lastItem, _) async {
            final response = await ref
                .read(misskeyProvider(account))
                .roles
                .users(
                    RolesUsersRequest(roleId: item.id, untilId: lastItem.id));
            return response.toList();
          },
          itemBuilder: (context, item) => UserListItem(user: item.user),
        ),
      ),
    );
  }
}
