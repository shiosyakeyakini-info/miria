import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/channels_page/channel_favorited.dart';
import 'package:miria/view/channels_page/channel_followed.dart';
import 'package:miria/view/channels_page/channel_search.dart';
import 'package:miria/view/channels_page/channel_trend.dart';
import 'package:miria/view/common/account_scope.dart';

class ChannelSelectDialog extends StatelessWidget {
  final Account account;

  const ChannelSelectDialog({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("チャンネル選択"),
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
                  child: const Align(
                    child: TabBar(
                      tabs: [
                        Tab(text: "検索"),
                        Tab(text: "トレンド"),
                        Tab(text: "お気に入り"),
                        Tab(text: "フォロー中"),
                      ],
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AccountScope(
                  account: account,
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ChannelSearch(
                          onChannelSelected: (channel) =>
                              Navigator.of(context).pop(channel),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ChannelTrend(
                          onChannelSelected: (channel) =>
                              Navigator.of(context).pop(channel),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ChannelFavorited(
                          onChannelSelected: (channel) =>
                              Navigator.of(context).pop(channel),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ChannelFollowed(
                          onChannelSelected: (channel) =>
                              Navigator.of(context).pop(channel),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
