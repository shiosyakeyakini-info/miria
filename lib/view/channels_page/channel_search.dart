import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/channels_page/community_channel_view.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

final channelSearchProvider = StateProvider.autoDispose((ref) => "");

class ChannelSearch extends ConsumerStatefulWidget {
  const ChannelSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChannelSearchState();
}

class ChannelSearchState extends ConsumerState<ChannelSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 5)),
        TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              ref.read(channelSearchProvider.notifier).state = value;
            }),
        const Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ChannelSearchList()))
      ],
    );
  }
}

class ChannelSearchList extends ConsumerWidget {
  const ChannelSearchList({super.key});

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
              .read(misskeyProvider(AccountScope.of(context)))
              .channels
              .search(ChannelsSearchRequest(query: searchValue));
          return channels.toList();
        },
        nextFuture: (lastItem) async {
          final channels = await ref
              .read(misskeyProvider(AccountScope.of(context)))
              .channels
              .search(ChannelsSearchRequest(
                  query: searchValue, untilId: lastItem.id));
          return channels.toList();
        },
        itemBuilder: (context, item) {
          return CommunityChannelView(channel: item);
        });
  }
}
