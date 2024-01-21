import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateMemoDialog extends ConsumerStatefulWidget {
  final Account account;
  final String initialMemo;
  final String userId;

  const UpdateMemoDialog({
    super.key,
    required this.account,
    required this.initialMemo,
    required this.userId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      UpdateMemoDialogState();
}

class UpdateMemoDialogState extends ConsumerState<UpdateMemoDialog> {
  final controller = TextEditingController();

  Future<void> memoSave() async {
    await ref.read(misskeyProvider(widget.account)).users.updateMemo(
        UsersUpdateMemoRequest(userId: widget.userId, memo: controller.text));
    if (!mounted) return;
    Navigator.of(context).pop(controller.text);
  }

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
          onPressed: memoSave.expectFailure(context),
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}
