import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class FavoritedNotePage extends ConsumerWidget {
  final Account account;

  const FavoritedNotePage({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).favorite),
        ),
        body: AccountScope(
            account: account,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
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
                nextFuture: (lastItem, _) async {
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
