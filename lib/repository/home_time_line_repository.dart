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
    } else {
      misskey.notes
          .homeTimeline(const NotesTimelineRequest(limit: 30))
          .then((resultNotes) {
        for (final note in resultNotes) {
          final foundNote =
              notes.indexWhere((element) => element.id == note.id);
          if (foundNote == -1) {
            notes.add(note);
          } else {
            notes[foundNote] = note;
          }
        }
        notifyListeners();
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

  @override
  void previousLoad() {
    if (notes.isEmpty) {
      return;
    }
    misskey.notes
        .homeTimeline(
      NotesTimelineRequest(
        limit: 30,
        untilId: notes.first.id,
      ),
    )
        .then(
      (resultNotes) {
        for (final note in resultNotes) {
          notes.addFirst(note);
        }
        notifyListeners();
      },
    );
  }
}
