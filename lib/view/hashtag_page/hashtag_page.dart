import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/misskey_note.dart';
import 'package:flutter_misskey_app/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class HashtagPage extends ConsumerWidget {
  final String hashtag;
  final Account account;

  const HashtagPage({
    super.key,
    required this.hashtag,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
        account: account,
        child: Scaffold(
          appBar: AppBar(title: Text(hashtag)),
          body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: PushableListView(
              initializeFuture: () async {
                final response = await ref
                    .read(misskeyProvider(account))
                    .notes
                    .searchByTag(NotesSearchByTagRequest(tag: hashtag));
                ref.read(notesProvider(account)).registerAll(response);
                return response.toList();
              },
              nextFuture: (lastItem) async {
                final response = await ref
                    .read(misskeyProvider(account))
                    .notes
                    .searchByTag(NotesSearchByTagRequest(
                        tag: hashtag, untilId: lastItem.id));
                ref.read(notesProvider(account)).registerAll(response);
                return response.toList();
              },
              itemBuilder: (context, item) => MisskeyNote(note: item),
            ),
          ),
        ));
  }
}
