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
class FavoritedNotePage extends ConsumerWidget {
  final Account account;

  const FavoritedNotePage({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("お気に入り"),
        ),
        body: AccountScope(
            account: account,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: PushableListView(
                initializeFuture: () async {
                  final response = await ref
                      .read(misskeyProvider(account))
                      .i
                      .favorites(const IFavoritesRequest());
                  ref
                      .read(notesProvider(account))
                      .registerAll(response.map((e) => e.note));
                  return response.map((e) => e.note).toList();
                },
                nextFuture: (lastItem) async {
                  final response = await ref
                      .read(misskeyProvider(account))
                      .i
                      .favorites(IFavoritesRequest(untilId: lastItem.id));
                  ref
                      .read(notesProvider(account))
                      .registerAll(response.map((e) => e.note));
                  return response.map((e) => e.note).toList();
                },
                itemBuilder: (context, item) => MisskeyNote(note: item),
              ),
            )));
  }
}
