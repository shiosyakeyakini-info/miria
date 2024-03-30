import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/channels_page/community_channel_view.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelFollowed extends ConsumerWidget {
  const ChannelFollowed({super.key, this.onChannelSelected});

  final void Function(CommunityChannel channel)? onChannelSelected;

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
      nextFuture: (lastItem, _) async {
        final response = await ref
            .read(misskeyProvider(account))
            .channels
            .followed(ChannelsFollowedRequest(untilId: lastItem.id));
        return response.toList();
      },
      itemBuilder: (context, item) => CommunityChannelView(
        channel: item,
        onTap: onChannelSelected != null
            ? () => onChannelSelected?.call(item)
            : null,
      ),
    );
  }
}
