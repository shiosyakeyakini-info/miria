import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ClipModalSheet extends ConsumerStatefulWidget {
  final Account account;
  final String noteId;

  const ClipModalSheet({
    super.key,
    required this.account,
    required this.noteId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ClipModalSheetState();
}

class ClipModalSheetState extends ConsumerState<ClipModalSheet> {
  var isLoading = false;

  List<Clip> userClips = [];
  List<Clip> noteClips = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future(() async {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      userClips = (await ref.read(misskeyProvider(widget.account)).clips.list())
          .toList();
      noteClips = (await ref
              .read(misskeyProvider(widget.account))
              .notes
              .clips(NotesClipsRequest(noteId: widget.noteId)))
          .toList();

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }).expectFailure(context);
  }

  Future<void> remove(Clip clip) async {
    await ref.read(misskeyProvider(widget.account)).clips.removeNote(
        ClipsRemoveNoteRequest(clipId: clip.id, noteId: widget.noteId));
    setState(() {
      noteClips.remove(clip);
    });
  }

  Future<void> add(Clip clip) async {
    try {
      await ref
          .read(misskeyProvider(widget.account))
          .clips
          .addNote(ClipsAddNoteRequest(clipId: clip.id, noteId: widget.noteId));
      setState(() {
        noteClips.add(clip);
      });
    } catch (e) {
      //TODO: あとでなおす
      if (e is DioError && e.response?.data != null) {
        if ((e.response?.data as Map?)?["error"]?["code"] ==
            "ALREADY_CLIPPED") {
          final result = await SimpleConfirmDialog.show(
              context: context,
              message: "すでにクリップに追加されたノートのようです。",
              primary: "クリップから削除する",
              secondary: "なにもしない");
          if (result == true) {
            await remove(clip);
          }
          return;
        }
      }

      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return ListView.builder(
        itemCount: userClips.length,
        itemBuilder: (context, index) {
          final isCliped =
              noteClips.any((element) => element.id == userClips[index].id);
          return ListTile(
            leading: isCliped
                ? const Icon(Icons.check)
                : SizedBox(width: Theme.of(context).iconTheme.size),
            onTap: () {
              if (isCliped) {
                remove(userClips[index]).expectFailure(context);
              } else {
                add(userClips[index]).expectFailure(context);
              }
            },
            title: Text(userClips[index].name ?? ""),
            subtitle: Text(userClips[index].description ?? ""),
          );
        });
  }
}
