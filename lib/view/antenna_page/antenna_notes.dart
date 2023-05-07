import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/misskey_note.dart';
import 'package:flutter_misskey_app/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AntennaNotes extends ConsumerWidget {
  final String antennaId;

  const AntennaNotes({super.key, required this.antennaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    return PushableListView(
        initializeFuture: () async {
          final response = await ref
              .read(misskeyProvider(AccountScope.of(context)))
              .antennas
              .notes(AntennasNotesRequest(antennaId: antennaId));
          ref.read(notesProvider(account)).registerAll(response);
          return response.toList();
        },
        nextFuture: (lastItem) async {
          final response = await ref
              .read(misskeyProvider(AccountScope.of(context)))
              .antennas
              .notes(AntennasNotesRequest(
                  antennaId: antennaId, untilId: lastItem.id));
          ref.read(notesProvider(account)).registerAll(response);
          return response.toList();
        },
        itemBuilder: (context, item) => MisskeyNote(note: item));
  }
}
