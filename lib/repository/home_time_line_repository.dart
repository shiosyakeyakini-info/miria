import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class HomeTimeLineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  HomeTimeLineRepository(this.misskey);

  void reloadLatestNotes() {
    misskey.notes
        .homeTimeline(const NotesTimelineRequest(limit: 30))
        .then((resultNotes) {
      for (final note in resultNotes) {
        final foundNote = notes.indexWhere((element) => element.id == note.id);
        if (foundNote == -1) {
          if (note.createdAt < notes.last.createdAt) {
            notes.addFirst(note);
          } else {
            notes.addLast(note);
          }
        } else {
          notes[foundNote] = note;
        }
      }
      notifyListeners();
    });
  }

  @override
  void startTimeLine() {
    if (notes.isEmpty) {
      misskey.notes.homeTimeline(const NotesTimelineRequest(limit: 30)).then(
          (resultNotes) {
        for (final note in resultNotes.toList()) {
          notes.addFirst(note);
        }
        notifyListeners();
      }, onError: (e, s) {
        print(e);
        print(s);
      });
    } else {
      reloadLatestNotes();
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
    reloadLatestNotes();
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
