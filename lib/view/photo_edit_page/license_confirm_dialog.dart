import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/dialogs/simple_message_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "license_confirm_dialog.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
Future<EmojiResponse> _emoji(_EmojiRef ref, String emoji) async {
  return await ref
      .read(misskeyPostContextProvider)
      .emoji(EmojiRequest(name: emoji));
}

@RoutePage()
class LicenseConfirmDialog extends ConsumerWidget implements AutoRouteWrapper {
  final String emoji;
  final Account account;

  const LicenseConfirmDialog({
    required this.emoji,
    required this.account,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiResponse = ref.watch(_emojiProvider(emoji));
    return switch (emojiResponse) {
      AsyncLoading() => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      AsyncError(:final error) => SimpleMessageDialog(
          message: "${S.of(context).thrownError}\n$error",
        ),
      AsyncData(:final value) => AlertDialog(
          content: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(S.of(context).customEmojiLicensedBy),
                  MfmText(
                    mfmText: value.license ??
                        S.of(context).customEmojiLicensedByNone,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).cancelEmojiChoosing),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(S.of(context).doneEmojiChoosing),
            ),
          ],
        ),
    };
  }
}
