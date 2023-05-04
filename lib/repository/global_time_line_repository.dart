import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class GlobalTimeLineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  GlobalTimeLineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
  );

  @override
  void startTimeLine() {
    socketController = misskey.globalTimelineStream((note) {
      notes.add(note);

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
