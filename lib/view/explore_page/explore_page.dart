import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/explore_page/explore_hashtags.dart";
import "package:miria/view/explore_page/explore_highlight.dart";
import "package:miria/view/explore_page/explore_pages.dart";
import "package:miria/view/explore_page/explore_plays.dart";
import "package:miria/view/explore_page/explore_role.dart";
import "package:miria/view/explore_page/explore_server.dart";
import "package:miria/view/explore_page/explore_users.dart";

@RoutePage()
class ExplorePage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const ExplorePage({
    required this.accountContext,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).explore),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: S.of(context).highlight),
              Tab(text: S.of(context).user),
              Tab(text: S.of(context).role),
              Tab(text: S.of(context).page),
              Tab(text: S.of(context).flash),
              Tab(text: S.of(context).hashtag),
              Tab(text: S.of(context).otherServers),
            ],
            tabAlignment: TabAlignment.center,
          ),
        ),
        body: const TabBarView(
          children: [
            ExploreHighlight(),
            ExploreUsers(),
            ExploreRole(),
            ExplorePages(),
            ExplorePlay(),
            ExploreHashtags(),
            ExploreServer(),
          ],
        ),
      ),
    );
  }
}
