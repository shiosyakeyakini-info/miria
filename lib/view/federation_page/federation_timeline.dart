import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:misskey_dart/misskey_dart.dart';

import '../../model/account.dart';

class FederationTimeline extends ConsumerStatefulWidget {
  final String host;
  final MetaResponse meta;

  const FederationTimeline({
    super.key,
    required this.host,
    required this.meta,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FederationTimelineState();
}

class FederationTimelineState extends ConsumerState<FederationTimeline> {
  @override
  Widget build(BuildContext context) {
    final demoAccount = Account.demoAccount(widget.host, widget.meta);

    return AccountScope(
      account: demoAccount,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: PushableListView(
            initializeFuture: () async {
              final result = await ref
                  .read(misskeyProvider(demoAccount))
                  .notes
                  .localTimeline(const NotesLocalTimelineRequest());
              ref.read(notesProvider(demoAccount)).registerAll(result);
              return result.toList();
            },
            nextFuture: (lastItem, _) async {
              final result = await ref
                  .read(misskeyProvider(demoAccount))
                  .notes
                  .localTimeline(
                      NotesLocalTimelineRequest(untilId: lastItem.id));
              ref.read(notesProvider(demoAccount)).registerAll(result);
              return result.toList();
            },
            itemBuilder: (context2, item) => Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: MisskeyNote(
                  note: item,
                  loginAs: AccountScope.of(context),
                ))),
      ),
    );
  }
}
