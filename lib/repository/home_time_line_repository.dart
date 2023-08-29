import 'dart:async';

import 'package:miria/repository/socket_timeline_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class HomeTimelineRepository extends SocketTimelineRepository {
  HomeTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.globalNotificationRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.mainStreamRepository,
    super.accountRepository,
    super.emojiRepository,
  );

  @override
  SocketController createSocketController({
    required void Function(Note note) onReceived,
    required FutureOr<void> Function(String id, TimelineReacted reaction)
        onReacted,
    required FutureOr<void> Function(String id, TimelineReacted reaction)
        onUnreacted,
    required FutureOr<void> Function(String id, TimelineVoted vote) onVoted,
    required FutureOr<void> Function(String id, NoteEdited note) onUpdated,
  }) {
    return misskey.homeTimelineStream(
        parameter: HomeTimelineParameter(
          withRenotes: tabSetting.renoteDisplay,
          withFiles: tabSetting.isMediaOnly,
        ),
        onNoteReceived: onReceived,
        onReacted: onReacted,
        onUnreacted: onUnreacted,
        onVoted: onVoted,
        onUpdated: onUpdated);
  }

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
}
