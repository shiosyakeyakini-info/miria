import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class UserListTimelineRepository extends SocketTimelineRepository {
  UserListTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.notes.userListTimeline(
      UserListTimelineRequest(
        listId: tabSetting.listId!,
        untilId: untilId,
        withRenotes: tabSetting.renoteDisplay,
        withFiles: tabSetting.isMediaOnly,
      ),
    );
  }

  @override
  // TODO: implement channel
  Channel get channel => Channel.userList;

  @override
  // TODO: implement parameters
  Map<String, dynamic> get parameters => {"listId": tabSetting.listId};
}
