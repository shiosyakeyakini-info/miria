import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/channels_page/community_channel_view.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/futable_list_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChannelTrend extends ConsumerWidget {
  const ChannelTrend({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureListView(
        future: ref
            .read(misskeyProvider(AccountScope.of(context)))
            .channels
            .featured(),
        builder: (context, item) => CommunityChannelView(channel: item));
  }
}
