import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelTimeline extends ConsumerWidget {
  final String channelId;
  const ChannelTimeline({
    super.key,
    required this.channelId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    return PushableListView<Note>(
        initializeFuture: () async {
          final response = await ref
              .read(misskeyProvider(account))
              .channels
              .timeline(
                  ChannelsTimelineRequest(channelId: channelId, limit: 30));
          ref.read(notesProvider(account)).registerAll(response);
          return response.toList();
        },
        nextFuture: (lastItem, _) async {
          final response = await ref
              .read(misskeyProvider(account))
              .channels
              .timeline(ChannelsTimelineRequest(
                  channelId: channelId, untilId: lastItem.id, limit: 30));
          ref.read(notesProvider(account)).registerAll(response);
          return response.toList();
        },
        itemBuilder: (context, item) => MisskeyNote(note: item));
  }
}
