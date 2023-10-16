import 'package:miria/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class GlobalTimeLineRepository extends TimelineRepository {
  SocketController? socketController;

  final Misskey misskey;

  GlobalTimeLineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.generalSettingsRepository,
    super.tabSetting,
  );

  @override
  void startTimeLine() {
    socketController = misskey.globalTimelineStream(
      parameter: GlobalTimelineParameter(
        withRenotes: tabSetting.renoteDisplay,
        withFiles: tabSetting.isMediaOnly,
      ),
      onNoteReceived: (note) {
        newerNotes.add(note);

        notifyListeners();
      },
    );
    misskey.startStreaming();
  }

  @override
  void disconnect() {
    socketController?.disconnect();
  }

  @override
  Future<void> reconnect() async {
    await super.reconnect();
    socketController?.reconnect();
  }

  @override
  void dispose() {
    super.dispose();
    socketController?.disconnect();
    socketController = null;
  }
}
