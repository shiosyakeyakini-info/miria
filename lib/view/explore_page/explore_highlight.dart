import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class ExploreHighlight extends HookConsumerWidget {
  const ExploreHighlight({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNote = useState(true);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3, left: 10),
            child: LayoutBuilder(
              builder: (context, constraints) => ToggleButtons(
                constraints: BoxConstraints.expand(
                  width: constraints.maxWidth / 2 -
                      Theme.of(context)
                              .toggleButtonsTheme
                              .borderWidth!
                              .toInt() *
                          2,
                ),
                onPressed: (index) => isNote.value = index == 0,
                isSelected: [
                  isNote.value,
                  !isNote.value,
                ],
                children: [
                  Text(S.of(context).note),
                  Text(S.of(context).searchVoteTab),
                ],
              ),
            ),
          ),
          Expanded(
            child: PushableListView(
              listKey: isNote.value,
              initializeFuture: () async {
                final Iterable<Note> note;
                if (isNote.value) {
                  note = await ref
                      .read(misskeyGetContextProvider)
                      .notes
                      .featured(const NotesFeaturedRequest());
                } else {
                  note = await ref
                      .read(misskeyGetContextProvider)
                      .notes
                      .polls
                      .recommendation(const NotesPollsRecommendationRequest());
                }
                ref.read(notesWithProvider).registerAll(note);
                return note.toList();
              },
              nextFuture: (item, index) async {
                final Iterable<Note> note;
                if (isNote.value) {
                  note =
                      await ref.read(misskeyGetContextProvider).notes.featured(
                            NotesFeaturedRequest(
                              offset: index,
                              untilId: item.id,
                            ),
                          );
                } else {
                  note = await ref
                      .read(misskeyGetContextProvider)
                      .notes
                      .polls
                      .recommendation(
                        NotesPollsRecommendationRequest(offset: index),
                      );
                }
                ref.read(notesWithProvider).registerAll(note);

                return note.toList();
              },
              itemBuilder: (context, item) => MisskeyNote(note: item),
            ),
          ),
        ],
      ),
    );
  }
}
