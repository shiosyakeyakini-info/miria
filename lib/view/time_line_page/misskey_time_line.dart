import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/view/misskey_note.dart';
import 'package:flutter_misskey_app/view/note_detail_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MisskeyTimeline extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<TimeLineRepository> timeLineRepositoryProvider;
  final String type;

  const MisskeyTimeline(
      {super.key,
      required this.type,
      required this.timeLineRepositoryProvider});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyTimelineState();
}

class MisskeyTimelineState extends ConsumerState<MisskeyTimeline> {
  @override
  void didUpdateWidget(MisskeyTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    ref.read(widget.timeLineRepositoryProvider).startTimeLine();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(widget.timeLineRepositoryProvider).notes;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: notes.length,
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          final note = notes[notes.length - index - 1];
          return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => NoteDetailDialog(
                          note: note,
                          timeLineRepository: widget.timeLineRepositoryProvider,
                        ));
              },
              child: MisskeyNote(
                noteId: notes[notes.length - index - 1].id,
                timelineProvider: widget.timeLineRepositoryProvider,
              ));
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ref.read(widget.timeLineRepositoryProvider).disconnect();
  }
}
