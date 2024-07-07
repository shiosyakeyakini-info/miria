import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";

class FederationUsers extends ConsumerWidget {
  final String host;
  const FederationUsers({
    required this.host,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .federation
            .users(FederationUsersRequest(host: host));
        return response.toList();
      },
      nextFuture: (lastItem, _) async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .federation
            .users(FederationUsersRequest(host: host, untilId: lastItem.id));
        return response.toList();
      },
      itemBuilder: (context, user) => UserListItem(
        user: user,
        isDetail: true,
      ),
    );
  }
}
