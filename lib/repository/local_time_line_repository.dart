import 'dart:async';

import 'package:miria/repository/socket_timeline_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class LocalTimeLineRepository extends SocketTimelineRepository {
  final Misskey misskey;

  LocalTimeLineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.tabSetting,
  );

  @override
  SocketController createSocketController(void Function(Note note) onReceived,
      FutureOr<void> Function(String id, TimelineReacted reaction) onReacted) {
    return misskey.localTimelineStream(onReceived, onReacted);
  }

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.notes
        .localTimeline(NotesLocalTimelineRequest(untilId: untilId));
  }
}
