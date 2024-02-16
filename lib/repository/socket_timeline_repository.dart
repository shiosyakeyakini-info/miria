import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/repository/account_repository.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:miria/repository/main_stream_repository.dart';
import 'package:miria/repository/time_line_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

abstract class SocketTimelineRepository extends TimelineRepository {
  SocketController? socketController;
  final Misskey misskey;
  final Account account;
  final MainStreamRepository mainStreamRepository;
  final AccountRepository accountRepository;
  final EmojiRepository emojiRepository;
  bool isReconnecting = false;

  bool isLoading = true;
  (Object?, StackTrace)? error;

  SocketTimelineRepository(
    this.misskey,
    this.account,
    super.noteRepository,
    super.globalNotificationRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    this.mainStreamRepository,
    this.accountRepository,
    this.emojiRepository,
  );

  Future<Iterable<Note>> requestNotes({String? untilId});

  SocketController createSocketController({
    required void Function(Note note) onReceived,
    required FutureOr<void> Function(String id, TimelineReacted reaction)
        onReacted,
    required FutureOr<void> Function(String id, TimelineReacted reaction)
        onUnreacted,
    required FutureOr<void> Function(String id, TimelineVoted vote) onVoted,
    required FutureOr<void> Function(String id, NoteEdited vote) onUpdated,
  });

  void reloadLatestNotes() {
    moveToOlder();
    requestNotes().then((resultNotes) {
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
          // 取得済みの古いノートは
        } else {
          olderNotes.addFirst(note);
        }
        noteRepository.registerNote(note);
      }
      notifyListeners();
    });
  }

  @override
  Future<void> startTimeLine() async {
    try {
      await emojiRepository.loadFromSourceIfNeed();
      // api/iおよびapi/metaはawaitしない
      unawaited(Future(() async {
        await accountRepository.loadFromSourceIfNeed(tabSetting.acct);
      }));
      await mainStreamRepository.reconnect();
      isLoading = false;
      error = null;
      notifyListeners();
    } catch (e, s) {
      error = (e, s);
      isLoading = false;
      notifyListeners();
    }

    if (socketController != null) {
      socketController?.disconnect();
    }

    socketController = createSocketController(
      onReceived: (note) {
        newerNotes.add(note);

        notifyListeners();
      },
      onReacted: (id, value) {
        final registeredNote = noteRepository.notes[id];
        if (registeredNote == null) return;
        final reaction = Map.of(registeredNote.reactions);
        reaction[value.reaction] = (reaction[value.reaction] ?? 0) + 1;
        final emoji = value.emoji;
        final reactionEmojis = Map.of(registeredNote.reactionEmojis);
        if (emoji != null && !value.reaction.endsWith("@.:")) {
          reactionEmojis[emoji.name] = emoji.url;
        }
        noteRepository.registerNote(registeredNote.copyWith(
            reactions: reaction,
            reactionEmojis: reactionEmojis,
            myReaction: value.userId == account.i.id
                ? (emoji?.name != null ? ":${emoji?.name}:" : null)
                : registeredNote.myReaction));
      },
      onUnreacted: (id, value) {
        final registeredNote = noteRepository.notes[id];
        if (registeredNote == null) return;
        final reaction = Map.of(registeredNote.reactions);
        reaction[value.reaction] = max((reaction[value.reaction] ?? 0) - 1, 0);
        if (reaction[value.reaction] == 0) {
          reaction.remove(value.reaction);
        }
        final emoji = value.emoji;
        final reactionEmojis = Map.of(registeredNote.reactionEmojis);
        if (emoji != null && !value.reaction.endsWith("@.:")) {
          reactionEmojis[emoji.name] = emoji.url;
        }
        noteRepository.registerNote(registeredNote.copyWith(
            reactions: reaction,
            reactionEmojis: reactionEmojis,
            myReaction:
                value.userId == account.i.id ? "" : registeredNote.myReaction));
      },
      onVoted: (id, value) {
        final registeredNote = noteRepository.notes[id];
        if (registeredNote == null) return;

        final poll = registeredNote.poll;
        if (poll == null) return;

        final choices = poll.choices.toList();
        choices[value.choice] = choices[value.choice]
            .copyWith(votes: choices[value.choice].votes + 1);
        noteRepository.registerNote(
            registeredNote.copyWith(poll: poll.copyWith(choices: choices)));
      },
      onUpdated: (id, value) {
        final note = noteRepository.notes[id];
        if (note == null) return;
        noteRepository.registerNote(note.copyWith(
            text: value.text, cw: value.cw, updatedAt: DateTime.now()));
      },
    );
    Future.wait([
      Future(() async => await misskey.startStreaming()),
      Future(() async {
        if (olderNotes.isEmpty) {
          try {
            final resultNotes = await requestNotes();
            olderNotes.addAll(resultNotes);
            notifyListeners();
          } catch (e, s) {
            if (kDebugMode) {
              print(e);
              print(s);
            }
          }
        } else {
          reloadLatestNotes();
        }
      })
    ]);
  }

  @override
  void disconnect() {
    socketController?.disconnect();
  }

  @override
  Future<void> reconnect() async {
    if (isReconnecting) return;
    isReconnecting = true;
    notifyListeners();
    try {
      await super.reconnect();
      socketController = null;
      await startTimeLine();
      error = null;
    } finally {
      isReconnecting = false;
      notifyListeners();
    }
  }

  @override
  Future<int> previousLoad() async {
    if (newerNotes.isEmpty && olderNotes.isEmpty) {
      return -1;
    }
    final resultNotes = await requestNotes(
      untilId: olderNotes.lastOrNull?.id ?? newerNotes.first.id,
    );
    olderNotes.addAll(resultNotes);
    notifyListeners();
    return resultNotes.length;
  }

  @override
  void dispose() {
    super.dispose();
    socketController?.disconnect();
    socketController = null;
  }

  @override
  void subscribe(SubscribeItem item) {
    if (!tabSetting.isSubscribe) return;
    final index =
        subscribedList.indexWhere((element) => element.noteId == item.noteId);
    final isSubscribed = subscribedList.indexWhere((element) =>
        element.noteId == item.noteId ||
        element.renoteId == item.noteId ||
        element.replyId == item.noteId);

    if (index == -1) {
      subscribedList.add(item);
      if (isSubscribed == -1) {
        socketController?.subNote(item.noteId);
      }
    } else {
      subscribedList[index] = item;
    }

    final renoteId = item.renoteId;

    if (renoteId != null) {
      final isRenoteSubscribed = subscribedList.indexWhere((element) =>
          element.noteId == renoteId ||
          element.renoteId == renoteId ||
          element.replyId == renoteId);
      if (isRenoteSubscribed == -1) {
        socketController?.subNote(renoteId);
      }
    }

    final replyId = item.replyId;
    if (replyId != null) {
      socketController?.subNote(replyId);
      final isRenoteSubscribed = subscribedList.indexWhere((element) =>
          element.noteId == replyId ||
          element.renoteId == replyId ||
          element.replyId == replyId);
      if (isRenoteSubscribed == -1) {
        socketController?.subNote(replyId);
      }
    }
  }

  @override
  void describe(String id) {
    if (!tabSetting.isSubscribe) return;
    socketController?.unsubNote(id);
  }
}
