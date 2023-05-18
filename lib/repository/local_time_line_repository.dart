import 'package:miria/repository/time_line_repository.dart';
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

  @override
  void subscribe(SubscribeItem item) {
    super.subscribe(item);
    socketController?.send(ChannelDataType.subNote, item.noteId);
    final renoteId = item.renoteId;
    if (renoteId != null) {
      socketController?.send(ChannelDataType.subNote, renoteId);
    }

    final replyId = item.replyId;
    if (replyId != null) {
      socketController?.send(ChannelDataType.subNote, replyId);
    }
  }

  @override
  void describe(String id) {
    socketController?.send(ChannelDataType.unsubNote, id);
  }
}
