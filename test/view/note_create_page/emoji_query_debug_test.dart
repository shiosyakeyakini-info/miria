import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:miria/extensions/text_editing_controller_extension.dart";
import "package:miria/model/input_completion_type.dart";

void main() {
  group("EmojiQuery Debug", () {
    test("コロンだけ入力した場合のemojiQuery", () {
      final controller = TextEditingController();

      // ":"だけ入力
      controller.text = ":";
      controller.selection = const TextSelection.collapsed(offset: 1);

      print("text: '${controller.text}'");
      print("selection: ${controller.selection}");
      print("textBeforeSelection: '${controller.textBeforeSelection}'");
      print("emojiQuery: '${controller.emojiQuery}'");
      print("inputCompletionType: ${controller.inputCompletionType}");

      expect(controller.emojiQuery, isNotNull);
      expect(controller.inputCompletionType, isA<Emoji>());
    });

    test("コロンの後に文字を入力した場合のemojiQuery", () {
      final controller = TextEditingController();

      // ":test"を入力
      controller.text = ":test";
      controller.selection = const TextSelection.collapsed(offset: 5);

      print("text: '${controller.text}'");
      print("selection: ${controller.selection}");
      print("textBeforeSelection: '${controller.textBeforeSelection}'");
      print("emojiQuery: '${controller.emojiQuery}'");
      print("inputCompletionType: ${controller.inputCompletionType}");

      expect(controller.emojiQuery, equals("test"));
      expect(controller.inputCompletionType, isA<Emoji>());
    });

    test("コロンがない場合のemojiQuery", () {
      final controller = TextEditingController();

      // "test"を入力
      controller.text = "test";
      controller.selection = const TextSelection.collapsed(offset: 4);

      print("text: '${controller.text}'");
      print("selection: ${controller.selection}");
      print("textBeforeSelection: '${controller.textBeforeSelection}'");
      print("emojiQuery: '${controller.emojiQuery}'");
      print("inputCompletionType: ${controller.inputCompletionType}");

      expect(controller.emojiQuery, isNull);
      expect(controller.inputCompletionType, isA<Basic>());
    });

    test("完成した絵文字の後にコロンを入力した場合", () {
      final controller = TextEditingController();

      // ":smile:"の後に":"を入力
      controller.text = ":smile::";
      controller.selection = const TextSelection.collapsed(offset: 8);

      print("text: '${controller.text}'");
      print("selection: ${controller.selection}");
      print("textBeforeSelection: '${controller.textBeforeSelection}'");
      print("emojiQuery: '${controller.emojiQuery}'");
      print("inputCompletionType: ${controller.inputCompletionType}");

      expect(controller.emojiQuery, isNotNull);
      expect(controller.inputCompletionType, isA<Emoji>());
    });
  });
}
