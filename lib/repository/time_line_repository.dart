import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:misskey_dart/misskey_dart.dart';

abstract class TimeLineRepository extends ChangeNotifier {
  final QueueList<Note> notes = QueueList();

  void startTimeLine() {}

  void disconnect() {}

  void reconnect() {}

  void updateNote(Note newNote) {
    var isChanged = false;
    notes.forEachIndexed((index, element) {
      if (element.id == newNote.id) {
        notes[index] = newNote;
        isChanged = true;
      }
      if (element.renote?.id == newNote.id) {
        notes[index] = notes[index].copyWith(renote: newNote);
      }
    });

    if (isChanged) {
      notifyListeners();
    }
  }

  /// 最近のノートを残してリセットする
  void resetAsRemainedLatestNotes() {
    if (notes.length > 10) {
      notes.removeRange(0, notes.length - 10);
    }
    notifyListeners();
  }

  void previousLoad() {}
}
