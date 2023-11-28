import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreHighlight extends ConsumerStatefulWidget {
  const ExploreHighlight({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ExploreHighlightState();
}

class ExploreHighlightState extends ConsumerState<ExploreHighlight> {
  bool isNote = true;

  @override
  Widget build(BuildContext context) {
    final account = AccountScope.of(context);
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
                              2),
                  onPressed: (index) => setState(() {
                        isNote = index == 0;
                      }),
                  isSelected: [
                    isNote,
                    !isNote
                  ],
                  children: [
                    Text(S.of(context).note),
                    Text(S.of(context).searchVoteTab)
                  ]),
            ),
          ),
          Expanded(
            child: PushableListView(
              listKey: isNote,
              initializeFuture: () async {
                final Iterable<Note> note;
                if (isNote) {
                  note = await ref
                      .read(misskeyProvider(account))
                      .notes
                      .featured(const NotesFeaturedRequest());
                } else {
                  note = await ref
                      .read(misskeyProvider(account))
                      .notes
                      .polls
                      .recommendation(const NotesPollsRecommendationRequest());
                }
                ref.read(notesProvider(account)).registerAll(note);
                return note.toList();
              },
              nextFuture: (item, index) async {
                final Iterable<Note> note;
                if (isNote) {
                  note = await ref
                      .read(misskeyProvider(account))
                      .notes
                      .featured(NotesFeaturedRequest(
                        offset: index,
                        untilId: item.id,
                      ));
                } else {
                  note = await ref
                      .read(misskeyProvider(account))
                      .notes
                      .polls
                      .recommendation(
                          NotesPollsRecommendationRequest(offset: index));
                }
                ref.read(notesProvider(account)).registerAll(note);

                return note.toList();
              },
              itemBuilder: (context, item) => MisskeyNote(note: item),
            ),
          )
        ],
      ),
    );
  }
}
