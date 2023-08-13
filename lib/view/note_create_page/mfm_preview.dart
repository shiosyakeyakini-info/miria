import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';

class MfmPreview extends ConsumerWidget {
  const MfmPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewText = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.text));

    final replyTo = ref
        .watch(noteCreateProvider(AccountScope.of(context))
            .select((value) => value.replyTo))
        .map((e) => "@${e.username}${e.host == null ? " " : "@${e.host}"} ")
        .join("");

    return Padding(
      padding: const EdgeInsets.all(5),
      child: MfmText(
        mfmText: "$replyTo$previewText",
        isNyaize: AccountScope.of(context).i.isCat,
      ),
    );
  }
}
