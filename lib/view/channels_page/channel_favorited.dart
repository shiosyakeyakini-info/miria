import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/channels_page/community_channel_view.dart";
import "package:miria/view/common/futable_list_builder.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChannelFavorited extends ConsumerWidget {
  const ChannelFavorited({super.key, this.onChannelSelected});

  final void Function(CommunityChannel channel)? onChannelSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureListView(
      future: ref
          .read(misskeyPostContextProvider)
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
