import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class HomeTimeLineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  HomeTimeLineRepository(this.misskey);

  @override
  void startTimeLine() {
    if (notes.isEmpty) {
      misskey.notes.homeTimeline(const NotesTimelineRequest(limit: 30)).then(
          (resultNotes) {
        for (final note in resultNotes.toList().reversed) {
          notes.addLast(note);
        }
        notifyListeners();
      }, onError: (e, s) {
        print(e);
        print(s);
      });
    }

    socketController = misskey.homeTimelineStream((note) {
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
    socketController?.reconnect();
  }
}
