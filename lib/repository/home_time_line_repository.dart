import 'package:collection/collection.dart';
import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class HomeTimeLineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  HomeTimeLineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.tabSetting,
  );

  void reloadLatestNotes() {
    misskey.notes
        .homeTimeline(const NotesTimelineRequest(limit: 30))
        .then((resultNotes) {
      for (final note in resultNotes.toList().reversed) {
        final foundNote = notes.indexWhere((element) => element.id == note.id);
        if (foundNote == -1) {
          var isInserted = false;
          //TODO: もうちょっとイケてる感じに
          for (int i = notes.length - 1; i >= 0; i--) {
            if (notes[i].createdAt > note.createdAt) {
              notes.insert(i, note);
              isInserted = true;
              break;
            }
          }
          if (!isInserted) {
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
    super.reconnect();
    socketController?.reconnect();
    reloadLatestNotes();
  }

  @override
  Future<void> previousLoad() async {
    if (notes.isEmpty) {
      return;
    }
    final resultNotes = await misskey.notes.homeTimeline(NotesTimelineRequest(
      limit: 30,
      untilId: notes.first.id,
    ));
    for (final note in resultNotes) {
      notes.addFirst(note);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    socketController?.disconnect();
    socketController = null;
  }
}
