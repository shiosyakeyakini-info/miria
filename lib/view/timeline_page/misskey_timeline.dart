import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/timeline_repository.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/timeline_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyTimeline extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<TimelineRepository> timeLineRepositoryProvider;
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
  late TimelineRepository timelineRepository =
      ref.read(widget.timeLineRepositoryProvider);
  bool contextAccessed = false;

  bool isInitStated = false;
  bool isDownDirectionLoading = false;
  bool isLastLoaded = false;

  Future<void> downDirectionLoad() async {
    if (isDownDirectionLoading) return;
    Future(() async {
      try {
        if (!mounted) return;
        setState(() {
          isDownDirectionLoading = true;
        });
        final result = await timelineRepository.previousLoad();
        if (!mounted) return;
        setState(() {
          isDownDirectionLoading = false;
          isLastLoaded = result == 0;
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            isDownDirectionLoading = false;
          });
        }
        rethrow;
      }
    });
  }

  @override
  void didUpdateWidget(covariant MisskeyTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    contextAccessed = true;
    if (oldWidget.timeLineRepositoryProvider !=
        widget.timeLineRepositoryProvider) {
      ref.read(oldWidget.timeLineRepositoryProvider).disconnect();
      ref.read(widget.timeLineRepositoryProvider).startTimeline();
      timelineRepository = ref.read(widget.timeLineRepositoryProvider);
      isDownDirectionLoading = false;
      isLastLoaded = false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (isInitStated) return;
    Future(() {
      ref.read(widget.timeLineRepositoryProvider).startTimeline();
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
        padding: const EdgeInsets.only(right: 10),
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
                    .slice(0, min(5, timelineRepository.olderNotes.length))
                    .reversed,
              ...timelineRepository.newerNotes,
            ];
            final correctedOlder = [
              if (timelineRepository.olderNotes.length > 5)
                ...timelineRepository.olderNotes
                    .slice(5, timelineRepository.olderNotes.length)
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
              if (isLastLoaded) {
                return const SizedBox.shrink();
              }

              if (isDownDirectionLoading &&
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
    if (widget.targetNote.renoteId != null && widget.targetNote.text == null) {
      widget.timeline.subscribe(SubscribeItem(
        noteId: widget.targetNote.renoteId!,
        renoteId: null,
        replyId: null,
      ));
    } else {
      widget.timeline.subscribe(SubscribeItem(
        noteId: widget.targetNote.id,
        renoteId: widget.targetNote.renoteId,
        replyId: widget.targetNote.replyId,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.timeline.preserveDescribe(widget.targetNote.id);
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
