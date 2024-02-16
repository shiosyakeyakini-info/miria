import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/account_repository.dart';
import 'package:miria/state_notifier/common/misskey_notes/misskey_note_notifier.dart';
import 'package:miria/state_notifier/note_create_page/note_create_state_notifier.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorDialogListener extends ConsumerWidget {
  final Widget child;

  const ErrorDialogListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(errorEventProvider, (_, next) {
      final error = next.$1;
      if (error == null) return;
      if (error is Exception) {
        if (error is DioError) {
          SimpleMessageDialog.show(next.$2!,
              "${S.of(context).thrownError}\n${error.type} [${error.response?.statusCode ?? "---"}] ${error.response?.data ?? ""}");
        } else if (error is SpecifiedException) {
          SimpleMessageDialog.show(next.$2!, error.message);
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
          SimpleMessageDialog.show(next.$2!, message);
        } else if (error is OpenLocalOnlyNoteFromRemoteException) {
          SimpleMessageDialog.show(
            next.$2!,
            S.of(context).cannotOpenLocalOnlyNoteFromRemote,
          );
        } else if (error is NoteCreateException) {
          final message = switch (error) {
            EmptyNoteException() => S.of(context).pleaseInputSomething,
            TooFewVoteChoiceException() => S.of(context).pleaseAddVoteChoice,
            EmptyVoteExpireDateException() =>
              S.of(context).pleaseSpecifyExpirationDate,
            EmptyVoteExpireDurationException() =>
              S.of(context).pleaseSpecifyExpirationDuration,
            MentionToRemoteInLocalOnlyNoteException() =>
              S.of(context).cannotMentionToRemoteInLocalOnlyNote,
          };
          SimpleMessageDialog.show(next.$2!, message);
        } else {
          SimpleMessageDialog.show(next.$2!, "${S.of(context).thrownError}\n$next");
        }
      } else if (error is Error) {
        SimpleMessageDialog.show(next.$2!, "${S.of(context).thrownError}\n$next");
      }
    });

    return child;
  }
}
