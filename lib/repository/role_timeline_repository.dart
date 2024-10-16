import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class RoleTimelineRepository extends SocketTimelineRepository {
  RoleTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.roles.notes(
      RolesNotesRequest(
        roleId: tabSetting.roleId!,
        limit: 30,
        untilId: untilId,
      ),
    );
  }

  @override
  Channel get channel => Channel.roleTimeline;

  @override
  Map<String, dynamic> get parameters => {"roleId": tabSetting.roleId};
}
