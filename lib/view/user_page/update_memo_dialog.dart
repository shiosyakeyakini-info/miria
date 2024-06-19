import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/view/user_page/user_info_notifier.dart";

class UpdateMemoDialog extends ConsumerStatefulWidget {
  final Account account;
  final String initialMemo;
  final String userId;

  const UpdateMemoDialog({
    required this.account,
    required this.initialMemo,
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      UpdateMemoDialogState();
}

class UpdateMemoDialogState extends ConsumerState<UpdateMemoDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialMemo;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).memo),
      content: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          hintText: S.of(context).memoDescription,
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () async => ref
              .read(
                userInfoNotifierProvider(widget.account, widget.userId)
                    .notifier,
              )
              .updateMemo(controller.text),
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}
