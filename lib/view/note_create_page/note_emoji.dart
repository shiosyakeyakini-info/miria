import 'package:flutter/material.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/note_create/input_completation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'note_create_page.dart';

class NoteEmoji extends ConsumerWidget {
  const NoteEmoji({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseHeight =
        (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 22) *
            MediaQuery.of(context).textScaleFactor *
            1.35;
    final account = ref.watch(selectedAccountProvider);
    if (account == null) return const SizedBox.shrink();
    return AccountScope(
      account: account,
      child: SizedBox(
          height: baseHeight + 40,
          child: InputComplement(
            controller: ref.read(noteInputTextProvider),
            focusNode: noteFocusProvider,
          )),
    );
  }
}
