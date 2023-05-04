import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ReactionButton extends ConsumerStatefulWidget {
  final String reactionKey;
  final int reactionCount;
  final String? myReaction;
  final String noteId;
  final String? anotherServerUrl;

  const ReactionButton({
    super.key,
    required this.reactionKey,
    required this.reactionCount,
    required this.myReaction,
    required this.noteId,
    required this.anotherServerUrl,
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
    final isAnotherServer = widget.anotherServerUrl != null;
    final backgroundColor = isMyReaction
        ? Theme.of(context).primaryColor
        : isAnotherServer
            ? Colors.transparent
            : MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey.shade200
                : Colors.grey.shade700;

    final computedLuminance = (backgroundColor == Colors.transparent
            ? Theme.of(context).scaffoldBackgroundColor
            : backgroundColor)
        .computeLuminance();

    return ElevatedButton(
        onPressed: () async {
          // リアクション取り消し
          final account = AccountScope.of(context);
          if (isMyReaction) {
            await ref
                .read(misskeyProvider(account))
                .notes
                .reactions
                .delete(NotesReactionsDeleteRequest(noteId: widget.noteId));

            await ref.read(notesProvider(account)).refresh(widget.noteId);

            return;
          }
          final customEmojiRegExp =
              RegExp(r"\:(.+?)@.\:").firstMatch(widget.reactionKey);
          final String? found = customEmojiRegExp?.group(1);

          // すでに別のリアクションを行っている
          if (widget.myReaction != null) return;

          if (found != null) {
            await ref.read(misskeyProvider(account)).notes.reactions.create(
                NotesReactionsCreateRequest(
                    noteId: widget.noteId, reaction: ":$found:"));
            await ref.read(notesProvider(account)).refresh(widget.noteId);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.all(5),
          elevation: 0,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 24 * MediaQuery.of(context).textScaleFactor,
                child: CustomEmoji.fromEmojiName(
                  widget.reactionKey,
                  ref.read(emojiRepositoryProvider(AccountScope.of(context))),
                  anotherServerUrl: widget.anotherServerUrl,
                )),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Text(widget.reactionCount.toString(),
                style: TextStyle(
                  color:
                      computedLuminance < 0.5 ? Colors.white : Colors.black54,
                )),
          ],
        ));
  }
}
