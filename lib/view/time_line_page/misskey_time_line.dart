import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/view/common/misskey_note.dart';
import 'package:flutter_misskey_app/view/note_detail_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyTimeline extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<TimeLineRepository> timeLineRepositoryProvider;

  const MisskeyTimeline({super.key, required this.timeLineRepositoryProvider});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyTimelineState();
}

class MisskeyTimelineState extends ConsumerState<MisskeyTimeline> {
  List<Note> showingNotes = [];
  final ScrollController scrollController = ScrollController();
  double previousPosition = 0.0;

  @override
  void didUpdateWidget(covariant MisskeyTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    ref.read(oldWidget.timeLineRepositoryProvider).disconnect();
    ref.read(widget.timeLineRepositoryProvider).startTimeLine();
  }

  @override
  void initState() {
    super.initState();
    // ref.read(widget.timeLineRepositoryProvider).startTimeLine();

    /*scrollController.addListener(() {
      final currentPositon = scrollController.position.pixels;
      if (currentPositon != 0 && previousPosition == 0) {
        showingNotes = ref.watch(widget.timeLineRepositoryProvider).notes;
      } else if (currentPositon == 0) {
        showingNotes = [];
      }
      previousPosition = 0;
    });*/
  }

  @override
  void dispose() {
    ref.read(widget.timeLineRepositoryProvider).disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Note> notes;
    if (showingNotes.isEmpty) {
      notes = ref.watch(widget.timeLineRepositoryProvider).notes;
    } else {
      notes = showingNotes;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: notes.length,
        controller: scrollController,
        reverse: true,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
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

  const NoteWrapper(
      {super.key,
      required this.timeLineRepositoryProvider,
      required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(timeLineRepositoryProvider
        .select((repository) => repository.notes[index]));
    return MisskeyNote(
        noteId: note.id, timelineProvider: timeLineRepositoryProvider);
  }
}
