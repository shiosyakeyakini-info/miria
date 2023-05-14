import 'package:flutter/cupertino.dart';

extension TextEditingControllerExtension on TextEditingController {
  bool get isIncludeBeforeColon {
    return text.substring(0, selection.base.offset).contains(":");
  }

  bool get isEmojiScope {
    final position = selection.base.offset;
    final startPosition = text.substring(0, position).lastIndexOf(":") + 1;
    if (RegExp(r':[a-zA-z_0-9]+?:$')
        .hasMatch(text.substring(0, startPosition))) {
      return true;
    }
    return false;
  }

  String get emojiSearchValue {
    final position = selection.base.offset;
    final startPosition = text.substring(0, position).lastIndexOf(":") + 1;
    return text.substring(startPosition, position);
  }

  void insert(String insertText, {String? afterText}) {
    final currentPosition = selection.base.offset;
    final before = text.isEmpty ? "" : text.substring(0, currentPosition);
    final after = (currentPosition == text.length || currentPosition == -1)
        ? ""
        : text.substring(currentPosition, text.length);

    value = TextEditingValue(
        text: "$before$insertText${afterText ?? ""}$after",
        selection: TextSelection.collapsed(
            offset: (currentPosition == -1 ? 0 : currentPosition) +
                insertText.length));
  }
}
