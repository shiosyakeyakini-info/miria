import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_misskey_app/model/tab_setting.dart';
import 'package:flutter_misskey_app/repository/main_stream_repository.dart';
import 'package:flutter_misskey_app/repository/note_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NotifierQueueList extends QueueList<Note> {
  final NoteRepository noteRepository;
  final TabSetting tabSetting;

  NotifierQueueList(this.noteRepository, this.tabSetting);

  bool filterAs(Note element) {
    if (tabSetting.renoteDisplay == false &&
        element.text == null &&
        element.cw == null &&
        element.renoteId != null) {
      return false;
    }
    return true;
  }

  @override
  void add(Note element) {
    if (!filterAs(element)) return;
    super.add(element);
    noteRepository.registerNote(element);
  }

  @override
  void addAll(Iterable<Note> iterable) {
    final target = iterable.where((e) => filterAs(e));
    super.addAll(target);
    noteRepository.registerAll(target);
  }

  @override
  void addFirst(Note element) {
    if (!filterAs(element)) return;
    super.addFirst(element);
    noteRepository.registerNote(element);
  }

  @override
  void addLast(Note element) {
    if (!filterAs(element)) return;
    super.addLast(element);
    noteRepository.registerNote(element);
  }

  @override
  void insert(int index, Note element) {
    if (!filterAs(element)) return;
    super.insert(index, element);
    noteRepository.registerNote(element);
  }
}

abstract class TimeLineRepository extends ChangeNotifier {
  final NoteRepository noteRepository;
  final MainStreamRepository globalNotificationRepository;
  final TabSetting tabSetting;

  TimeLineRepository(
      this.noteRepository, this.globalNotificationRepository, this.tabSetting);

  late final QueueList<Note> notes =
      NotifierQueueList(noteRepository, tabSetting);

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
