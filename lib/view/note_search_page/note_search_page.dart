import 'dart:ffi';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mfm_parser/mfm_parser.dart';
import 'package:mfm_renderer/mfm_renderer.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/settings_page/tab_settings_page/channel_select_dialog.dart';
import 'package:miria/view/user_page/user_list_item.dart';
import 'package:miria/view/user_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

final noteSearchProvider = StateProvider.autoDispose((ref) => "");
final noteSearchUserProvider = StateProvider.autoDispose<User?>((ref) => null);
final noteSearchChannelProvider =
    StateProvider.autoDispose<CommunityChannel?>((ref) => null);

@RoutePage()
class NoteSearchPage extends ConsumerStatefulWidget {
  final String? initialSearchText;
  final Account account;

  const NoteSearchPage({
    super.key,
    this.initialSearchText,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteSearchPageState();
}

class NoteSearchPageState extends ConsumerState<NoteSearchPage> {
  var isDetail = false;
  late final controller =
      TextEditingController(text: widget.initialSearchText ?? "");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final initial = widget.initialSearchText;
    if (initial != null) {
      Future(() {
        ref.read(noteSearchProvider.notifier).state = initial;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedUser = ref.watch(noteSearchUserProvider);
    final selectedChannel = ref.watch(noteSearchChannelProvider);
    return AccountScope(
        account: widget.account,
        child: Scaffold(
            appBar: AppBar(
              title: Text("ノート検索"),
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                            ),
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              ref.read(noteSearchProvider.notifier).state =
                                  value;
                            }),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isDetail = !isDetail;
                            });
                          },
                          icon: isDetail
                              ? const Icon(Icons.keyboard_arrow_up)
                              : const Icon(Icons.keyboard_arrow_down))
                    ],
                  ),
                ),
                if (isDetail)
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "これらはハッシュタグでは機能しません。",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Table(
                                columnWidths: {
                                  0: IntrinsicColumnWidth(),
                                  1: IntrinsicColumnWidth(),
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    Text("ユーザー"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                            child: selectedUser == null
                                                ? Container()
                                                : UserListItem(
                                                    user: selectedUser)),
                                        IconButton(
                                            onPressed: () async {
                                              final selected =
                                                  await showDialog<User?>(
                                                      context: context,
                                                      builder: (context) =>
                                                          UserSelectDialog(
                                                            account:
                                                                widget.account,
                                                          ));

                                              ref
                                                  .read(noteSearchUserProvider
                                                      .notifier)
                                                  .state = selected;
                                            },
                                            icon: const Icon(
                                                Icons.keyboard_arrow_right))
                                      ],
                                    )
                                  ]),
                                  TableRow(children: [
                                    Text("チャンネル"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                            child: selectedChannel == null
                                                ? Container()
                                                : Text(selectedChannel.name)),
                                        IconButton(
                                            onPressed: () async {
                                              final selected = await showDialog<
                                                      CommunityChannel?>(
                                                  context: context,
                                                  builder: (context) =>
                                                      ChannelSelectDialog(
                                                        account: widget.account,
                                                      ));
                                              ref
                                                  .read(
                                                      noteSearchChannelProvider
                                                          .notifier)
                                                  .state = selected;
                                            },
                                            icon: Icon(
                                                Icons.keyboard_arrow_right))
                                      ],
                                    )
                                  ])
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
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: NoteSearchList()))
              ],
            )));
  }
}

class NoteSearchList extends ConsumerWidget {
  const NoteSearchList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchValue = ref.watch(noteSearchProvider);
    final channel = ref.watch(noteSearchChannelProvider);
    final user = ref.watch(noteSearchUserProvider);
    final account = AccountScope.of(context);
    final parsedSearchValue = const MfmParser().parse(searchValue);
    final isHashtagOnly =
        parsedSearchValue.length == 1 && parsedSearchValue[0] is MfmHashTag;

    if (searchValue.isEmpty && channel == null && user == null) {
      return Container();
    }

    return PushableListView(
        listKey: Object.hashAll([
          searchValue,
          user?.id,
          channel?.id,
        ]),
        initializeFuture: () async {
          final Iterable<Note> notes;
          if (isHashtagOnly) {
            notes = await ref.read(misskeyProvider(account)).notes.searchByTag(
                NotesSearchByTagRequest(
                    tag: (parsedSearchValue[0] as MfmHashTag).hashTag));
          } else {
            notes = await ref.read(misskeyProvider(account)).notes.search(
                NotesSearchRequest(
                    query: searchValue,
                    userId: user?.id,
                    channelId: channel?.id));
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
                    query: searchValue,
                    userId: user?.id,
                    channelId: channel?.id,
                    untilId: lastItem.id));
          }
          ref.read(notesProvider(account)).registerAll(notes);
          return notes.toList();
        },
        itemBuilder: (context, item) {
          return MisskeyNote(note: item);
        });
  }
}
