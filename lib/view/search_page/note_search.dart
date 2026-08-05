import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:mfm_parser/mfm_parser.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/note_search_condition.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/date_time_picker.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";

class NoteSearch extends HookConsumerWidget {
  final NoteSearchCondition? initialCondition;
  final FocusNode? focusNode;

  const NoteSearch({super.key, this.initialCondition, this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditionController = useTextEditingController(
      text: initialCondition?.query,
    );
    final searchQuery = useState("");
    final selectedUser = useState(initialCondition?.user);
    final selectedChannel = useState(initialCondition?.channel);
    final localOnly = useState(initialCondition?.localOnly ?? false);
    final rangeStartAt = useState(initialCondition?.rangeStartAt);
    final rangeEndAt = useState(initialCondition?.rangeEndAt);
    final isDetail = useState(false);

    final selectedUserValue = selectedUser.value;
    final selectedChannelValue = selectedChannel.value;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: conditionController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                  ),
                  focusNode: focusNode,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) => searchQuery.value = value,
                ),
              ),
              IconButton(
                onPressed: () => isDetail.value = !isDetail.value,
                icon: isDetail.value
                    ? const Icon(Icons.keyboard_arrow_up)
                    : const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
        if (isDetail.value)
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        S.of(context).disabledInHashtag,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      ListTile(
                        title: selectedUserValue == null
                            ? Text(S.of(context).user)
                            : UserListItem(user: selectedUserValue),
                        onTap: () async {
                          final selected = await context.pushRoute<User?>(
                            UserSelectRoute(
                              accountContext: ref.read(accountContextProvider),
                            ),
                          );
                          selectedUser.value = selected;
                        },
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        title: selectedChannelValue == null
                            ? Text(S.of(context).channel)
                            : Text(selectedChannelValue.name),
                        onTap: () async {
                          final selected = await context
                              .pushRoute<CommunityChannel>(
                                ChannelSelectRoute(
                                  account: ref
                                      .read(accountContextProvider)
                                      .postAccount,
                                ),
                              );
                          selectedChannel.value = selected;
                        },
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      _DateTimeTile(
                        title: S.of(context).searchPostFrom,
                        value: rangeStartAt.value,
                        onChanged: (value) => rangeStartAt.value = value,
                      ),
                      _DateTimeTile(
                        title: S.of(context).searchPostTo,
                        value: rangeEndAt.value,
                        onChanged: (value) => rangeEndAt.value = value,
                      ),
                      CheckboxListTile(
                        title: Text(S.of(context).onlyLocal),
                        value: localOnly.value,
                        onChanged: (value) => localOnly.value = value ?? false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: NoteSearchList(
              query: searchQuery.value,
              localOnly: localOnly.value,
              channelId: selectedChannel.value?.id,
              userId: selectedUser.value?.id,
              rangeStartAt: rangeStartAt.value,
              rangeEndAt: rangeEndAt.value,
            ),
          ),
        ),
      ],
    );
  }
}

/// 投稿日時の範囲をひとつ指定するタイル。
class _DateTimeTile extends StatelessWidget {
  final String title;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const _DateTimeTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final current = value;
    return ListTile(
      title: Text(title),
      subtitle: current == null
          ? null
          : Text(current.formatUntilSeconds(context)),
      trailing: current == null
          ? const Icon(Icons.date_range)
          : IconButton(
              icon: const Icon(Icons.clear),
              tooltip: S.of(context).clear,
              onPressed: () => onChanged(null),
            ),
      onTap: () async {
        final result = await showDateTimePicker(
          context: context,
          initialDate: current ?? DateTime.now(),
          // Misskeyの誕生日より前を選ばせても意味がない
          firstDate: DateTime(2014),
          lastDate: DateTime.now().add(const Duration(days: 1)),
          datePickerHelpText: title,
          timePickerHelpText: title,
        );
        if (result != null) onChanged(result);
      },
    );
  }
}

class NoteSearchList extends ConsumerWidget {
  final String query;
  final bool localOnly;
  final String? channelId;
  final String? userId;
  final DateTime? rangeStartAt;
  final DateTime? rangeEndAt;

  const NoteSearchList({
    required this.query,
    required this.localOnly,
    super.key,
    this.channelId,
    this.userId,
    this.rangeStartAt,
    this.rangeEndAt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parsedSearchValue = const MfmParser().parse(query);
    final isHashtagOnly =
        parsedSearchValue.length == 1 && parsedSearchValue[0] is MfmHashTag;

    if (query.isEmpty) return const SizedBox.shrink();

    return PushableListView(
      listKey: Object.hash(
        query,
        localOnly,
        channelId,
        userId,
        rangeStartAt,
        rangeEndAt,
      ),
      initializeFuture: () async {
        final Iterable<Note> notes;
        if (isHashtagOnly) {
          notes = await ref
              .read(misskeyGetContextProvider)
              .notes
              .searchByTag(
                NotesSearchByTagRequest(
                  tag: (parsedSearchValue[0] as MfmHashTag).hashTag,
                ),
              );
        } else {
          notes = await ref
              .read(misskeyGetContextProvider)
              .notes
              .search(
                NotesSearchRequest(
                  query: query,
                  userId: userId,
                  channelId: channelId,
                  host: localOnly ? "." : null,
                  rangeStartAt: rangeStartAt,
                  rangeEndAt: rangeEndAt,
                ),
              );
        }

        ref.read(notesWithProvider).registerAll(notes);
        return notes.toList();
      },
      nextFuture: (lastItem, _) async {
        final Iterable<Note> notes;
        if (isHashtagOnly) {
          notes = await ref
              .read(misskeyGetContextProvider)
              .notes
              .searchByTag(
                NotesSearchByTagRequest(
                  tag: (parsedSearchValue[0] as MfmHashTag).hashTag,
                  untilId: lastItem.id,
                ),
              );
        } else {
          notes = await ref
              .read(misskeyGetContextProvider)
              .notes
              .search(
                NotesSearchRequest(
                  query: query,
                  userId: userId,
                  channelId: channelId,
                  host: localOnly ? "." : null,
                  rangeStartAt: rangeStartAt,
                  rangeEndAt: rangeEndAt,
                  untilId: lastItem.id,
                ),
              );
        }
        ref.read(notesWithProvider).registerAll(notes);
        return notes.toList();
      },
      itemBuilder: (context, item) {
        return MisskeyNote(note: item);
      },
    );
  }
}
