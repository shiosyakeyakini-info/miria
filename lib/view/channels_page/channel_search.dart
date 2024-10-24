import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/channels_page/community_channel_view.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

final channelSearchProvider = StateProvider.autoDispose((ref) => "");

class ChannelSearch extends ConsumerWidget {
  const ChannelSearch({super.key, this.onChannelSelected});

  final void Function(CommunityChannel channel)? onChannelSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 5)),
        TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            ref.read(channelSearchProvider.notifier).state = value;
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ChannelSearchList(onChannelSelected: onChannelSelected),
          ),
        ),
      ],
    );
  }
}

class ChannelSearchList extends ConsumerWidget {
  const ChannelSearchList({super.key, this.onChannelSelected});

  final void Function(CommunityChannel channel)? onChannelSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchValue = ref.watch(channelSearchProvider);

    if (searchValue.isEmpty) {
      return Container();
    }

    return PushableListView(
      listKey: searchValue,
      initializeFuture: () async {
        final channels = await ref
            .read(misskeyGetContextProvider)
            .channels
            .search(ChannelsSearchRequest(query: searchValue));
        return channels.toList();
      },
      nextFuture: (lastItem, _) async {
        final channels =
            await ref.read(misskeyGetContextProvider).channels.search(
                  ChannelsSearchRequest(
                    query: searchValue,
                    untilId: lastItem.id,
                  ),
                );
        return channels.toList();
      },
      itemBuilder: (context, item) {
        return CommunityChannelView(
          channel: item,
          onTap: onChannelSelected != null
              ? () => onChannelSelected?.call(item)
              : null,
        );
      },
    );
  }
}
