import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class HomeTimelineRepository extends SocketTimelineRepository {
  HomeTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.notes.homeTimeline(
      NotesTimelineRequest(
        limit: 30,
        untilId: untilId,
        withFiles: tabSetting.isMediaOnly,
        withRenotes: tabSetting.renoteDisplay,
      ),
    );
  }

  @override
  Channel get channel => Channel.homeTimeline;

  @override
  Map<String, dynamic> get parameters => {
        "withRenotes": tabSetting.renoteDisplay,
        "withFiles": tabSetting.isMediaOnly,
      };
}
