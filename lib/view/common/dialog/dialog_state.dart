import "dart:async";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/error_dialog_handler.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "dialog_state.freezed.dart";
part "dialog_state.g.dart";

@freezed
class DialogsState with _$DialogsState {
  factory DialogsState({
    @Default([]) List<DialogData> dialogs,
  }) = _DialogsState;
}

@freezed
class DialogData with _$DialogData {
  factory DialogData({
    required String Function(BuildContext context) message,
    required List<String> Function(BuildContext context) actions,
    required Completer<int> completer,
    @Assert(
      "!isMFM || isMFM && accountContext != null",
      "account context must not be null when isMFM is true",
    )
    AccountContext? accountContext,
    @Default(false) bool isMFM,
  }) = _DialogData;
}

@riverpod
class DialogStateNotifier extends _$DialogStateNotifier {
  @override
  DialogsState build() => DialogsState();

  Future<int> showDialog({
    required String Function(BuildContext context) message,
    required List<String> Function(BuildContext context) actions,
    bool isMFM = false,
    AccountContext? accountContext,
  }) {
    final completer = Completer<int>();
    state = state.copyWith(
      dialogs: [
        ...state.dialogs,
        DialogData(
          message: message,
          actions: actions,
          completer: completer,
          isMFM: isMFM,
          accountContext: accountContext,
        ),
      ],
    );
    return completer.future;
  }

  Future<void> showSimpleDialog({
    required String Function(BuildContext context) message,
  }) =>
      showDialog(message: message, actions: (context) => [S.of(context).done]);

  void completeDialog(DialogData dialog, int? button) {
    dialog.completer.complete(button);
    state = state.copyWith(
      dialogs: state.dialogs.where((element) => element != dialog).toList(),
    );
  }

  Future<AsyncValue<T>> guard<T>(Future<T> Function() future) async {
    final result = await AsyncValue.guard(future);
    if (result is AsyncError) {
      await showSimpleDialog(
        message: _handleError(result.error, result.stackTrace),
      );
    }
    return result;
  }
}

String Function(BuildContext context) _handleError(
  Object? error,
  StackTrace? trace,
) {
  if (error is Exception) {
    if (error is DioException) {
      return (context) =>
          "${S.of(context).thrownError}\n${error.type} [${error.response?.statusCode ?? "---"}] ${error.response?.data ?? ""}";
    } else if (error is SpecifiedException) {
      return (context) => error.message;
    }
    return (context) => "${S.of(context).thrownError}\n$error";
  }

  if (error is Error) {
    return (context) => "${S.of(context).thrownError}\n$error";
  }

  return (context) => "${S.of(context).thrownError}\n$error";
}
