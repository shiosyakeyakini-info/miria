import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:misskey_dart/misskey_dart.dart';

class CommunityChannelView extends StatelessWidget {
  final CommunityChannel channel;

  const CommunityChannelView({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => context.pushRoute(ChannelDetailRoute(
              account: AccountScope.of(context), channelId: channel.id)),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (channel.bannerUrl != null)
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Image.network(
                      channel.bannerUrl!.toString(),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          channel.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          channel.description ?? "",
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor)),
                              child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "${channel.notesCount} 投稿 / ${channel.usersCount} 人が参加 / ${channel.lastNotedAt?.differenceNow ?? channel.createdAt.differenceNow} に更新",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ))),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}
