import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/channels_page/channel_favorited.dart';
import 'package:miria/view/channels_page/channel_followed.dart';
import 'package:miria/view/channels_page/channel_search.dart';
import 'package:miria/view/channels_page/channel_trend.dart';
import 'package:miria/view/common/account_scope.dart';

@RoutePage()
class ChannelsPage extends StatelessWidget {
  final Account account;

  const ChannelsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("チャンネル"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "検索"),
              Tab(text: "トレンド"),
              Tab(text: "お気に入り"),
              Tab(text: "フォロー中"),
              Tab(text: "管理中")
            ],
            isScrollable: true,
            tabAlignment: TabAlignment.center,
          ),
        ),
        body: AccountScope(
            account: account,
            child: const TabBarView(children: [
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ChannelSearch()),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ChannelTrend(),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ChannelFavorited()),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ChannelFollowed()),
              Text("作成中")
            ])),
      ),
    );
  }
}
