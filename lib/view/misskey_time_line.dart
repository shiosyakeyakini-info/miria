import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/misskey_note.dart';
import 'package:flutter_misskey_app/view/note_detail_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyTimeline extends ConsumerStatefulWidget {
  const MisskeyTimeline({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyTimelineState();
}

class MisskeyTimelineState extends ConsumerState<MisskeyTimeline> {
  final textEditingController = TextEditingController();

  void note() {
    ref.read(misskeyProvider).notes.create(NotesCreateRequest(
          text: textEditingController.value.text,
        ));
    textEditingController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(localTimeLineProvider).startTimeLine();
    ref.read(emojiRepositoryProvider).loadFromSource();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(localTimeLineProvider).notes;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[notes.length - index - 1];
            return GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => NoteDetailDialog(note: note));
                },
                child: MisskeyNote(note: notes[notes.length - index - 1]));
          },
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              controller: textEditingController,
            ),
          )),
          IconButton(onPressed: note, icon: const Icon(Icons.edit)),
        ],
      ),
    );
  }
}
