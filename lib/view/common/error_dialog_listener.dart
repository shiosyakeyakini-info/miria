import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';

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
              "エラーが起きたみたいや\n${error.type} [${error.response?.statusCode ?? "---"}] ${error.response?.data ?? ""}");
        } else if (error is SpecifiedException) {
          SimpleMessageDialog.show(next.$2!, error.message);
        } else {
          SimpleMessageDialog.show(next.$2!, "エラーが起きたみたいや\n$next");
        }
      } else if (error is Error) {
        SimpleMessageDialog.show(next.$2!, "エラーが起きたみたいや\n$next");
      }
    });

    return child;
  }
}
