import 'package:flutter/material.dart';
import 'package:miria/model/input_completion_type.dart';

extension TextEditingControllerExtension on TextEditingController {
  String? get textBeforeSelection {
    final baseOffset = selection.baseOffset;
    if (baseOffset < 0) {
      return null;
    }
    return text.substring(0, baseOffset);
  }

  String? get emojiQuery {
    final textBeforeSelection = this.textBeforeSelection;
    if (textBeforeSelection == null) {
      return null;
    }
    final lastColonIndex = textBeforeSelection.lastIndexOf(":");
    if (lastColonIndex < 0) {
      return null;
    }
    if (RegExp(r':[a-zA-z_0-9]+?:$')
        .hasMatch(text.substring(0, lastColonIndex + 1))) {
      return null;
    } else {
      return textBeforeSelection.substring(lastColonIndex + 1);
    }
  }

  String? get mfmFnQuery {
    final textBeforeSelection = this.textBeforeSelection;
    if (textBeforeSelection == null) {
      return null;
    }
    final lastOpenTagIndex = textBeforeSelection.lastIndexOf(r"$[");
    if (lastOpenTagIndex < 0) {
      return null;
    }
    final query = textBeforeSelection.substring(lastOpenTagIndex + 2);
    if (RegExp(r"^[a-zA-Z0-9_.,-=]*$").hasMatch(query)) {
      return query;
    } else {
      return null;
    }
  }

  String? get hashtagQuery {
    final textBeforeSelection = this.textBeforeSelection;
    if (textBeforeSelection == null) {
      return null;
    }
    final lastHashIndex = textBeforeSelection.lastIndexOf("#");
    if (lastHashIndex < 0) {
      return null;
    }
    final query = textBeforeSelection.substring(lastHashIndex + 1);
    if (query.contains(RegExp(r"""[ \u3000\t.,!?'"#:/[\]【】()「」（）<>]"""))) {
      return null;
    } else {
      return query;
    }
  }

  InputCompletionType get inputCompletionType {
    final emojiQuery = this.emojiQuery;
    if (emojiQuery != null) {
      return Emoji(emojiQuery);
    }
    final mfmFnQuery = this.mfmFnQuery;
    if (mfmFnQuery != null) {
      return MfmFn(mfmFnQuery);
    }
    final hashtagQuery = this.hashtagQuery;
    if (hashtagQuery != null) {
      return Hashtag(hashtagQuery);
    }
    return Basic();
  }

  void insert(String insertText, {String? afterText}) {
    final start = selection.start < 0 ? 0 : selection.start;
    final end = selection.end < 0 ? 0 : selection.end;
    final before = text.substring(0, start);
    final selectedText = text.substring(start, end);
    final after = text.substring(end);

    value = TextEditingValue(
      text: "$before$insertText$selectedText${afterText ?? ""}$after",
      selection: TextSelection(
        baseOffset: start + insertText.length,
        extentOffset: end + insertText.length,
      ),
    );
  }
}
