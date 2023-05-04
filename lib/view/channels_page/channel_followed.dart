import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/channels_page/community_channel_view.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/futable_list_builder.dart';
import 'package:flutter_misskey_app/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelFollowed extends ConsumerWidget {
  const ChannelFollowed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    return PushableListView(
        initializeFuture: () async {
          final response = await ref
              .read(misskeyProvider(account))
              .channels
              .followed(const ChannelsFollowedRequest());
          return response.toList();
        },
        nextFuture: (lastItem) async {
          final response = await ref
              .read(misskeyProvider(account))
              .channels
              .followed(ChannelsFollowedRequest(sinceId: lastItem.id));
          return response.toList();
        },
        itemBuilder: (context, item) => CommunityChannelView(channel: item));
  }
}
