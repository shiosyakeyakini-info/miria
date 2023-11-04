import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/repository/general_settings_repository.dart';
import 'package:miria/repository/main_stream_repository.dart';
import 'package:miria/repository/note_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NotifierQueueList extends QueueList<Note> {
  final NoteRepository noteRepository;
  final TabSetting tabSetting;
  final GeneralSettingsRepository generalSettingsRepository;

  NotifierQueueList(
    this.noteRepository,
    this.generalSettingsRepository,
    this.tabSetting,
  );

  bool filterAs(Note element) {
    if (tabSetting.renoteDisplay == false &&
        element.text == null &&
        element.cw == null &&
        element.renoteId != null) {
      return false;
    }
    if (tabSetting.isMediaOnly && element.files.isEmpty) {
      return false;
    }
    if (generalSettingsRepository.settings.nsfwInherit ==
            NSFWInherit.removeNsfw &&
        (element.files.any((e) => e.isSensitive) ||
            element.renote?.files.any((e) => e.isSensitive) == true ||
            element.reply?.files.any((e) => e.isSensitive) == true)) {
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

class SubscribeItem {
  final DateTime? unsubscribedTime;
  final String noteId;
  final String? renoteId;
  final String? replyId;

  const SubscribeItem({
    required this.noteId,
    required this.renoteId,
    required this.replyId,
    this.unsubscribedTime,
  });
}

abstract class TimelineRepository extends ChangeNotifier {
  final NoteRepository noteRepository;
  final MainStreamRepository globalNotificationRepository;
  final GeneralSettingsRepository generalSettingsRepository;
  final TabSetting tabSetting;

  final List<SubscribeItem> subscribedList = [];
  late final Timer timer;

  TimelineRepository(
    this.noteRepository,
    this.globalNotificationRepository,
    this.generalSettingsRepository,
    this.tabSetting,
  ) {
    // describer
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final now = DateTime.now();
      bool condition(SubscribeItem element) =>
          element.unsubscribedTime != null &&
          now.difference(element.unsubscribedTime!) <
              const Duration(seconds: 10);
      for (final item in subscribedList.where(condition)) {
        // 他に参照がなければ、購読を解除する
        if (subscribedList.every(
            (e) => e.renoteId != item.noteId && e.replyId != item.noteId)) {
          describe(item.noteId);
        }

        final renoteId = item.renoteId;
        if (renoteId != null) {
          if (subscribedList.every((e) =>
              (e.noteId != item.renoteId &&
                  e.replyId != item.renoteId &&
                  (e.noteId != item.noteId && e.renoteId != item.renoteId)) ||
              e.noteId == item.noteId)) {
            describe(renoteId);
          }
        }

        final replyId = item.replyId;
        if (replyId != null) {
          if (subscribedList.every((e) =>
              (e.noteId != item.replyId &&
                  e.replyId != item.replyId &&
                  (e.noteId != item.noteId && e.replyId != item.replyId)) ||
              e.noteId == item.noteId)) {
            describe(replyId);
          }
        }
      }

      subscribedList.removeWhere(condition);
    });
  }

  late final QueueList<Note> newerNotes =
      NotifierQueueList(noteRepository, generalSettingsRepository, tabSetting);
  late final QueueList<Note> olderNotes =
      NotifierQueueList(noteRepository, generalSettingsRepository, tabSetting);

  void startTimeLine() {}

  void disconnect() {}

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future<void> reconnect() async {
    await globalNotificationRepository.reconnect();
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

  Future<int> previousLoad() async {
    return 0;
  }

  void subscribe(SubscribeItem item) {
    final index =
        subscribedList.indexWhere((element) => element.noteId == item.noteId);
    if (index == -1) {
      subscribedList.add(item);
    } else {
      subscribedList[index] = item;
    }
  }

  void preserveDescribe(String id) {
    final index = subscribedList.indexWhere((element) => element.noteId == id);
    if (index == -1) {
      // already described?
      return;
    }
    final item = subscribedList[index];

    subscribedList[index] = SubscribeItem(
      noteId: item.noteId,
      renoteId: item.renoteId,
      replyId: item.replyId,
      unsubscribedTime: DateTime.now(),
    );
  }

  void describe(String id) {}
}
