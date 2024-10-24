import "package:flutter/cupertino.dart";

import "package:miria/view/common/note_create/custom_keyboard_button.dart";

class BasicKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const BasicKeyboard({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomKeyboardButton(
          keyboard: ":",
          displayText: "：",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "#",
          displayText: "＃",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: r"$[",
          afterInsert: "]",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "**",
          afterInsert: "**",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "<small>",
          afterInsert: "</small>",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "@",
          displayText: "＠",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "<i>",
          afterInsert: "</i>",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "***",
          afterInsert: "***",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "~~",
          afterInsert: "~~",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "> ",
          displayText: "＞",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "<center>",
          afterInsert: "</center>",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "`",
          afterInsert: "`",
          displayText: "｀",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "```\n",
          afterInsert: "\n```",
          controller: controller,
          focusNode: focusNode,
        ),
        CustomKeyboardButton(
          keyboard: "<plain>",
          afterInsert: "</plain>",
          controller: controller,
          focusNode: focusNode,
        ),
      ],
    );
  }
}
