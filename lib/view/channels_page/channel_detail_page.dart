import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/view/channels_page/channel_detail_info.dart';
import 'package:flutter_misskey_app/view/channels_page/channel_timeline.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';

@RoutePage()
class ChannelDetailPage extends StatelessWidget {
  final Account account;
  final String channelId;

  const ChannelDetailPage({
    super.key,
    required this.account,
    required this.channelId,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AccountScope(
          account: account,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("チャンネル"),
            ),
            body: Column(
              children: [
                const TabBar(tabs: [
                  Tab(child: Text("チャンネル情報")),
                  Tab(child: Text("タイムライン"))
                ]),
                Expanded(
                    child: TabBarView(
                  children: [
                    SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ChannelDetailInfo(channelId: channelId))),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: ChannelTimeline(channelId: channelId)),
                  ],
                )),
              ],
            ),
          )),
    );
  }
}
