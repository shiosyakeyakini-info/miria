import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChannelTimelineRepository extends SocketTimelineRepository {
  ChannelTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.channels.timeline(
      ChannelsTimelineRequest(
        channelId: tabSetting.channelId!,
        limit: 30,
        untilId: untilId,
      ),
    );
  }

  @override
  Channel get channel => Channel.channel;

  @override
  Map<String, dynamic> get parameters => {"channelId": tabSetting.channelId};
}
