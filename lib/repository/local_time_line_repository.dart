import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class LocalTimelineRepository extends SocketTimelineRepository {
  LocalTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.notes.localTimeline(
      NotesLocalTimelineRequest(
        untilId: untilId,
        withRenotes: tabSetting.renoteDisplay,
        withReplies: tabSetting.isIncludeReplies,
        withFiles: tabSetting.isMediaOnly,
      ),
    );
  }

  @override
  Channel get channel => Channel.localTimeline;

  @override
  Map<String, dynamic> get parameters => {
        "withRenotes": tabSetting.renoteDisplay,
        "withReplies": tabSetting.isIncludeReplies,
        "withFiles": tabSetting.isMediaOnly,
      };
}
