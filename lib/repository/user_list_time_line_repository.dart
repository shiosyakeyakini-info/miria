import 'dart:async';

import 'package:miria/repository/socket_timeline_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UserListTimelineRepository extends SocketTimelineRepository {
  final Misskey misskey;

  UserListTimelineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.tabSetting,
  );

  @override
  SocketController createSocketController(void Function(Note note) onReceived,
      FutureOr<void> Function(String id, TimelineReacted reaction) onReacted) {
    return misskey.userListStream(tabSetting.listId!, onReceived, onReacted);
  }

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.notes.userListTimeline(UserListTimelineRequest(
        listId: tabSetting.listId!, limit: 30, untilId: untilId));
  }
}
