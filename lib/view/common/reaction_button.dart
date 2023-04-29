import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ReactionButton extends ConsumerStatefulWidget {
  final String reactionKey;
  final int reactionCount;
  final String? myReaction;
  final String noteId;

  const ReactionButton({
    super.key,
    required this.reactionKey,
    required this.reactionCount,
    required this.myReaction,
    required this.noteId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ReactionButtonState();
}

class ReactionButtonState extends ConsumerState<ReactionButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isMyReaction = widget.myReaction == widget.reactionKey;

    return ElevatedButton(
        onPressed: () async {
          // リアクション取り消し
          if (isMyReaction) {
            await ref
                .read(misskeyProvider)
                .notes
                .reactions
                .delete(NotesReactionsDeleteRequest(noteId: widget.noteId));
            await ref.read(noteRefreshServiceProvider).refresh(widget.noteId);

            return;
          }

          // すでに別のリアクションを行っている
          if (widget.myReaction != null) return;

          final customEmojiRegExp =
              RegExp(r"\:(.+?)@.\:").firstMatch(widget.reactionKey);
          final String? found = customEmojiRegExp?.group(1);
          if (found != null) {
            await ref.read(misskeyProvider).notes.reactions.create(
                NotesReactionsCreateRequest(
                    noteId: widget.noteId, reaction: found));
            await ref.read(noteRefreshServiceProvider).refresh(widget.noteId);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(isMyReaction
              ? Colors.amberAccent.shade400
              : Colors.grey.shade200),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(5)),
          elevation: const MaterialStatePropertyAll(0),
          minimumSize: const MaterialStatePropertyAll(Size(0, 0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 24 * MediaQuery.of(context).textScaleFactor,
                child: CustomEmoji.fromEmojiName(widget.reactionKey,
                        ref.read(emojiRepositoryProvider)) ??
                    Container()),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Text(widget.reactionCount.toString(),
                style: const TextStyle(
                  color: Colors.black45,
                )),
          ],
        ));
  }
}
