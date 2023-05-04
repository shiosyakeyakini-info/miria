import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_misskey_app/repository/main_stream_repository.dart';
import 'package:flutter_misskey_app/repository/note_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NotifierQueueList extends QueueList<Note> {
  final NoteRepository noteRepository;

  NotifierQueueList(this.noteRepository);

  @override
  void add(Note element) {
    super.add(element);
    noteRepository.registerNote(element);
  }

  @override
  void addAll(Iterable<Note> iterable) {
    super.addAll(iterable);
    noteRepository.registerAll(iterable);
  }

  @override
  void addFirst(Note element) {
    super.addFirst(element);
    noteRepository.registerNote(element);
  }

  @override
  void addLast(Note element) {
    super.addLast(element);
    noteRepository.registerNote(element);
  }
}

abstract class TimeLineRepository extends ChangeNotifier {
  final NoteRepository noteRepository;
  final MainStreamRepository globalNotificationRepository;

  TimeLineRepository(this.noteRepository, this.globalNotificationRepository);

  late final QueueList<Note> notes = NotifierQueueList(noteRepository);

  void startTimeLine() {}

  void disconnect() {}

  void reconnect() {
    globalNotificationRepository.reconnect();
  }

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

  Future<void> previousLoad() async {}
}
