import "package:collection/collection.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "note_vote.g.dart";

@Riverpod(dependencies: [misskeyPostContext, notesWith])
class NoteVoteNotifier extends _$NoteVoteNotifier {
  @override
  AsyncValue? build(Note note) => null;

  Future<bool> vote(int index) async {
    final poll = note.poll!;

    final dialogValue = await ref
        .read(dialogStateNotifierProvider.notifier)
        .showDialog(
          message: (context) =>
              S.of(context).confirmPoll(poll.choices[index].text),
          actions: (context) => [S.of(context).doVoting, S.of(context).cancel],
        );

    if (dialogValue != 0) return false;
    state = const AsyncLoading();

    state = await ref.read(dialogStateNotifierProvider.notifier).guard(
      () async {
        await ref
            .read(misskeyPostContextProvider)
            .notes
            .polls
            .vote(NotesPollsVoteRequest(noteId: note.id, choice: index));
        await ref.read(notesWithProvider).refresh(note.id);
      },
    );
    return true;
  }
}

class NoteVote extends HookConsumerWidget {
  const NoteVote({required this.displayNote, required this.poll, super.key});

  final Note displayNote;
  final NotePoll poll;

  bool isAnyVotable(WidgetRef ref) {
    if (!ref.read(accountContextProvider).isSame) return false;
    final expiresAt = poll.expiresAt;
    return (expiresAt == null || expiresAt > DateTime.now()) &&
        ((poll.multiple && poll.choices.any((e) => !e.isVoted)) ||
            (!poll.multiple && poll.choices.every((e) => !e.isVoted)));
  }

  bool isVotable(int choice, WidgetRef ref) {
    return isAnyVotable(ref) &&
        ((!poll.multiple) || poll.multiple && !poll.choices[choice].isVoted);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalVotes = poll.choices.map((e) => e.votes).sum;
    final expiresAt = poll.expiresAt;
    final isExpired = expiresAt != null && expiresAt < DateTime.now();
    final differ = isExpired
        ? null
        : poll.expiresAt?.difference(DateTime.now()).format(context);
    final colorTheme = AppTheme.of(context).colorTheme;

    // Hook状態ではなく、NoteRepositoryの状態を使用
    final noteRepository = ref.watch(notesProvider(ref.read(accountContextProvider).getAccount));
    final isOpened = noteRepository.getPollResultOpened(displayNote.id);

    ref.watch(noteVoteNotifierProvider(displayNote));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        for (final choice in poll.choices.mapIndexed(
          (index, element) => (index: index, element: element),
        )) ...[
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
                onPressed: () async {
                  // 複数投票可能ですでに対象を投票しているか、
                  // 単一投票でいずれかを投票している場合、なにもしない
                  if (!isVotable(choice.index, ref)) {
                    return;
                  }
                  final success = await ref
                      .read(noteVoteNotifierProvider(displayNote).notifier)
                      .vote(choice.index);
                  if (success) {
                    // 投票成功時は結果を表示状態にする
                    noteRepository.setPollResultOpened(displayNote.id, true);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(3),
                      color: Theme.of(
                        context,
                      ).scaffoldBackgroundColor.withAlpha(215),
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
                                  Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.fontSize ??
                                      22,
                                ),
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                            ),
                        ],
                        suffixSpan: [
                          const WidgetSpan(
                            child: Padding(padding: EdgeInsets.only(left: 5)),
                          ),
                          if (isOpened)
                            TextSpan(
                              text: S
                                  .of(context)
                                  .votesCount(choice.element.votes),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: S.of(context).totalVotesCount(totalVotes)),
              TextSpan(
                text: isExpired
                    ? S.of(context).finished
                    : !isOpened
                    ? S.of(context).openResult
                    : isAnyVotable(ref)
                    ? S.of(context).doVoting
                    : S.of(context).alreadyVoted,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => noteRepository.togglePollResult(displayNote.id),
              ),
              const WidgetSpan(
                child: Padding(padding: EdgeInsets.only(left: 10)),
              ),
              TextSpan(
                text: differ == null ? "" : S.of(context).remainDiffer(differ),
              ),
            ],
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
