import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/model/input_completion_type.dart';
import 'package:miria/view/common/color_picker_dialog.dart';
import 'package:miria/view/common/date_time_picker.dart';
import 'package:miria/view/common/note_create/basic_keyboard.dart';
import 'package:miria/view/common/note_create/custom_keyboard_button.dart';
import 'package:miria/view/common/note_create/input_completation.dart';

class MfmFnArg {
  const MfmFnArg({
    required this.name,
    this.defaultValue,
  });

  final String name;
  final String? defaultValue;
}

const Map<String, List<MfmFnArg>> mfmFn = {
  "tada": [
    MfmFnArg(name: "speed", defaultValue: "1s"),
    MfmFnArg(name: "delay", defaultValue: "0s"),
  ],
  "jelly": [
    MfmFnArg(name: "speed", defaultValue: "1s"),
    MfmFnArg(name: "delay", defaultValue: "0s"),
  ],
  "twitch": [
    MfmFnArg(name: "speed", defaultValue: "0.5s"),
    MfmFnArg(name: "delay", defaultValue: "0s"),
  ],
  "shake": [
    MfmFnArg(name: "speed", defaultValue: "0.5s"),
    MfmFnArg(name: "delay", defaultValue: "0s"),
  ],
  "spin": [
    MfmFnArg(name: "speed", defaultValue: "1.5s"),
    MfmFnArg(name: "delay", defaultValue: "0s"),
    MfmFnArg(name: "x"),
    MfmFnArg(name: "y"),
    MfmFnArg(name: "left"),
    MfmFnArg(name: "alternate"),
  ],
  "jump": [
    MfmFnArg(name: "speed", defaultValue: "0.75s"),
    MfmFnArg(name: "delay", defaultValue: "0s"),
  ],
  "bounce": [
    MfmFnArg(name: "speed", defaultValue: "0.75s"),
    MfmFnArg(name: "delay", defaultValue: "0s"),
  ],
  "flip": [
    MfmFnArg(name: "v"),
    MfmFnArg(name: "h"),
  ],
  "x2": [],
  "x3": [],
  "x4": [],
  "scale": [
    MfmFnArg(name: "x", defaultValue: "1"),
    MfmFnArg(name: "y", defaultValue: "1"),
  ],
  "position": [
    MfmFnArg(name: "x", defaultValue: "0"),
    MfmFnArg(name: "y", defaultValue: "0"),
  ],
  "fg": [
    MfmFnArg(name: "color"),
  ],
  "bg": [
    MfmFnArg(name: "color"),
  ],
  "border": [
    MfmFnArg(name: "style", defaultValue: "solid"),
    MfmFnArg(name: "color"),
    MfmFnArg(name: "width", defaultValue: "1"),
    MfmFnArg(name: "radius", defaultValue: "1"),
    MfmFnArg(name: "noclip"),
  ],
  "font": [
    MfmFnArg(name: "serif"),
    MfmFnArg(name: "monospace"),
    MfmFnArg(name: "cursive"),
    MfmFnArg(name: "fantasy"),
  ],
  "blur": [],
  "rainbow": [
    MfmFnArg(name: "speed", defaultValue: "1s"),
  ],
  "sparkle": [
    MfmFnArg(name: "speed", defaultValue: "1.5s"),
  ],
  "rotate": [
    MfmFnArg(name: "deg", defaultValue: "90"),
  ],
  "ruby": [],
  "unixtime": [],
};

final filteredMfmFnNamesProvider = Provider.autoDispose<List<String>>((ref) {
  final type = ref.watch(inputCompletionTypeProvider);
  if (type is MfmFn) {
    return mfmFn.keys.where((name) => name.startsWith(type.query)).toList();
  } else {
    return [];
  }
});

final filteredMfmFnArgsProvider = Provider.autoDispose<List<MfmFnArg>>((ref) {
  final type = ref.watch(inputCompletionTypeProvider);
  if (type is MfmFn) {
    if (type.query.contains(".")) {
      final firstPeriodIndex = type.query.indexOf(".");
      final name = type.query.substring(0, firstPeriodIndex);
      final allArgs = mfmFn[name];
      if (allArgs != null && allArgs.isNotEmpty) {
        final argNames = type.query
            .substring(firstPeriodIndex + 1)
            .split(",")
            .map((s) => s.split("=").first);
        if (argNames.isEmpty) {
          return allArgs;
        }
        final head = argNames.take(argNames.length - 1);
        final tail = argNames.last;
        if (allArgs.any((arg) => arg.name == tail)) {
          return allArgs.where((arg) => !argNames.contains(arg.name)).toList();
        } else {
          return allArgs
              .where(
                (arg) => !head.contains(arg.name) && arg.name.startsWith(tail),
              )
              .toList();
        }
      }
    }
    return mfmFn[type.query] ?? [];
  }
  return [];
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

  Future<void> insertMfmFnName(String mfmFnName) async {
    final textBeforeSelection = controller.textBeforeSelection;
    final lastOpenTagIndex = textBeforeSelection!.lastIndexOf(r"$[");
    final queryLength = textBeforeSelection.length - lastOpenTagIndex - 2;
    controller.insert(mfmFnName.substring(queryLength));
    if (mfmFnName == "unixtime") {
      final resultDate = await showDateTimePicker(
        context: parentContext,
        firstDate: DateTime.utc(-271820, 12, 31),
        initialDate: DateTime.now(),
        lastDate: DateTime.utc(275760, 9, 13),
      );
      if (resultDate != null) {
        final unixtime = resultDate.millisecondsSinceEpoch ~/ 1000;

        controller.insert(" $unixtime");
      }
    } else if (mfmFnName == "fg" || mfmFnName == "bg") {
      final result = await showDialog<Color?>(
          context: parentContext,
          builder: (context) => const ColorPickerDialog());
      if (result != null) {
        controller.insert(
            ".color=${result.red.toRadixString(16).padLeft(2, "0")}${result.green.toRadixString(16).padLeft(2, "0")}${result.blue.toRadixString(16).padLeft(2, "0")} ");
      } else {
        controller.insert(" ");
      }
    } else {
      controller.insert(" ");
    }

    focusNode.requestFocus();
  }

  Future<void> insertMfmFnArg(MfmFnArg arg) async {
    final textBeforeSelection = controller.textBeforeSelection!;
    final lastOpenTagIndex = textBeforeSelection.lastIndexOf(r"$[");
    final firstPeriodIndex = textBeforeSelection.indexOf(".", lastOpenTagIndex);
    final mfmFnName = textBeforeSelection.substring(
      lastOpenTagIndex + 2,
      firstPeriodIndex < 0 ? null : firstPeriodIndex,
    );
    if (firstPeriodIndex < 0) {
      controller.insert(".${arg.name}");
    } else {
      final lastArg =
          textBeforeSelection.substring(firstPeriodIndex + 1).split(",").last;
      final lastArgName = lastArg.split("=").first;
      if (mfmFn[mfmFnName]?.any((arg) => arg.name == lastArgName) ?? false) {
        controller.insert(",${arg.name}");
      } else if (textBeforeSelection.contains(",", lastOpenTagIndex)) {
        controller.insert(arg.name.substring(lastArg.length));
      } else {
        final queryLength = textBeforeSelection.length - firstPeriodIndex - 1;
        controller.insert(arg.name.substring(queryLength));
      }
    }
    if ((mfmFnName == "fg" || mfmFnName == "bg" || mfmFnName == "border") && arg.name == "color") {
      final result = await showDialog<Color?>(
        context: parentContext,
        builder: (context) => const ColorPickerDialog(),
      );
      if (result != null) {
        controller.insert(
          "=${result.red.toRadixString(16).padLeft(2, "0")}${result.green.toRadixString(16).padLeft(2, "0")}${result.blue.toRadixString(16).padLeft(2, "0")} ",
        );
      } else {
        controller.insert("=f00 ");
      }
    } else if (arg.defaultValue != null) {
      controller.insert("=${arg.defaultValue}");
    }
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredNames = ref.watch(filteredMfmFnNamesProvider);
    final filteredArgs = ref.watch(filteredMfmFnArgsProvider);

    if (filteredArgs.isNotEmpty) {
      return Row(
        children: filteredArgs
            .map(
              (arg) => CustomKeyboardButton(
                keyboard: arg.name,
                controller: controller,
                focusNode: focusNode,
                onTap: () => insertMfmFnArg(arg),
              ),
            )
            .toList(),
      );
    } else if (filteredNames.isNotEmpty) {
      return Row(
        children: filteredNames
            .map(
              (name) => CustomKeyboardButton(
                keyboard: name,
                controller: controller,
                focusNode: focusNode,
                onTap: () => insertMfmFnName(name),
              ),
            )
            .toList(),
      );
    } else {
      return BasicKeyboard(
        controller: controller,
        focusNode: focusNode,
      );
    }
  }
}
