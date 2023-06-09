import 'package:flutter/material.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';

class CustomKeyboard extends StatelessWidget {
  final String keyboard;
  final String displayText;
  final String? afterInsert;
  final TextEditingController controller;
  final FocusNode focusNode;

  const CustomKeyboard({
    super.key,
    required this.keyboard,
    required this.controller,
    required this.focusNode,
    String? displayText,
    this.afterInsert,
  }) : displayText = displayText ?? keyboard;

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
