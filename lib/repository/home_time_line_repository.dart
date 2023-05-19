import 'dart:async';

import 'package:collection/collection.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/repository/socket_timeline_repository.dart';
import 'package:miria/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class HomeTimeLineRepository extends SocketTimelineRepository {
  final Misskey misskey;

  HomeTimeLineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.tabSetting,
  );

  @override
  SocketController createSocketController(void Function(Note note) onReceived,
      FutureOr<void> Function(String id, TimelineReacted reaction) onReacted) {
    return misskey.homeTimelineStream(onReceived, onReacted);
  }

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.notes.homeTimeline(NotesTimelineRequest(
      limit: 30,
      untilId: untilId,
    ));
  }
}
