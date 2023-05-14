import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/extensions/text_editing_controller_extension.dart';
import 'package:flutter_misskey_app/view/time_line_page/timeline_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomKeyboard extends StatelessWidget {
  final String keyboard;
  final String? afterInsert;
  final TextEditingController controller;
  final FocusNode focusNode;

  const CustomKeyboard({
    super.key,
    required this.keyboard,
    required this.controller,
    required this.focusNode,
    this.afterInsert,
  });

  void insert() {
    controller.insert(keyboard, afterText: afterInsert);
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => insert(),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 32 * MediaQuery.of(context).textScaleFactor,
              maxHeight: 32 * MediaQuery.of(context).textScaleFactor,
            ),
            child: Text(
              keyboard,
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
