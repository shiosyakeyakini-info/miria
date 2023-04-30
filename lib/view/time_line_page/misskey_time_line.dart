import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/view/common/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'dart:math';

class MisskeyTimeline extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<TimeLineRepository> timeLineRepositoryProvider;
  final ScrollController controller;

  MisskeyTimeline({
    super.key,
    ScrollController? controller,
    required this.timeLineRepositoryProvider,
  }) : controller = controller ?? ScrollController();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyTimelineState();
}

class MisskeyTimelineState extends ConsumerState<MisskeyTimeline> {
  List<Note> showingNotes = [];
  late final ScrollController scrollController = widget.controller;
  double previousPosition = 0.0;
  double previousMaxExtent = 0.0;
  bool isScrolling = false;

  @override
  void didUpdateWidget(covariant MisskeyTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
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

    scrollController.addListener(() {
      final currentPosition = scrollController.position.pixels;

      previousPosition = currentPosition;
      previousMaxExtent = scrollController.position.maxScrollExtent;
    });

    ref.read(widget.timeLineRepositoryProvider).startTimeLine();
  }

  @override
  void dispose() {
    ref.read(widget.timeLineRepositoryProvider).disconnect();
    super.dispose();
  }

  void scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final currentPosition = scrollController.position.pixels;
      if (previousPosition == previousMaxExtent &&
          scrollController.position.maxScrollExtent !=
              scrollController.position.pixels) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        previousPosition = scrollController.position.maxScrollExtent;
        previousMaxExtent = scrollController.position.maxScrollExtent;
      }
      if (previousPosition == previousMaxExtent) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          scrollToTop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Note> notes = ref.watch(widget.timeLineRepositoryProvider).notes;

    if (scrollController.positions.isNotEmpty) {
      scrollToTop();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: notes.length,
        controller: scrollController,
        reverse: true,
        itemBuilder: (context, index) {
          if (index == notes.length - 1) {
            scrollToTop();
          }
          return NoteWrapper(
            index: index,
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
    final note = ref.watch(timeLineRepositoryProvider
        .select((repository) => repository.notes[index]));
    return MisskeyNote(note: note);
  }
}
