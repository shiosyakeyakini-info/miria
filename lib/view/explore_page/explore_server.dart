import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_server_list.dart';

class ExploreServer extends ConsumerStatefulWidget {
  const ExploreServer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ExploreServerState();
}

class ExploreServerState extends ConsumerState<ExploreServer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: MisskeyServerList(
          onTap: (item) => context.pushRoute(FederationRoute(
              account: AccountScope.of(context), host: item.url))),
    );
  }
}
