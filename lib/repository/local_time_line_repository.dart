import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class LocalTimeLineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  LocalTimeLineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.tabSetting,
  );

  @override
  void startTimeLine() {
    socketController = misskey.localTimelineStream((note) {
      newerNotes.add(note);

      // if (notes.length > 100) {
      //   notes.removeFirst();
      // }

      notifyListeners();
    }, (id, value) {
      print(value);
      final registeredNote = noteRepository.notes[id];
      if (registeredNote == null) return;
      final reaction = Map.of(registeredNote.reactions);
      reaction[value.reaction] = (reaction[value.reaction] ?? 0) + 1;
      noteRepository.registerNote(registeredNote.copyWith(reactions: reaction));
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
  }

  @override
  void dispose() {
    super.dispose();
    socketController?.disconnect();
    socketController = null;
  }

  final List<String> capturedId = [];

  @override
  void subscribe(String id) {
    if (!capturedId.contains(id)) {
      socketController?.send(ChannelDataType.subNote, id);
      capturedId.add(id);
    }
  }

  @override
  void describe(String id) {
    socketController?.send(ChannelDataType.unsubNote, id);
    capturedId.remove(id);
  }
}
