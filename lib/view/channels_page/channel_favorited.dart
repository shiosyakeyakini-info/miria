import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/channels_page/community_channel_view.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/futable_list_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelFavorited extends ConsumerWidget {
  const ChannelFavorited({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    return FutureListView(
        future: ref
            .read(misskeyProvider(account))
            .channels
            .myFavorite(const ChannelsMyFavoriteRequest()),
        builder: (context, item) => CommunityChannelView(channel: item));
  }
}
