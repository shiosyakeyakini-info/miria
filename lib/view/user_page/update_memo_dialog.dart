import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';

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
    await ref
        .read(
          userDetailedNotifierProvider((widget.account, widget.userId))
              .notifier,
        )
        .updateMemo(controller.text);
    if (!mounted) return;
    Navigator.of(context).pop();
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
      title: const Text("メモ"),
      content: TextField(
        controller: controller,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: "なんかメモることあったら書いとき",
        ),
      ),
      actions: [
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("やめる")),
        ElevatedButton(
            onPressed: memoSave.expectFailure(context),
            child: const Text("保存する"))
      ],
    );
  }
}
