import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class NotesAfterRenotePage extends ConsumerStatefulWidget {
  final Note note;
  final Account account;

  const NotesAfterRenotePage({
    super.key,
    required this.note,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotesAfterRenotePageState();
}

class _NotesAfterRenotePageState extends ConsumerState<NotesAfterRenotePage> {
  String? untilId;

  @override
  Widget build(BuildContext context) {
    final misskey = ref.watch(misskeyProvider(widget.account));

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).notesAfterRenote)),
      body: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: PushableListView<Note>(
          showAd: false,
          initializeFuture: () async {
            final (
              notesAfterRenote,
              lastRenoteId,
            ) = await getNotesAfterRenote(misskey);
            ref
                .read(notesProvider(widget.account))
                .registerAll(notesAfterRenote);
            setState(() {
              untilId = lastRenoteId;
            });
            return notesAfterRenote;
          },
          nextFuture: (_, __) async {
            final (
              notesAfterRenote,
              lastRenoteId,
            ) = await getNotesAfterRenote(
              misskey,
              untilId: untilId,
            );
            ref
                .read(notesProvider(widget.account))
                .registerAll(notesAfterRenote);
            setState(() {
              untilId = lastRenoteId;
            });
            return notesAfterRenote;
          },
          itemBuilder: (context, item) {
            return AccountScope(
              account: widget.account,
              child: MisskeyNote(note: item),
            );
          },
        ),
      ),
    );
  }

  /// 指定されたノートに対するリノートの次に投稿されたノートのリストと
  /// 取得した最後のリノートのIDを返す
  Future<(List<Note>, String?)> getNotesAfterRenote(
    Misskey misskey, {
    String? untilId,
  }) async {
    final renotesAndQuotes = await misskey.notes.renotes(
      NotesRenoteRequest(
        noteId: widget.note.id,
        untilId: untilId,
      ),
    );
    if (renotesAndQuotes.isEmpty) {
      return (List<Note>.empty(), untilId);
    }
    final lastRenoteId = renotesAndQuotes.last.id;
    final renotes = renotesAndQuotes.where((note) => isRenote(note));
    final notesAfterRenote = await Future.wait(
      renotes.map((renote) => getNoteAfterNote(misskey, renote)),
    );
    final notes = notesAfterRenote.nonNulls
        .where(
          (note) => note.renoteId == null && note.replyId == null,
        )
        .toList();
    if (notes.isEmpty) {
      // リノートがまだあるときに空のリストを返すと次が呼ばれなくなるため
      return getNotesAfterRenote(misskey, untilId: lastRenoteId);
    }
    return (notes, lastRenoteId);
  }

  /// 指定されたノートを投稿したユーザーがその次に投稿したノートを (あれば) 返す
  Future<Note?> getNoteAfterNote(Misskey misskey, Note note) async {
    final notes = await misskey.users.notes(
      UsersNotesRequest(
        userId: note.userId,
        sinceId: note.id,
        limit: 1,
      ),
    );
    return notes.singleOrNull;
  }

  /// 指定されたノートが引用ではないリノートかどうか
  bool isRenote(Note note) {
    return note.renoteId != null &&
        note.text == null &&
        note.fileIds.isEmpty &&
        note.poll == null;
  }
}
