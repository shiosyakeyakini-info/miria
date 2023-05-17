import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/misskey_note.dart';
import 'package:flutter_misskey_app/view/common/timeline_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyTimeline extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<TimeLineRepository> timeLineRepositoryProvider;
  final TimelineScrollController controller;

  MisskeyTimeline({
    super.key,
    TimelineScrollController? controller,
    required this.timeLineRepositoryProvider,
  }) : controller = controller ?? TimelineScrollController();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyTimelineState();
}

class MisskeyTimelineState extends ConsumerState<MisskeyTimeline> {
  List<Note> showingNotes = [];
  late final TimelineScrollController scrollController = widget.controller;
  bool isScrolling = false;
  late TimeLineRepository timelineRepository =
      ref.read(widget.timeLineRepositoryProvider);
  bool contextAccessed = false;

  bool isInitStated = false;

  @override
  void didUpdateWidget(covariant MisskeyTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    contextAccessed = true;
    if (oldWidget.timeLineRepositoryProvider !=
        widget.timeLineRepositoryProvider) {
      print("didUpdateWidget called. oldWidget=$oldWidget");
      ref.read(oldWidget.timeLineRepositoryProvider).disconnect();
      ref.read(widget.timeLineRepositoryProvider).startTimeLine();
      timelineRepository = ref.read(widget.timeLineRepositoryProvider);
    }
  }

  @override
  void initState() {
    super.initState();
    if (isInitStated) return;
    Future(() {
      ref.read(widget.timeLineRepositoryProvider).startTimeLine();
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
    final repository = ref.watch(widget.timeLineRepositoryProvider);

    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TimelineListView.builder(
          reverse: true,
          controller: scrollController,
          itemCount:
              repository.newerNotes.length + repository.olderNotes.length + 1,
          itemBuilder: (BuildContext context, int index) {
            // final corecctedIndex = index - 5;
            final correctedNewer = [
              if (timelineRepository.olderNotes.isNotEmpty)
                ...timelineRepository.olderNotes
                    .slice(0, min(4, timelineRepository.olderNotes.length - 1))
                    .reversed,
              ...timelineRepository.newerNotes,
            ];
            final correctedOlder = [
              if (timelineRepository.olderNotes.length > 5)
                ...timelineRepository.olderNotes
                    .slice(5, timelineRepository.olderNotes.length - 1)
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
              return Center(
                  child: IconButton(
                onPressed: () async {
                  await timelineRepository.previousLoad();
                },
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
  final TimeLineRepository timeline;

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
    widget.timeline.subscribe(widget.targetNote.id);
  }

  @override
  void dispose() {
    super.dispose();
    widget.timeline.describe(widget.targetNote.id);
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
