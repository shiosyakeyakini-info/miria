import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/view/common/misskey_note.dart';
import 'package:flutter_misskey_app/view/time_line_page/timeline_scroll_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'dart:math';

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
  late final TimeLineRepository timelineRepository =
      ref.read(widget.timeLineRepositoryProvider);
  bool contextAccessed = false;

  final lastKey = GlobalKey();
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
    final List<Note> notes = ref.watch(widget.timeLineRepositoryProvider).notes;

    if (scrollController.positions.isNotEmpty) {
      scrollController.scrollToTop();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: notes.length + 2,
        controller: scrollController,
        reverse: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Center(
                child: IconButton(
              onPressed: () async {
                final firstNote = notes.first.id;
                await ref
                    .read(widget.timeLineRepositoryProvider)
                    .previousLoad();
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
              },
              icon: const Icon(Icons.keyboard_arrow_down),
            ));
          }

          if (index == notes.length + 1) {
            scrollController.scrollToTop();
            return Container(
              key: lastKey,
            );
          }

          return NoteWrapper(
            index: index - 1,
            timeLineRepositoryProvider: widget.timeLineRepositoryProvider,
          );
        },
      ),
    );
  }
}

class NoteWrapper extends ConsumerWidget {
  final int index;
  final ChangeNotifierProvider<TimeLineRepository> timeLineRepositoryProvider;

  const NoteWrapper({
    super.key,
    required this.timeLineRepositoryProvider,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.read(timeLineRepositoryProvider).notes.length <= index) {
      return Container();
    }
    final note = ref.watch(timeLineRepositoryProvider
        .select((repository) => repository.notes[index]));
    return MisskeyNote(note: note, key: ValueKey<String>(note.id));
  }
}
