import "dart:async";
import "dart:math";

import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/repository/emoji_repository.dart";
import "package:miria/repository/time_line_repository.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "socket_timeline_repository.g.dart";

@Riverpod(keepAlive: true)
Future<StreamingController> misskeyStreaming(
  MisskeyStreamingRef ref,
  Misskey misskey,
) async {
  return await misskey.streamingService.stream();
}

abstract class SocketTimelineRepository extends TimelineRepository {
  final Misskey misskey;
  final Account account;
  late final EmojiRepository emojiRepository =
      ref.read(emojiRepositoryProvider(account));
  bool isReconnecting = false;
  late final AccountRepository accountRepository =
      ref.read(accountRepositoryProvider.notifier);

  StreamingController? streamingController;
  bool isLoading = true;
  (Object?, StackTrace)? error;
  Channel get channel;
  Map<String, dynamic> get parameters;
  String? timelineId;
  String? mainId;
  Ref ref;
  StreamSubscription<StreamingResponse>? timelineSubscription;
  StreamSubscription<StreamingResponse>? mainSubscription;

  SocketTimelineRepository(
    this.misskey,
    this.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    this.ref,
  );

  Future<Iterable<Note>> requestNotes({String? untilId});
  void reloadLatestNotes() {
    moveToOlder();
    unawaited(() async {
      final resultNotes = await requestNotes();
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
    }());
  }

  @override
  Future<void> startTimeLine() async {
    try {
      await emojiRepository.loadFromSourceIfNeed();
      // api/iおよびapi/metaはawaitしない
      unawaited(accountRepository.loadFromSourceIfNeed(tabSetting.acct));
      isLoading = false;
      error = null;
      notifyListeners();
    } catch (e, s) {
      error = (e, s);
      isLoading = false;
      notifyListeners();
    }

    if (misskey.streamingService.isClosed) {
      streamingController =
          await ref.refresh(misskeyStreamingProvider(misskey).future);
    } else {
      streamingController =
          await ref.read(misskeyStreamingProvider(misskey).future);
    }
    await _listenStreaming();
    await Future.wait([
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
      }),
    ]);
  }

  @override
  Future<void> disconnect() async {
    final id = timelineId;
    if (id != null) {
      await streamingController?.removeChannel(id);
      await timelineSubscription?.cancel();
    }
    final id2 = mainId;
    if (id2 != null) {
      await streamingController?.removeChannel(id2);
      await mainSubscription?.cancel();
    }
  }

  @override
  Future<void> reconnect() async {
    isReconnecting = true;
    try {
      await timelineSubscription?.cancel();
      await mainSubscription?.cancel();
      await (
        () async {
          await misskey.streamingService.reconnect();
          await _listenStreaming();
        }(),
        () async {
          reloadLatestNotes();
        }(),
      ).wait;
      error = null;
      isReconnecting = false;
      notifyListeners();
    } catch (e, s) {
      error = (e, s);
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
    unawaited(() async {
      final id = timelineId;
      if (id != null) {
        await streamingController?.removeChannel(id);
      }
      final id2 = mainId;
      if (id2 != null) {
        await streamingController?.removeChannel(id2);
      }
    }());
  }

  @override
  Future<void> subscribe(SubscribeItem item) async {
    if (!tabSetting.isSubscribe) return;
    await ref.read(misskeyStreamingProvider(misskey).future);
    final index =
        subscribedList.indexWhere((element) => element.noteId == item.noteId);
    final isSubscribed = subscribedList.indexWhere(
      (element) =>
          element.noteId == item.noteId ||
          element.renoteId == item.noteId ||
          element.replyId == item.noteId,
    );

    if (index == -1) {
      subscribedList.add(item);
      if (isSubscribed == -1) {
        streamingController?.subNote(item.noteId);
      }
    } else {
      subscribedList[index] = item;
    }

    final renoteId = item.renoteId;

    if (renoteId != null) {
      final isRenoteSubscribed = subscribedList.indexWhere(
        (element) =>
            element.noteId == renoteId ||
            element.renoteId == renoteId ||
            element.replyId == renoteId,
      );
      if (isRenoteSubscribed == -1) {
        streamingController?.subNote(renoteId);
      }
    }

    final replyId = item.replyId;
    if (replyId != null) {
      streamingController?.subNote(replyId);
      final isRenoteSubscribed = subscribedList.indexWhere(
        (element) =>
            element.noteId == replyId ||
            element.renoteId == replyId ||
            element.replyId == replyId,
      );
      if (isRenoteSubscribed == -1) {
        streamingController?.subNote(replyId);
      }
    }
  }

  @override
  Future<void> describe(String id) async {
    if (!tabSetting.isSubscribe) return;
    await ref.read(misskeyStreamingProvider(misskey).future);
    streamingController?.unsubNote(id);
  }

  Future<void> _listenStreaming() async {
    final generatedId = const Uuid().v4();
    timelineId = generatedId;
    final generatedId2 = const Uuid().v4();
    mainId = generatedId2;

    timelineSubscription = streamingController
        ?.addChannel(channel, parameters, generatedId)
        .listen(listenTimeline);
    mainSubscription =
        streamingController?.mainStream(id: generatedId2).listen(listenMain);
  }

  Future<void> listenMain(StreamingResponse response) async {
    switch (response) {
      case StreamingChannelResponse():
        return;
      case StreamingChannelNoteUpdatedResponse(:final body):
        switch (body) {
          case ReadAllNotificationsChannelEvent():
            await accountRepository.readAllNotification(account);
          case UnreadNotificationChannelEvent():
            await accountRepository.addUnreadNotification(account);
          case ReadAllAnnouncementsChannelEvent():
            await accountRepository.removeUnreadAnnouncement(account);
          case AnnouncementCreatedChannelEvent(:final body):
            await accountRepository.createUnreadAnnouncement(
              account,
              body.announcement,
            );
          case NoteChannelEvent():
          case StatsLogChannelEvent():
          case StatsChannelEvent():
          case UserAddedChannelEvent():
          case UserRemovedChannelEvent():
          case NotificationChannelEvent():
          case MentionChannelEvent():
          case ReplyChannelEvent():
          case RenoteChannelEvent():
          case FollowChannelEvent():
          case FollowedChannelEvent():
          case UnfollowChannelEvent():
          case MeUpdatedChannelEvent():
          case PageEventChannelEvent():
          case UrlUploadFinishedChannelEvent():
          case UnreadMentionChannelEvent():
          case ReadAllUnreadMentionsChannelEvent():
          case NotificationFlushedChannelEvent():
          case UnreadSpecifiedNoteChannelEvent():
          case ReadAllUnreadSpecifiedNotesChannelEvent():
          case ReadAllAntennasChannelEvent():
          case UnreadAntennaChannelEvent():
          case MyTokenRegeneratedChannelEvent():
          case SigninChannelEvent():
          case RegistryUpdatedChannelEvent():
          case DriveFileCreatedChannelEvent():
          case ReadAntennaChannelEvent():
          case ReceiveFollowRequestChannelEvent():
          case FallbackChannelEvent():
          case ReactedChannelEvent():
          case UnreactedChannelEvent():
          case DeletedChannelEvent():
          case PollVotedChannelEvent():
          case UpdatedChannelEvent():
        }
      case StreamingChannelEmojiAddedResponse():
      case StreamingChannelEmojiUpdatedResponse():
      case StreamingChannelEmojiDeletedResponse():
        await emojiRepository.loadFromSource();

      case StreamingChannelAnnouncementCreatedResponse(:final body):
        await accountRepository.createUnreadAnnouncement(
          account,
          body.announcement,
        );
      case StreamingChannelUnknownResponse():
      // TODO: Handle this case.
    }
  }

  Future<void> listenTimeline(StreamingResponse response) async {
    switch (response) {
      case StreamingChannelResponse(:final body):
        switch (body) {
          case NoteChannelEvent(:final body):
            newerNotes.add(body);
            notifyListeners();
          case ReadAllNotificationsChannelEvent():
          case UnreadNotificationChannelEvent():
          case ReadAllAnnouncementsChannelEvent():
          case AnnouncementCreatedChannelEvent():
          case StatsLogChannelEvent():
          case StatsChannelEvent():
          case UserAddedChannelEvent():
          case UserRemovedChannelEvent():
          case NotificationChannelEvent():
          case MentionChannelEvent():
          case ReplyChannelEvent():
          case RenoteChannelEvent():
          case FollowChannelEvent():
          case FollowedChannelEvent():
          case UnfollowChannelEvent():
          case MeUpdatedChannelEvent():
          case PageEventChannelEvent():
          case UrlUploadFinishedChannelEvent():
          case UnreadMentionChannelEvent():
          case ReadAllUnreadMentionsChannelEvent():
          case NotificationFlushedChannelEvent():
          case UnreadSpecifiedNoteChannelEvent():
          case ReadAllUnreadSpecifiedNotesChannelEvent():
          case ReadAllAntennasChannelEvent():
          case UnreadAntennaChannelEvent():
          case MyTokenRegeneratedChannelEvent():
          case SigninChannelEvent():
          case RegistryUpdatedChannelEvent():
          case DriveFileCreatedChannelEvent():
          case ReadAntennaChannelEvent():
          case ReceiveFollowRequestChannelEvent():
          case FallbackChannelEvent():
        }
      case StreamingChannelNoteUpdatedResponse(:final body):
        switch (body) {
          case ReactedChannelEvent(:final id, :final body):
            final registeredNote = noteRepository.notes[id];
            if (registeredNote == null) return;
            final reaction = Map.of(registeredNote.reactions);
            reaction[body.reaction] = (reaction[body.reaction] ?? 0) + 1;
            final emoji = body.emoji;
            final reactionEmojis = Map.of(registeredNote.reactionEmojis);
            if (emoji != null && !body.reaction.endsWith("@.:")) {
              reactionEmojis[emoji.name] = emoji.url;
            }
            noteRepository.registerNote(
              registeredNote.copyWith(
                reactions: reaction,
                reactionEmojis: reactionEmojis,
                myReaction: body.userId == account.i.id
                    ? (emoji?.name != null ? ":${emoji?.name}:" : null)
                    : registeredNote.myReaction,
              ),
            );
          case UnreactedChannelEvent(:final body, :final id):
            final registeredNote = noteRepository.notes[id];
            if (registeredNote == null) return;
            final reaction = Map.of(registeredNote.reactions);
            reaction[body.reaction] =
                max((reaction[body.reaction] ?? 0) - 1, 0);
            if (reaction[body.reaction] == 0) {
              reaction.remove(body.reaction);
            }
            final emoji = body.emoji;
            final reactionEmojis = Map.of(registeredNote.reactionEmojis);
            if (emoji != null && !body.reaction.endsWith("@.:")) {
              reactionEmojis[emoji.name] = emoji.url;
            }
            noteRepository.registerNote(
              registeredNote.copyWith(
                reactions: reaction,
                reactionEmojis: reactionEmojis,
                myReaction: body.userId == account.i.id
                    ? ""
                    : registeredNote.myReaction,
              ),
            );
          case PollVotedChannelEvent(:final body, :final id):
            final registeredNote = noteRepository.notes[id];
            if (registeredNote == null) return;

            final poll = registeredNote.poll;
            if (poll == null) return;

            final choices = poll.choices.toList();
            choices[body.choice] = choices[body.choice]
                .copyWith(votes: choices[body.choice].votes + 1);
            noteRepository.registerNote(
              registeredNote.copyWith(poll: poll.copyWith(choices: choices)),
            );
          case UpdatedChannelEvent(:final body):
            final note = noteRepository.notes[timelineId];
            if (note == null) return;
            noteRepository.registerNote(
              note.copyWith(
                text: body.text,
                cw: body.cw,
                updatedAt: DateTime.now(),
              ),
            );
          case DeletedChannelEvent():
        }
      case StreamingChannelEmojiAddedResponse():
      case StreamingChannelEmojiUpdatedResponse():
      case StreamingChannelEmojiDeletedResponse():
        await emojiRepository.loadFromSource();

      case StreamingChannelAnnouncementCreatedResponse(:final body):
        await accountRepository.createUnreadAnnouncement(
          account,
          body.announcement,
        );
      case StreamingChannelUnknownResponse():
      // TODO: Handle this case.
    }
  }
}
