import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            SimpleMessageDialog(message: S.of(context).thanksForReport));
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: AlertDialog(
        title: SimpleMfmText(
          S.of(context).reportAbuseOf(
                widget.targetUser.name ?? widget.targetUser.username,
              ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).detail),
              TextField(
                controller: controller,
                maxLines: null,
                minLines: 5,
                autofocus: true,
              ),
              Text(
                S.of(context).pleaseInputReasonWhyAbuse,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: abuse.expectFailure(context),
              child: Text(S.of(context).reportAbuse))
        ],
      ),
    );
  }
}
