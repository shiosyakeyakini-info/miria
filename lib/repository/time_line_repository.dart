import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:misskey_dart/misskey_dart.dart';

abstract class TimeLineRepository extends ChangeNotifier {
  final QueueList<Note> notes = QueueList();

  void startTimeLine() {}

  void disconnect() {}
  
}