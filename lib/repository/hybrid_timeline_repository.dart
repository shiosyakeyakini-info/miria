import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class HybridTimelineRepository extends SocketTimelineRepository {
  HybridTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.notes.hybridTimeline(
      NotesHybridTimelineRequest(
        untilId: untilId,
        withRenotes: tabSetting.renoteDisplay,
        withReplies: tabSetting.isIncludeReplies,
        withFiles: tabSetting.isMediaOnly,
      ),
    );
  }

  @override
  Channel get channel => Channel.hybridTimeline;

  @override
  Map<String, dynamic> get parameters => {};
}
