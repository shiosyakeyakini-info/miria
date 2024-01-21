import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm_parser/mfm_parser.dart';
import 'package:miria/model/note_search_condition.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:miria/view/settings_page/tab_settings_page/channel_select_dialog.dart';
import 'package:miria/view/user_page/user_list_item.dart';
import 'package:miria/view/user_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final noteSearchProvider =
    StateProvider.autoDispose((ref) => const NoteSearchCondition());

class NoteSearch extends ConsumerStatefulWidget {
  final NoteSearchCondition? initialCondition;
  final FocusNode? focusNode;

  const NoteSearch({
    super.key,
    this.initialCondition,
    this.focusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteSearchState();
}

class NoteSearchState extends ConsumerState<NoteSearch> {
  var isDetail = false;
  late final controller = TextEditingController(
    text: widget.initialCondition?.query,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final initial = widget.initialCondition;
    if (initial != null) {
      Future(() {
        ref.read(noteSearchProvider.notifier).state = initial;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final condition = ref.watch(noteSearchProvider);
    final selectedUser = condition.user;
    final selectedChannel = condition.channel;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                  ),
                  focusNode: widget.focusNode,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    ref.read(noteSearchProvider.notifier).state =
                        condition.copyWith(query: value);
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isDetail = !isDetail;
                  });
                },
                icon: isDetail
                    ? const Icon(Icons.keyboard_arrow_up)
                    : const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
        if (isDetail)
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
                      Table(
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: IntrinsicColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            Text(S.of(context).user),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: selectedUser == null
                                      ? Container()
                                      : UserListItem(user: selectedUser),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      final selected = await showDialog<User?>(
                                        context: context,
                                        builder: (context2) => UserSelectDialog(
                                          account: AccountScope.of(context),
                                        ),
                                      );

                                      ref
                                          .read(noteSearchProvider.notifier)
                                          .state = condition.copyWith(
                                        user: selected,
                                      );
                                    },
                                    icon:
                                        const Icon(Icons.keyboard_arrow_right))
                              ],
                            )
                          ]),
                          TableRow(
                            children: [
                              Text(S.of(context).channel),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: selectedChannel == null
                                        ? Container()
                                        : Text(selectedChannel.name),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final selected =
                                          await showDialog<CommunityChannel?>(
                                        context: context,
                                        builder: (context2) =>
                                            ChannelSelectDialog(
                                          account: AccountScope.of(
                                            context,
                                          ),
                                        ),
                                      );
                                      ref
                                          .read(noteSearchProvider.notifier)
                                          .state = condition.copyWith(
                                        channel: selected,
                                      );
                                    },
                                    icon:
                                        const Icon(Icons.keyboard_arrow_right),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(S.of(context).onlyLocal),
                              Row(
                                children: [
                                  Checkbox(
                                    value: condition.localOnly,
                                    onChanged: (value) => ref
                                        .read(
                                          noteSearchProvider.notifier,
                                        )
                                        .state = condition.copyWith(
                                      localOnly: !condition.localOnly,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: NoteSearchList(),
          ),
        ),
      ],
    );
  }
}

class NoteSearchList extends ConsumerWidget {
  const NoteSearchList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final condition = ref.watch(noteSearchProvider);
    final account = AccountScope.of(context);
    final parsedSearchValue = const MfmParser().parse(condition.query ?? "");
    final isHashtagOnly =
        parsedSearchValue.length == 1 && parsedSearchValue[0] is MfmHashTag;

    if (condition.isEmpty) {
      return Container();
    }

    return PushableListView(
      listKey: condition.hashCode,
      initializeFuture: () async {
        final Iterable<Note> notes;
        if (isHashtagOnly) {
          notes = await ref.read(misskeyProvider(account)).notes.searchByTag(
                NotesSearchByTagRequest(
                  tag: (parsedSearchValue[0] as MfmHashTag).hashTag,
                ),
              );
        } else {
          notes = await ref.read(misskeyProvider(account)).notes.search(
                NotesSearchRequest(
                  query: condition.query ?? "",
                  userId: condition.user?.id,
                  channelId: condition.channel?.id,
                  host: condition.localOnly ? "." : null,
                ),
              );
        }

        ref.read(notesProvider(account)).registerAll(notes);
        return notes.toList();
      },
      nextFuture: (lastItem, _) async {
        final Iterable<Note> notes;
        if (isHashtagOnly) {
          notes = await ref.read(misskeyProvider(account)).notes.searchByTag(
                NotesSearchByTagRequest(
                  tag: (parsedSearchValue[0] as MfmHashTag).hashTag,
                  untilId: lastItem.id,
                ),
              );
        } else {
          notes = await ref.read(misskeyProvider(account)).notes.search(
                NotesSearchRequest(
                  query: condition.query ?? "",
                  userId: condition.user?.id,
                  channelId: condition.channel?.id,
                  host: condition.localOnly ? "." : null,
                  untilId: lastItem.id,
                ),
              );
        }
        ref.read(notesProvider(account)).registerAll(notes);
        return notes.toList();
      },
      itemBuilder: (context, item) {
        return MisskeyNote(note: item);
      },
    );
  }
}
