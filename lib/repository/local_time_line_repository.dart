import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class LocalTimeLineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  LocalTimeLineRepository(this.misskey);

  @override
  void startTimeLine() {
    socketController = misskey.localTimelineStream((note) {
      notes.add(note);

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
    socketController?.reconnect();
  }
}
