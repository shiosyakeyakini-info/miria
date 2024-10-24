import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/view/channels_page/channel_favorited.dart";
import "package:miria/view/channels_page/channel_followed.dart";
import "package:miria/view/channels_page/channel_search.dart";
import "package:miria/view/channels_page/channel_trend.dart";
import "package:miria/view/common/account_scope.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage<CommunityChannel>()
class ChannelSelectDialog extends StatelessWidget implements AutoRouteWrapper {
  final Account account;

  const ChannelSelectDialog({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).selectChannel),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: DefaultTabController(
          length: 4,
          initialIndex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Align(
                    child: TabBar(
                      tabs: [
                        Tab(text: S.of(context).search),
                        Tab(text: S.of(context).trend),
                        Tab(text: S.of(context).favorite),
                        Tab(text: S.of(context).following),
                      ],
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ChannelSearch(
                        onChannelSelected: (channel) async =>
                            context.maybePop(channel),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ChannelTrend(
                        onChannelSelected: (channel) async =>
                            context.maybePop(channel),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ChannelFavorited(
                        onChannelSelected: (channel) async =>
                            context.maybePop(channel),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ChannelFollowed(
                        onChannelSelected: (channel) async =>
                            context.maybePop(channel),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
