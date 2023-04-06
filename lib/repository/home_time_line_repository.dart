import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class HomeTimeLineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  HomeTimeLineRepository(this.misskey);

  @override
  void startTimeLine() {
    socketController = misskey.homeTimelineStream((note) {
      notes.add(note);

      if (notes.length > 100) {
        notes.removeFirst();
      }

      notifyListeners();
    })
      ..startStreaming();
  }

  @override
  void disconnect() {
    socketController?.disconnect();
  }
}
