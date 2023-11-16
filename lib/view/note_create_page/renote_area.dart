import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';

class RenoteArea extends ConsumerWidget {
  const RenoteArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renote = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.renote));

    if (renote != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RN:",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            padding: const EdgeInsets.all(5),
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(0.8)),
              child: MisskeyNote(note: renote),
            ),
          ),
        ],
      );
    }

    return Container();
  }
}
