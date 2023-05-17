import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/repository/main_stream_repository.dart';
import 'package:miria/repository/note_repository.dart';
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

  late final QueueList<Note> newerNotes =
      NotifierQueueList(noteRepository, tabSetting);
  late final QueueList<Note> olderNotes =
      NotifierQueueList(noteRepository, tabSetting);

  void startTimeLine() {}

  void disconnect() {}

  void reconnect() {
    globalNotificationRepository.reconnect();
  }

  void updateNote(Note newNote) {
    var isChanged = false;
    newerNotes.forEachIndexed((index, element) {
      if (element.id == newNote.id) {
        newerNotes[index] = newNote;
        isChanged = true;
      }
      if (element.renote?.id == newNote.id) {
        newerNotes[index] = newerNotes[index].copyWith(renote: newNote);
      }
    });

    if (isChanged) {
      notifyListeners();
    }
  }

  /// 最近のノートを残してリセットする
  void moveToOlder() {
    for (final newerNote in newerNotes) {
      olderNotes.addFirst(newerNote);
    }
    newerNotes.clear();
    Future(() async {
      notifyListeners();
    });
  }

  Future<void> previousLoad() async {}

  void subscribe(String id) {}

  void describe(String id) {}
}
