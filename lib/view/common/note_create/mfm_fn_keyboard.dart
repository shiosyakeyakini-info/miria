import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/model/input_completion_type.dart';
import 'package:miria/view/common/note_create/basic_keyboard.dart';
import 'package:miria/view/common/note_create/custom_keyboard_button.dart';
import 'package:miria/view/common/note_create/input_completation.dart';

const mfmFn = [
  "tada",
  "jelly",
  "twitch",
  "shake",
  "spin",
  "jump",
  "bounce",
  "flip",
  "x2",
  "x3",
  "x4",
  "scale",
  "position",
  "fg",
  "bg",
  "font",
  "blur",
  "rainbow",
  "sparkle",
  "rotate",
  "ruby",
  "unixtime"
];

final _filteredMfmFnProvider = Provider.autoDispose<List<String>>((ref) {
  final type = ref.watch(inputCompletionTypeProvider);
  if (type is MfmFn) {
    return mfmFn.where((name) => name.startsWith(type.query)).toList();
  } else {
    return mfmFn;
  }
});

class MfmFnKeyboard extends ConsumerWidget {
  const MfmFnKeyboard({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.parentContext,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final BuildContext parentContext;

  Future<void> insertMfmFn(BuildContext context, String mfmFn) async {
    if (mfmFn == "unixtime") {
      final resultDate = await showDatePicker(
          context: parentContext,
          firstDate: DateTime.utc(-271820, 12, 31),
          initialDate: DateTime.now(),
          lastDate: DateTime.utc(275760, 9, 13));
      if (resultDate == null) return;
      final resultTime = await showTimePicker(
        context: parentContext,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      );
      if (resultTime == null) return;
      final date = DateTime(resultDate.year, resultDate.month, resultDate.day,
          resultTime.hour, resultTime.minute, 0);
      final unixtime = date.millisecondsSinceEpoch ~/ 1000;

      controller.insert("unixtime $unixtime");
      focusNode.requestFocus();

      return;
    }

    final textBeforeSelection = controller.textBeforeSelection;
    final lastOpenTagIndex = textBeforeSelection!.lastIndexOf(r"$[");
    final queryLength = textBeforeSelection.length - lastOpenTagIndex - 2;
    controller.insert("${mfmFn.substring(queryLength)} ");
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredMfmFn = ref.watch(_filteredMfmFnProvider);

    if (filteredMfmFn.isEmpty) {
      return BasicKeyboard(
        controller: controller,
        focusNode: focusNode,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final mfmFn in filteredMfmFn)
          CustomKeyboardButton(
            keyboard: mfmFn,
            controller: controller,
            focusNode: focusNode,
            onTap: () async => await insertMfmFn(context, mfmFn),
          ),
      ],
    );
  }
}
