import 'dart:async';

import 'package:miria/repository/socket_timeline_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AntennaTimelineRepository extends SocketTimelineRepository {
  final Misskey misskey;

  AntennaTimelineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.tabSetting,
  );

  @override
  SocketController createSocketController(void Function(Note note) onReceived,
      FutureOr<void> Function(String id, TimelineReacted reaction) onReacted) {
    return misskey.antennaStream(tabSetting.antennaId!, onReceived, onReacted);
  }

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.antennas.notes(AntennasNotesRequest(
        antennaId: tabSetting.antennaId!, limit: 30, untilId: untilId));
  }
}
