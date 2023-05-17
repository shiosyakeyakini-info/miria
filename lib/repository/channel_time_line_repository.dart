import 'package:collection/collection.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelTimelineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;

  ChannelTimelineRepository(
    this.misskey,
    super.noteRepository,
    super.globalNotificationRepository,
    super.tabSetting,
  );

  void reloadLatestNotes() {
    moveToOlder();
    misskey.channels
        .timeline(ChannelsTimelineRequest(
            channelId: tabSetting.channelId!, limit: 30))
        .then((resultNotes) {
      if (olderNotes.isEmpty) {
        olderNotes.addAll(resultNotes);
        notifyListeners();
        return;
      }

      if (olderNotes.first.createdAt < resultNotes.last.createdAt) {
        olderNotes
          ..clear()
          ..addAll(resultNotes);
        notifyListeners();
        return;
      }

      for (final note in resultNotes.toList().reversed) {
        final index = olderNotes.indexWhere((element) => element.id == note.id);
        if (index != -1) {
          olderNotes[index] = note;
          noteRepository.registerNote(note);
        } else {
          olderNotes.addFirst(note);
        }
      }
      notifyListeners();
    });
  }

  @override
  void startTimeLine() {
    if (olderNotes.isEmpty) {
      misskey.channels
          .timeline(ChannelsTimelineRequest(
              channelId: tabSetting.channelId!, limit: 30))
          .then((resultNotes) {
        olderNotes.addAll(resultNotes);
        notifyListeners();
      }, onError: (e, s) {
        print(e);
        print(s);
      });
    } else {
      reloadLatestNotes();
    }

    socketController = misskey.channelStream(tabSetting.channelId!, (note) {
      newerNotes.add(note);

      notifyListeners();
    }, (id, value) {
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
    reloadLatestNotes();
  }

  @override
  Future<void> previousLoad() async {
    if (newerNotes.isEmpty && olderNotes.isEmpty) {
      return;
    }
    final resultNotes = await misskey.channels.timeline(
      ChannelsTimelineRequest(
        channelId: tabSetting.channelId!,
        limit: 30,
        untilId: olderNotes.lastOrNull?.id ?? newerNotes.first.id,
      ),
    );
    olderNotes.addAll(resultNotes);
    notifyListeners();
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
