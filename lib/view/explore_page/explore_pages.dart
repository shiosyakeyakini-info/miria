import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm_renderer/mfm_renderer.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/futable_list_builder.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';

class ExplorePages extends ConsumerStatefulWidget {
  const ExplorePages({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ExplorePagesState();
}

class ExplorePagesState extends ConsumerState<ExplorePages> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureListView(future: () async {
        final result = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .pages
            .featured();
        return result.toList();
      }(), builder: (context, item) {
        return ListTile(
          onTap: () {
            context.pushRoute(
              MisskeyRouteRoute(account: AccountScope.of(context), page: item),
            );
          },
          title: MfmText(mfmText: item.title),
          subtitle: MfmText(mfmText: item.summary ?? ""),
        );
      }),
    );
  }
}
