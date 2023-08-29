import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/timeline_page_state.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/timeline_page/timeline_note.dart';
import 'package:misskey_dart/misskey_dart.dart';

class TimelinePageController extends AutoDisposeNotifier<TimelinePageState> {
  @override
  TimelinePageState build() {
    final pageController = PageController();
    ref.onDispose(() {
      pageController.dispose();
    });
    return TimelinePageState(
      pageController: pageController,
      index: 0,
    );
  }

  TabSetting get _tabSetting {
    return ref
        .read(tabSettingsRepositoryProvider)
        .tabSettings
        .elementAt(state.index);
  }

  void changePage(int index) {
    state = state.copyWith(index: index);
  }

  void forceScrollToTop() {
    ref
        .read(timelineControllerProvider(_tabSetting).notifier)
        .forceScrollToTop();
  }

  Future<void> reconnect() async {
    await ref
        .read(timelineRepositoryProvider(_tabSetting).notifier)
        .startTimeline(restart: true);
    forceScrollToTop();
  }

  Future<void> note() async {
    final text = ref.read(timelineNoteProvider).value.text;
    if (text.isEmpty) return;
    try {
      final accountSettings = ref
          .read(accountSettingsRepositoryProvider)
          .fromAcct(_tabSetting.acct);
      ref.read(timelineNoteProvider).clear();
      FocusManager.instance.primaryFocus?.unfocus();

      final account = ref.read(accountProvider(_tabSetting.acct));
      await ref.read(misskeyProvider(account)).notes.create(
            NotesCreateRequest(
              text: text,
              channelId: _tabSetting.channelId,
              visibility: accountSettings.defaultNoteVisibility,
              localOnly: _tabSetting.channelId != null ||
                  accountSettings.defaultIsLocalOnly,
              reactionAcceptance: accountSettings.defaultReactionAcceptance,
            ),
          );
    } catch (e) {
      ref.read(timelineNoteProvider).text = text;
      rethrow;
    }
  }

  void noteCreateRoute(BuildContext context) {
    CommunityChannel? channel;
    final channelId = _tabSetting.channelId;
    if (channelId != null) {
      final timeline = ref.read(timelineRepositoryProvider(_tabSetting));
      final channelName = timeline.oldestNote?.channel?.name;

      channel = CommunityChannel(
        id: channelId,
        createdAt: DateTime.now(),
        name: channelName ?? channelId,
        pinnedNoteIds: [],
        usersCount: 0,
        notesCount: 0,
        isFollowing: false,
        isFavorited: false,
        hasUnreadNote: false,
        pinnedNotes: [],
      );
    }
    final sendText = ref.read(timelineNoteProvider).text;
    ref.read(timelineNoteProvider).text = "";
    context.pushRoute(
      NoteCreateRoute(
        channel: channel,
        initialText: sendText,
        initialAccount: ref.read(accountProvider(_tabSetting.acct)),
      ),
    );
  }

  void expandError() {
    state = state.copyWith(isErrorExpanded: true);
  }

  void foldError() {
    state = state.copyWith(isErrorExpanded: false);
  }
}
