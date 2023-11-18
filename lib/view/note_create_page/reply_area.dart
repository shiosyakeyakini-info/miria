import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';

class ReplyArea extends ConsumerWidget {
  const ReplyArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reply = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.reply));

    if (reply != null) {
      return MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(0.8)),
        child: MisskeyNote(note: reply),
      );
    }

    return Container();
  }
}
