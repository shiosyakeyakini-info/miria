import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_info_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";

class UserNotes extends HookConsumerWidget {
  final String userId;
  final String? remoteUserId;

  const UserNotes({
    required this.userId,
    super.key,
    this.remoteUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFileOnly = useState(false);
    final withReply = useState(false);
    final renote = useState(true);
    final highlight = useState(false);
    final untilDate = useState<DateTime?>(null);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, bottom: 3),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      isSelected: [
                        withReply.value,
                        isFileOnly.value,
                        renote.value,
                        highlight.value,
                      ],
                      onPressed: (value) {
                        switch (value) {
                          case 0:
                            withReply.value = !withReply.value;
                            if (withReply.value) {
                              isFileOnly.value = false;
                            }
                            highlight.value = false;
                          case 1:
                            isFileOnly.value = !isFileOnly.value;
                            if (isFileOnly.value) {
                              withReply.value = false;
                            }
                            highlight.value = false;
                          case 2:
                            renote.value = !renote.value;
                            highlight.value = false;
                          case 3:
                            withReply.value = false;
                            isFileOnly.value = false;
                            renote.value = false;
                            highlight.value = true;
                        }
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(S.of(context).includeRepliesShort),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(S.of(context).mediaOnlyShort),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(S.of(context).displayRenotesShort),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(S.of(context).highlight),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final userInfo = ref.read(
                    userInfoProxyProvider(userId)
                        .select((value) => value.requireValue),
                  );
                  final firstDate = ref.read(accountContextProvider).isSame
                      ? userInfo.response.createdAt
                      : userInfo.remoteResponse?.createdAt;

                  final result = await showDatePicker(
                    context: context,
                    initialDate: untilDate.value ?? DateTime.now(),
                    helpText: S.of(context).showNotesBeforeThisDate,
                    firstDate: firstDate ?? DateTime.now(),
                    lastDate: DateTime.now(),
                  );
                  if (result != null) {
                    untilDate.value = DateTime(
                      result.year,
                      result.month,
                      result.day,
                      23,
                      59,
                      59,
                      999,
                    );
                  }
                },
                icon: const Icon(Icons.date_range),
              ),
            ],
          ),
        ),
        Expanded(
          child: PushableListView<Note>(
            listKey: Object.hashAll(
              [
                isFileOnly.value,
                withReply.value,
                renote.value,
                untilDate.value,
                highlight.value,
              ],
            ),
            additionalErrorInfo: highlight.value
                ? (context, e) => Text(S.of(context).userHighlightAvailability)
                : null,
            initializeFuture: () async {
              final Iterable<Note> notes;
              if (highlight.value) {
                notes = await ref
                    .read(misskeyGetContextProvider)
                    .users
                    .featuredNotes(
                      UsersFeaturedNotesRequest(
                        userId: remoteUserId ?? userId,
                      ),
                    );
              } else {
                notes = await ref.read(misskeyGetContextProvider).users.notes(
                      UsersNotesRequest(
                        userId: remoteUserId ?? userId,
                        withFiles: isFileOnly.value,
                        // 後方互換性のため
                        includeReplies: withReply.value,
                        includeMyRenotes: renote.value,
                        withReplies: withReply.value,
                        withRenotes: renote.value,
                        withChannelNotes: true,
                        untilDate: untilDate.value,
                      ),
                    );
              }
              if (!context.mounted) return [];
              ref.read(notesWithProvider).registerAll(notes);
              return notes.toList();
            },
            nextFuture: (lastElement, _) async {
              final Iterable<Note> notes;
              if (highlight.value) {
                notes = await ref
                    .read(misskeyGetContextProvider)
                    .users
                    .featuredNotes(
                      UsersFeaturedNotesRequest(
                        userId: remoteUserId ?? userId,
                        untilId: lastElement.id,
                      ),
                    );
              } else {
                notes = await ref.read(misskeyGetContextProvider).users.notes(
                      UsersNotesRequest(
                        userId: remoteUserId ?? userId,
                        untilId: lastElement.id,
                        withFiles: isFileOnly.value,
                        includeReplies: withReply.value,
                        includeMyRenotes: renote.value,
                        withReplies: withReply.value,
                        withRenotes: renote.value,
                        withChannelNotes: true,
                        untilDate: untilDate.value,
                      ),
                    );
              }
              if (!context.mounted) return [];
              ref.read(notesWithProvider).registerAll(notes);
              return notes.toList();
            },
            itemBuilder: (context, element) {
              return MisskeyNote(note: element);
            },
          ),
        ),
      ],
    );
  }
}
