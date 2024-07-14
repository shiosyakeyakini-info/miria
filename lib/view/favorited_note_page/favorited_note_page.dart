import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class FavoritedNotePage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const FavoritedNotePage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).favorite),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: PushableListView(
          initializeFuture: () async {
            final response = await ref
                .read(misskeyPostContextProvider)
                .i
                .favorites(const IFavoritesRequest());
            ref
                .read(notesWithProvider)
                .registerAll(response.map((e) => e.note));
            return response.map((e) => e.note).toList();
          },
          nextFuture: (lastItem, _) async {
            final response = await ref
                .read(misskeyPostContextProvider)
                .i
                .favorites(IFavoritesRequest(untilId: lastItem.id));
            ref
                .read(notesWithProvider)
                .registerAll(response.map((e) => e.note));
            return response.map((e) => e.note).toList();
          },
          itemBuilder: (context, item) => MisskeyNote(note: item),
        ),
      ),
    );
  }
}
