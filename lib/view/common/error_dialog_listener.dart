import "package:dio/dio.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/view/common/error_dialog_handler.dart";
import "package:miria/view/dialogs/simple_message_dialog.dart";

class ErrorDialogListener extends ConsumerWidget {
  final Widget child;

  const ErrorDialogListener({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(errorEventProvider, (_, next) async {
      final error = next.$1;
      if (error == null) return;
      if (error is Exception) {
        if (error is DioException) {
          await SimpleMessageDialog.show(
            next.$2!,
            "${S.of(context).thrownError}\n${error.type} [${error.response?.statusCode ?? "---"}] ${error.response?.data ?? ""}",
          );
        } else if (error is SpecifiedException) {
          await SimpleMessageDialog.show(next.$2!, error.message);
        } else if (error is ValidateMisskeyException) {
          final message = switch (error) {
            InvalidServerException(:final server) =>
              S.of(context).invalidServer(server),
            ServerIsNotMisskeyException(:final server) =>
              S.of(context).serverIsNotMisskey(server),
            SoftwareNotSupportedException(:final software) =>
              S.of(context).softwareNotSupported(software),
            SoftwareNotCompatibleException(:final software, :final version) =>
              S.of(context).softwareNotCompatible(software, version),
            AlreadyLoggedInException(:final acct) =>
              S.of(context).alreadyLoggedIn(acct),
          };
          await SimpleMessageDialog.show(next.$2!, message);
        } else {
          await SimpleMessageDialog.show(
            next.$2!,
            "${S.of(context).thrownError}\n$next",
          );
        }
      } else if (error is Error) {
        await SimpleMessageDialog.show(
          next.$2!,
          "${S.of(context).thrownError}\n$next",
        );
      }
    });

    return child;
  }
}
