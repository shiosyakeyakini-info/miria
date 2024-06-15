import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "abuse_dialog.g.dart";

@Riverpod(keepAlive: false)
class AbuseDialogNotifier extends _$AbuseDialogNotifier {
  @override
  AsyncValue<void>? build() => null;

  Future<void> abuse(
    Account account,
    User targetUser,
    String abuseText,
  ) async {
    state = const AsyncLoading();
    state =
        await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref.read(misskeyProvider(account)).users.reportAbuse(
            UsersReportAbuseRequest(userId: targetUser.id, comment: abuseText),
          );
      await ref.read(dialogStateNotifierProvider.notifier).showSimpleDialog(
          message: (context) => S.of(context).thanksForReport);
    });
  }
}

class AbuseDialog extends ConsumerStatefulWidget {
  final Account account;
  final User targetUser;
  final String? defaultText;

  const AbuseDialog({
    required this.account,
    required this.targetUser,
    super.key,
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

  @override
  Widget build(BuildContext context) {
    final abuse = ref.watch(abuseDialogNotifierProvider);

    ref.listen(abuseDialogNotifierProvider, (_, next) {
      if (next is! AsyncData) return;
      Navigator.of(context).pop();
    });

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
          switch (abuse) {
            AsyncLoading() => ElevatedButton.icon(
                onPressed: null,
                label: Text(S.of(context).loading),
                icon: const CircularProgressIndicator.adaptive(),
              ),
            _ => ElevatedButton(
                onPressed: () async => ref
                    .read(abuseDialogNotifierProvider.notifier)
                    .abuse(widget.account, widget.targetUser, controller.text),
                child: Text(S.of(context).reportAbuse),
              ),
          }
        ],
      ),
    );
  }
}
