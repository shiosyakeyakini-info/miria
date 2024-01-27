import 'dart:async';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/extensions/note_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/model/timeline_state.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';

class TimelineRepository extends FamilyNotifier<TimelineState, TabSetting> {
  late SocketController _socketController;

  /// ノートのidとそのノートを現在参照しているノートの数の対応
  final _subscriptionCount = HashMap<String, int>();

  @override
  TimelineState build(TabSetting arg) {
    final timer = _tabSetting.isSubscribe
        ? Timer.periodic(
            const Duration(seconds: 10),
            (_) => _checkUnsubscribed(),
          )
        : null;
    Future(() {
      startTimeline();
    });
    ref.onDispose(() {
      disconnect();
      timer?.cancel();
    });
    return const TimelineState();
  }

  TabSetting get _tabSetting => arg;

  Account get _account => ref.read(accountProvider(_tabSetting.acct));

  Misskey get _misskey => ref.read(misskeyProvider(_account));

  SocketController _createSocketController({
    required void Function(Note note) onNoteReceived,
    required FutureOr<void> Function(String id, TimelineReacted reaction)
        onReacted,
    required FutureOr<void> Function(String id, TimelineReacted reaction)
        onUnreacted,
    required FutureOr<void> Function(String id, TimelineVoted vote) onVoted,
    required FutureOr<void> Function(String id, NoteEdited note) onUpdated,
  }) {
    return switch (_tabSetting.tabType) {
      TabType.localTimeline => _misskey.localTimelineStream(
          parameter: LocalTimelineParameter(
            withRenotes: _tabSetting.renoteDisplay,
            withReplies: _tabSetting.isIncludeReplies,
            withFiles: _tabSetting.isMediaOnly,
          ),
          onNoteReceived: onNoteReceived,
          onReacted: onReacted,
          onUnreacted: onUnreacted,
          onVoted: onVoted,
          onUpdated: onUpdated,
        ),
      TabType.homeTimeline => _misskey.homeTimelineStream(
          parameter: HomeTimelineParameter(
            withRenotes: _tabSetting.renoteDisplay,
            withFiles: _tabSetting.isMediaOnly,
          ),
          onNoteReceived: onNoteReceived,
          onReacted: onReacted,
          onUnreacted: onUnreacted,
          onVoted: onVoted,
          onUpdated: onUpdated,
        ),
      TabType.globalTimeline => _misskey.globalTimelineStream(
          parameter: GlobalTimelineParameter(
            withRenotes: _tabSetting.renoteDisplay,
            withFiles: _tabSetting.isMediaOnly,
          ),
          onNoteReceived: onNoteReceived,
          onReacted: onReacted,
          onUnreacted: onUnreacted,
          onVoted: onVoted,
          onUpdated: onUpdated,
        ),
      TabType.hybridTimeline => _misskey.hybridTimelineStream(
          parameter: HybridTimelineParameter(
            withRenotes: _tabSetting.renoteDisplay,
            withReplies: _tabSetting.isIncludeReplies,
            withFiles: _tabSetting.isMediaOnly,
          ),
          onNoteReceived: onNoteReceived,
          onReacted: onReacted,
          onUnreacted: onUnreacted,
          onVoted: onVoted,
          onUpdated: onUpdated,
        ),
      TabType.roleTimeline => _misskey.roleTimelineStream(
          roleId: _tabSetting.roleId!,
          onNoteReceived: onNoteReceived,
          onReacted: onReacted,
          onUnreacted: onUnreacted,
          onVoted: onVoted,
          // TODO: misskey_dartを修正
          // onUpdated: onUpdated,
        ),
      TabType.channel => _misskey.channelStream(
          channelId: _tabSetting.channelId!,
          onNoteReceived: onNoteReceived,
          onReacted: onReacted,
          onVoted: onVoted,
          onUpdated: onUpdated,
        ),
      TabType.userList => _misskey.userListStream(
          listId: _tabSetting.listId!,
          onNoteReceived: onNoteReceived,
          onReacted: onReacted,
          onUnreacted: onUnreacted,
          onVoted: onVoted,
          onUpdated: onUpdated,
        ),
      TabType.antenna => _misskey.antennaStream(
          antennaId: _tabSetting.antennaId!,
          onNoteReceived: onNoteReceived,
          onReacted: onReacted,
          onUnreacted: onUnreacted,
          onVoted: onVoted,
          onUpdated: onUpdated,
        ),
    };
  }

  Future<Iterable<Note>> _requestNotes({
    int? limit,
    String? untilId,
  }) {
    return switch (_tabSetting.tabType) {
      TabType.localTimeline => _misskey.notes.localTimeline(
          NotesLocalTimelineRequest(
            limit: limit,
            untilId: untilId,
            withRenotes: _tabSetting.renoteDisplay,
            withReplies: _tabSetting.isIncludeReplies,
            withFiles: _tabSetting.isMediaOnly,
          ),
        ),
      TabType.homeTimeline => _misskey.notes.homeTimeline(
          NotesTimelineRequest(
            limit: limit ?? 30,
            untilId: untilId,
            withRenotes: _tabSetting.renoteDisplay,
            withFiles: _tabSetting.isMediaOnly,
          ),
        ),
      TabType.globalTimeline => _misskey.notes.globalTimeline(
          NotesGlobalTimelineRequest(
            limit: limit,
            untilId: untilId,
            withRenotes: _tabSetting.renoteDisplay,
            withFiles: _tabSetting.isMediaOnly,
          ),
        ),
      TabType.hybridTimeline => _misskey.notes.hybridTimeline(
          NotesHybridTimelineRequest(
            limit: limit,
            untilId: untilId,
            withRenotes: _tabSetting.renoteDisplay,
            withReplies: _tabSetting.isIncludeReplies,
            withFiles: _tabSetting.isMediaOnly,
          ),
        ),
      TabType.roleTimeline => _misskey.roles.notes(
          RolesNotesRequest(
            roleId: _tabSetting.roleId!,
            limit: limit,
            untilId: untilId,
          ),
        ),
      TabType.channel => _misskey.channels.timeline(
          ChannelsTimelineRequest(
            channelId: _tabSetting.channelId!,
            limit: limit,
            untilId: untilId,
          ),
        ),
      TabType.userList => _misskey.notes.userListTimeline(
          UserListTimelineRequest(
            listId: _tabSetting.listId!,
            limit: limit,
            untilId: untilId,
            withRenotes: _tabSetting.renoteDisplay,
            withFiles: _tabSetting.isMediaOnly,
          ),
        ),
      TabType.antenna => _misskey.antennas.notes(
          AntennasNotesRequest(
            antennaId: _tabSetting.antennaId!,
            limit: limit,
            untilId: untilId,
          ),
        ),
    };
  }

  Future<void> startTimeline({bool restart = false}) async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(
      isLoading: true,
      isDownDirectionLoading: false,
      isLastLoaded: false,
      error: null,
    );

    final noteRepository = ref.read(notesProvider(_account));

    try {
      if (restart) {
        _misskey.streamingService.close();
      }
      _socketController = _createSocketController(
        onNoteReceived: (note) {
          noteRepository.registerNote(note);
          state = state.copyWith(newerNotes: [...state.newerNotes, note]);
        },
        onReacted: noteRepository.addReaction,
        onUnreacted: noteRepository.removeReaction,
        onVoted: noteRepository.addVote,
        onUpdated: noteRepository.updateNote,
      );
      ref
          .read(accountRepositoryProvider.notifier)
          .loadFromSourceIfNeed(_tabSetting.acct);
      await Future.wait([
        ref.read(mainStreamRepositoryProvider(_account)).reconnect(),
        ref.read(emojiRepositoryProvider(_account)).loadFromSourceIfNeed(),
        if (state.olderNotes.isEmpty)
          downDirectionLoad()
        else
          _reloadLatestNotes(),
        _misskey.startStreaming(),
      ]);
    } catch (e, st) {
      state = state.copyWith(error: (e, st));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> downDirectionLoad() async {
    if (state.isDownDirectionLoading) return;
    state = state.copyWith(isDownDirectionLoading: true);
    try {
      final notes = await _requestNotes(untilId: state.oldestNote?.id);
      ref.read(notesProvider(_account)).registerAll(notes);
      state = state.copyWith(
        olderNotes: [...state.olderNotes, ...notes],
        isLastLoaded: notes.isEmpty,
      );
    } finally {
      state = state.copyWith(isDownDirectionLoading: false);
    }
  }

  Future<void> _reloadLatestNotes() async {
    moveToOlder();

    final notes = await _requestNotes();
    if (notes.isEmpty) {
      return;
    }

    ref.read(notesProvider(_account)).registerAll(notes);

    if (state.olderNotes.isEmpty ||
        state.olderNotes.first.createdAt < notes.last.createdAt) {
      state = state.copyWith(olderNotes: notes.toList());
    } else {
      state = state.copyWith(
        olderNotes: [
          ...notes.where(
            (note) => state.olderNotes.first.createdAt < note.createdAt,
          ),
          ...state.olderNotes,
        ],
      );
    }
  }

  void disconnect() {
    _socketController.disconnect();
  }

  void moveToOlder() {
    state = state.copyWith(
      newerNotes: [],
      olderNotes: [...state.newerNotes.reversed, ...state.olderNotes],
    );
  }

  void subscribe(Note note) {
    if (!_tabSetting.isSubscribe) return;

    final renoteId = note.renoteId;
    final replyId = note.replyId;

    if (!note.isEmptyRenote) {
      _subscribe(note.id);
    }
    if (renoteId != null) {
      _subscribe(renoteId);
    }
    if (replyId != null) {
      _subscribe(replyId);
    }
  }

  void _subscribe(String id) {
    _subscriptionCount.update(
      id,
      (count) => count + 1,
      ifAbsent: () {
        _socketController.subNote(id);
        return 1;
      },
    );
  }

  void _checkUnsubscribed() {
    _subscriptionCount.forEach((id, count) {
      if (count < 1) {
        _unsubscribe(id);
      }
    });
    _subscriptionCount.removeWhere((id, count) => count < 1);
  }

  void preserveUnsubscribe(Note note) {
    if (!_tabSetting.isSubscribe) return;

    final renoteId = note.renoteId;
    final replyId = note.replyId;

    if (!note.isEmptyRenote) {
      _subscriptionCount.update(
        note.id,
        (count) => count - 1,
        ifAbsent: () => 0,
      );
    }
    if (renoteId != null) {
      _subscriptionCount.update(
        renoteId,
        (count) => count - 1,
        ifAbsent: () => 0,
      );
    }
    if (replyId != null) {
      _subscriptionCount.update(
        replyId,
        (count) => count - 1,
        ifAbsent: () => 0,
      );
    }
  }

  void _unsubscribe(String id) {
    _socketController.unsubNote(id);
  }
}
