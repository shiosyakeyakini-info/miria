import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_content.dart';

class ReactionPickerDialog extends ConsumerStatefulWidget {
  final Account account;

  const ReactionPickerDialog({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReactionPickerDialogState();
}

class _ReactionPickerDialogState extends ConsumerState<ReactionPickerDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5),
      content: AccountScope(
        account: widget.account,
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: ReactionPickerContent(
              onTap: (emoji) => Navigator.of(context).pop(emoji),
            )),
      ),
    );
  }
}
