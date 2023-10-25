import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/timeline_repository.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/timeline_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyTimeline extends ConsumerStatefulWidget {
  final TabSetting tabSetting;
  final TimelineScrollController controller;

  MisskeyTimeline({
    super.key,
    TimelineScrollController? controller,
    required this.tabSetting,
  }) : controller = controller ?? TimelineScrollController();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyTimelineState();
}

class MisskeyTimelineState extends ConsumerState<MisskeyTimeline> {
  List<Note> showingNotes = [];
  late final TimelineScrollController scrollController = widget.controller;
  bool isScrolling = false;
  late TimelineRepository timelineRepository =
      ref.read(timelineRepositoryProvider(widget.tabSetting).notifier);
  bool contextAccessed = false;

  bool isInitStated = false;

  Future<void> downDirectionLoad() async {
    Future(() async {
      await timelineRepository.downDirectionLoad();
    });
  }

  @override
  void didUpdateWidget(covariant MisskeyTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    contextAccessed = true;
    if (oldWidget.tabSetting != widget.tabSetting) {
      ref
          .read(timelineRepositoryProvider(oldWidget.tabSetting).notifier)
          .disconnect();
      ref
          .read(timelineRepositoryProvider(widget.tabSetting).notifier)
          .startTimeline();
      timelineRepository =
          ref.read(timelineRepositoryProvider(widget.tabSetting).notifier);
    }
  }

  @override
  void initState() {
    super.initState();
    if (isInitStated) return;
    Future(() {
      ref
          .read(timelineRepositoryProvider(widget.tabSetting).notifier)
          .startTimeline();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (contextAccessed) timelineRepository.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    if (scrollController.positions.isNotEmpty) {
      scrollController.scrollToTop();
    }
    final repository = ref.watch(timelineRepositoryProvider(widget.tabSetting));

    return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: TimelineListView.builder(
          reverse: true,
          controller: scrollController,
          itemCount:
              repository.newerNotes.length + repository.olderNotes.length + 1,
          itemBuilder: (BuildContext context, int index) {
            // final corecctedIndex = index - 5;
            final correctedNewer = [
              if (repository.olderNotes.isNotEmpty)
                ...repository.olderNotes
                    .slice(0, min(5, repository.olderNotes.length))
                    .reversed,
              ...repository.newerNotes,
            ];
            final correctedOlder = [
              if (repository.olderNotes.length > 5)
                ...repository.olderNotes.slice(5, repository.olderNotes.length)
            ];

            if (index > 0) {
              if ((index - 1) >= correctedNewer.length) {
                return null;
              }

              return NoteWrapper(
                targetNote: correctedNewer[index - 1],
                timeline: timelineRepository,
              );
            }

            if (-index == correctedOlder.length) {
              if (repository.isLastLoaded) {
                return const SizedBox.shrink();
              }

              if (repository.isDownDirectionLoading &&
                  repository.newerNotes.length + repository.olderNotes.length !=
                      0) {
                return const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(child: CircularProgressIndicator()));
              }

              if (ref.read(generalSettingsRepositoryProvider
                      .select((value) => value.settings.automaticPush)) ==
                  AutomaticPush.automatic) {
                downDirectionLoad();
              }

              return Center(
                  child: IconButton(
                onPressed: downDirectionLoad.expectFailure(context),
                icon: const Icon(Icons.keyboard_arrow_down),
              ));
            }

            if (-index >= correctedOlder.length) {
              return null;
            }

            return NoteWrapper(
              targetNote: correctedOlder[-index],
              timeline: timelineRepository,
            );
          },
        ));
  }
}

class NoteWrapper extends ConsumerStatefulWidget {
  final Note targetNote;
  final TimelineRepository timeline;

  const NoteWrapper({
    super.key,
    required this.targetNote,
    required this.timeline,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteWrapperState();
}

class NoteWrapperState extends ConsumerState<NoteWrapper> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.timeline.subscribe(widget.targetNote);
  }

  @override
  void dispose() {
    super.dispose();
    widget.timeline.preserveUnsubscribe(widget.targetNote);
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(notesProvider(AccountScope.of(context))
        .select((note) => note.notes[widget.targetNote.id]));
    if (note == null) {
      print("note was not found. ${widget.targetNote}");
      return MisskeyNote(
          note: widget.targetNote, key: ValueKey<String>(widget.targetNote.id));
    }
    return MisskeyNote(note: note, key: ValueKey<String>(note.id));
  }
}
