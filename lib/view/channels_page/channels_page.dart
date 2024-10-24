import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/view/channels_page/channel_favorited.dart";
import "package:miria/view/channels_page/channel_followed.dart";
import "package:miria/view/channels_page/channel_search.dart";
import "package:miria/view/channels_page/channel_trend.dart";
import "package:miria/view/common/account_scope.dart";

@RoutePage()
class ChannelsPage extends StatelessWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const ChannelsPage({required this.accountContext, super.key});
  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).channel),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).search),
              Tab(text: S.of(context).trend),
              Tab(text: S.of(context).favorite),
              Tab(text: S.of(context).following),
              Tab(text: S.of(context).managing),
            ],
            isScrollable: true,
            tabAlignment: TabAlignment.center,
          ),
        ),
        body: TabBarView(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ChannelSearch(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ChannelTrend(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ChannelFavorited(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ChannelFollowed(),
            ),
            Text(S.of(context).notImplemented),
          ],
        ),
      ),
    );
  }
}
