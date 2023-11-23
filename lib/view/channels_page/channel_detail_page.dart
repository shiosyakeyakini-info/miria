import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/channels_page/channel_detail_info.dart';
import 'package:miria/view/channels_page/channel_timeline.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class ChannelDetailPage extends ConsumerWidget {
  final Account account;
  final String channelId;

  const ChannelDetailPage({
    super.key,
    required this.account,
    required this.channelId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: AccountScope(
        account: account,
        child: Scaffold(
          appBar: AppBar(
            title:  Text(S.of(context).channel),
            bottom:  TabBar(tabs: [
              Tab(child: Text(S.of(context).channelInformation)),
              Tab(child: Text(S.of(context).timeline))
            ]),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ChannelDetailInfo(channelId: channelId))),
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ChannelTimeline(channelId: channelId)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.edit),
            onPressed: () async {
              final communityChannel = await ref
                  .read(misskeyProvider(account))
                  .channels
                  .show(ChannelsShowRequest(channelId: channelId));
              context.pushRoute(NoteCreateRoute(
                initialAccount: account,
                channel: communityChannel,
              ));
            },
          ),
        ),
      ),
    );
  }
}
