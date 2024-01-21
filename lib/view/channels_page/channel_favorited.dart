import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/channels_page/community_channel_view.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/futable_list_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelFavorited extends ConsumerWidget {
  const ChannelFavorited({super.key, this.onChannelSelected});

  final void Function(CommunityChannel channel)? onChannelSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    return FutureListView(
      future: ref
          .read(misskeyProvider(account))
          .channels
          .myFavorite(const ChannelsMyFavoriteRequest()),
      builder: (context, item) => CommunityChannelView(
        channel: item,
        onTap: onChannelSelected != null
            ? () => onChannelSelected?.call(item)
            : null,
      ),
    );
  }
}
