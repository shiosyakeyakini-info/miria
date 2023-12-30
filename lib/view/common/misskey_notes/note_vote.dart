import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteVote extends ConsumerStatefulWidget {
  const NoteVote({
    super.key,
    required this.displayNote,
    required this.poll,
  });

  final Note displayNote;
  final NotePoll poll;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteVoteState();
}

class NoteVoteState extends ConsumerState<NoteVote> {
  var isOpened = false;

  bool isAnyVotable() {
    final expiresAt = widget.poll.expiresAt;
    return (expiresAt == null || expiresAt > DateTime.now()) &&
        ((widget.poll.multiple && widget.poll.choices.any((e) => !e.isVoted)) ||
            (!widget.poll.multiple &&
                widget.poll.choices.every((e) => !e.isVoted)));
  }

  bool isVotable(int choice) {
    return isAnyVotable() &&
        ((!widget.poll.multiple) ||
            widget.poll.multiple && !widget.poll.choices[choice].isVoted);
  }

  @override
  void initState() {
    super.initState();

    if (!isAnyVotable()) {
      setState(() {
        isOpened = true;
      });
    }
  }

  Future<void> vote(int choice) async {
    // 複数投票可能ですでに対象を投票しているか、
    // 単一投票でいずれかを投票している場合、なにもしない
    if (!isVotable(choice)) {
      return;
    }
    final account = AccountScope.of(context);

    final dialogValue = await showDialog<bool>(
        context: context,
        builder: (context2) => SimpleConfirmDialog(
              message: "${widget.poll.choices[choice].text} に投票しますか？",
              primary: "投票する",
              secondary: "やっぱせえへん",
              isMfm: true,
              account: AccountScope.of(context),
            ));
    if (dialogValue == true) {
      await ref.read(misskeyProvider(account)).notes.polls.vote(
          NotesPollsVoteRequest(noteId: widget.displayNote.id, choice: choice));
      await ref.read(notesProvider(account)).refresh(widget.displayNote.id);
      if (!widget.poll.multiple) {
        if (!mounted) return;
        setState(() {
          isOpened = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalVotes = widget.poll.choices.map((e) => e.votes).sum;
    final expiresAt = widget.poll.expiresAt;
    final isExpired = expiresAt != null && expiresAt < DateTime.now();
    final differ = isExpired
        ? null
        : widget.poll.expiresAt?.difference(DateTime.now()).format;
    final colorTheme = AppTheme.of(context).colorTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        for (final choice in widget.poll.choices.mapIndexed(
            (index, element) => (index: index, element: element))) ...[
          SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5),
                  color: isOpened ? null : colorTheme.accentedBackground,
                  gradient: isOpened
                      ? LinearGradient(
                          colors: [
                            colorTheme.buttonGradateA,
                            colorTheme.buttonGradateB,
                            colorTheme.accentedBackground,
                          ],
                          stops: [
                            0,
                            choice.element.votes / totalVotes,
                            choice.element.votes / totalVotes,
                          ],
                        )
                      : null,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    vote(choice.index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(3),
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withAlpha(215),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: SimpleMfmText(
                          choice.element.text,
                          style: Theme.of(context).textTheme.bodyMedium,
                          prefixSpan: [
                            if (choice.element.isVoted)
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Icons.check,
                                  size: MediaQuery.textScalerOf(context).scale(
                                    Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.fontSize ??
                                        22,
                                  ),
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                          ],
                          suffixSpan: [
                            const WidgetSpan(
                                child: Padding(
                              padding: EdgeInsets.only(left: 5),
                            )),
                            if (isOpened)
                              TextSpan(
                                  text: "(${choice.element.votes}票)",
                                  style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
        Text.rich(TextSpan(
          children: [
            TextSpan(text: "計$totalVotes票・"),
            TextSpan(
              text: isExpired
                  ? "終了済み"
                  : !isOpened
                      ? "結果を見る"
                      : isAnyVotable()
                          ? "投票する"
                          : "投票済み",
              recognizer: TapGestureRecognizer()
                ..onTap = () => setState(() {
                      setState(() {
                        isOpened = !isOpened;
                      });
                    }),
            ),
            const WidgetSpan(
                child: Padding(
              padding: EdgeInsets.only(left: 10),
            )),
            TextSpan(text: differ == null ? "" : "あと$differ"),
          ],
          style: Theme.of(context).textTheme.bodySmall,
        ))
      ],
    );
  }
}
