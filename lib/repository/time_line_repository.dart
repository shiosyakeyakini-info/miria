import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:misskey_dart/misskey_dart.dart';


class LocalTimeLineRepository extends ChangeNotifier{

  late final SocketController socketController;

  final Misskey misskey;

  LocalTimeLineRepository(this.misskey);

  final QueueList<Note> notes = QueueList();

  void startTimeLine() {
    socketController = misskey.localTimelineStream((note) {
      notes.add(note);

      if(notes.length > 100) {
        notes.removeFirst();
      }
      
      notifyListeners();
    });
    socketController.startStreaming();
  }
}