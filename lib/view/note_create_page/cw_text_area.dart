import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CwTextArea extends ConsumerStatefulWidget {
  const CwTextArea({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CwTextAreaState();
}

class CwTextAreaState extends ConsumerState<CwTextArea> {
  final cwController = TextEditingController();

  @override
  void initState() {
    super.initState();

    cwController.addListener(() {
      ref
          .watch(noteCreateProvider(AccountScope.of(context)).notifier)
          .setCwText(cwController.text);
    });
  }

  @override
  void dispose() {
    cwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      noteCreateProvider(AccountScope.of(context))
          .select((value) => value.cwText),
      (_, next) {
        if (next != cwController.text) cwController.text = next;
      },
    );

    final cw = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.isCw));

    if (!cw) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: cwController,
          keyboardType: TextInputType.multiline,
          decoration: AppTheme.of(context).noteTextStyle.copyWith(
              hintText: S.of(context).contentWarning,
              contentPadding: const EdgeInsets.all(5)),
        ),
      ),
    );
  }
}
