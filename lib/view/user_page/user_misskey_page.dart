import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMisskeyPage extends ConsumerWidget {
  final String userId;

  const UserMisskeyPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .users
            .pages(UsersPagesRequest(userId: userId));
        return response.toList();
      },
      nextFuture: (item, _) async {
        final response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .users
            .pages(UsersPagesRequest(userId: userId, untilId: item.id));
        return response.toList();
      },
      itemBuilder: (context, page) {
        return ListTile(
          title: Text(page.title),
          onTap: () {
            context.pushRoute(MisskeyRouteRoute(
                account: AccountScope.of(context), page: page));
          },
        );
      },
    );
  }
}
