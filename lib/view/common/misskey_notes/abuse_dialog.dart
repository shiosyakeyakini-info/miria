import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/simple_message_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AbuseDialog extends ConsumerStatefulWidget {
  final Account account;
  final User targetUser;
  final String? defaultText;

  const AbuseDialog({
    super.key,
    required this.account,
    required this.targetUser,
    this.defaultText,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AbuseDialogState();
}

class AbuseDialogState extends ConsumerState<AbuseDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.defaultText ?? "";
  }

  Future<void> abuse() async {
    await ref
        .read(misskeyProvider(widget.account))
        .users
        .reportAbuse(UsersReportAbuseRequest(
          userId: widget.targetUser.id,
          comment: controller.text,
        ));
    if (!mounted) return;
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) =>
            const SimpleMessageDialog(message: "内容が送信されました。ご報告ありがとうございました。"));
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: AlertDialog(
        title: SimpleMfmText(
            "${widget.targetUser.name ?? widget.targetUser.username} を通報する"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("詳細"),
              TextField(
                controller: controller,
                maxLines: null,
                minLines: 5,
                autofocus: true,
              ),
              Text(
                "通報理由の詳細を記入してください。対象のノートがある場合はそのURLも記入してください。",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [ElevatedButton(onPressed: abuse, child: const Text("通報する"))],
      ),
    );
  }
}
