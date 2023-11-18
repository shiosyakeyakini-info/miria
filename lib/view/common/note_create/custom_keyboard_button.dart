import 'package:flutter/material.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';

class CustomKeyboardButton extends StatelessWidget {
  final String keyboard;
  final String displayText;
  final String? afterInsert;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function()? onTap;

  const CustomKeyboardButton({
    super.key,
    required this.keyboard,
    required this.controller,
    required this.focusNode,
    String? displayText,
    this.afterInsert,
    this.onTap,
  }) : displayText = displayText ?? keyboard;

  void insert() {
    controller.insert(keyboard, afterText: afterInsert);
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? insert,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.textScalerOf(context).scale(32),
            maxHeight: MediaQuery.textScalerOf(context).scale(32),
          ),
          child: Text(
            keyboard,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
