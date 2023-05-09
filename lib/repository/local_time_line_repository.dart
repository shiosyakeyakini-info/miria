import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class LocalTimeLineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  LocalTimeLineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.tabSetting,
  );

  @override
  void startTimeLine() {
    socketController = misskey.localTimelineStream((note) {
      newerNotes.add(note);

      // if (notes.length > 100) {
      //   notes.removeFirst();
      // }

      notifyListeners();
    })
      ..startStreaming();
  }

  @override
  void disconnect() {
    socketController?.disconnect();
  }

  @override
  void reconnect() {
    super.reconnect();
    socketController?.reconnect();
  }

  @override
  void dispose() {
    super.dispose();
    socketController?.disconnect();
    socketController = null;
  }
}
