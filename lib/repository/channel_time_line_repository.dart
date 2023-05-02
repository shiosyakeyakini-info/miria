import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelTimelineRepository extends TimeLineRepository {
  SocketController? socketController;

  final Misskey misskey;
  final String channelId;

  ChannelTimelineRepository(this.misskey, this.channelId);

  void reloadLatestNotes() {
    misskey.channels
        .timeline(ChannelsTimelineRequest(channelId: channelId, limit: 30))
        .then((resultNotes) {
      for (final note in resultNotes) {
        final foundNote = notes.indexWhere((element) => element.id == note.id);
        if (foundNote == -1) {
          if (note.createdAt < notes.last.createdAt) {
            notes.addFirst(note);
          } else {
            notes.addLast(note);
          }
        } else {
          notes[foundNote] = note;
        }
      }
      notifyListeners();
    });
  }

  @override
  void startTimeLine() {
    if (notes.isEmpty) {
      misskey.channels
          .timeline(ChannelsTimelineRequest(channelId: channelId, limit: 30))
          .then((resultNotes) {
        for (final note in resultNotes.toList().reversed) {
          notes.addLast(note);
        }
        notifyListeners();
      }, onError: (e, s) {
        print(e);
        print(s);
      });
    } else {
      reloadLatestNotes();
    }

    socketController = misskey.channelStream(channelId, (note) {
      notes.add(note);

      notifyListeners();
    })
      ..startStreaming();
  }

  @override
  void disconnect() {
    socketController?.disconnect();
  }

  @override
  void reconnect() {
    socketController?.reconnect();
    reloadLatestNotes();
  }

  @override
  void previousLoad() {
    if (notes.isEmpty) {
      return;
    }
    misskey.channels
        .timeline(
      ChannelsTimelineRequest(
        channelId: channelId,
        limit: 30,
        untilId: notes.first.id,
      ),
    )
        .then(
      (resultNotes) {
        for (final note in resultNotes) {
          notes.addFirst(note);
        }
        notifyListeners();
      },
    );
  }
}
