import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:freezed_annotation/freezed_annotation.dart";
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
  }) = _DialogData;
}

@riverpod
class DialogStateNotifier extends _$DialogStateNotifier {
  @override
  DialogsState build() => DialogsState();

  Future<int> showDialog({
    required String Function(BuildContext context) message,
    required List<String> Function(BuildContext context) actions,
  }) {
    final completer = Completer<int>();
    state = state.copyWith(
      dialogs: [
        ...state.dialogs,
        DialogData(message: message, actions: actions, completer: completer),
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
}
