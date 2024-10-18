import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChannelTimeline extends ConsumerWidget {
  final String channelId;
  const ChannelTimeline({
    required this.channelId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView<Note>(
      initializeFuture: () async {
        final response =
            await ref.read(misskeyGetContextProvider).channels.timeline(
                  ChannelsTimelineRequest(channelId: channelId, limit: 30),
                );
        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      nextFuture: (lastItem, _) async {
        final response =
            await ref.read(misskeyGetContextProvider).channels.timeline(
                  ChannelsTimelineRequest(
                    channelId: channelId,
                    untilId: lastItem.id,
                    limit: 30,
                  ),
                );
        ref.read(notesWithProvider).registerAll(response);
        return response.toList();
      },
      itemBuilder: (context, item) => MisskeyNote(note: item),
    );
  }
}
