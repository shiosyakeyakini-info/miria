import 'package:flutter/cupertino.dart';

import 'custom_keyboard.dart';

class CustomKeyboardList extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const CustomKeyboardList({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CustomKeyboard(
          keyboard: ":", controller: controller, focusNode: focusNode),
      CustomKeyboard(
          keyboard: r"$[",
          afterInsert: "]",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "**",
          afterInsert: "**",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "<small>",
          afterInsert: "</small>",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "_",
          afterInsert: "_",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "***",
          afterInsert: "***",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "~~",
          afterInsert: "~~",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "> ", controller: controller, focusNode: focusNode),
      CustomKeyboard(
          keyboard: "<center>",
          afterInsert: "</center>",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "`",
          afterInsert: "`",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "```\n",
          afterInsert: "\n```",
          controller: controller,
          focusNode: focusNode),
      CustomKeyboard(
          keyboard: "<plain>",
          afterInsert: "</plain>",
          controller: controller,
          focusNode: focusNode)
    ]);
  }
}
