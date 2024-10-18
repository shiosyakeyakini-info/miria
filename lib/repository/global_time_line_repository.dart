import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class GlobalTimelineRepository extends SocketTimelineRepository {
  GlobalTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.notes.globalTimeline(
      NotesGlobalTimelineRequest(
        limit: 30,
        untilId: untilId,
      ),
    );
  }

  @override
  Channel get channel => Channel.globalTimeline;

  @override
  Map<String, dynamic> get parameters => {"channelId": tabSetting.channelId};
}
