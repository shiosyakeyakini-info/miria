import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";

@RoutePage<Color>()
class ColorPickerDialog extends HookWidget {
  const ColorPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final pickedColor = useState(const Color.fromRGBO(134, 179, 0, 1.0));
    return AlertDialog(
      title: Text(S.of(context).pickColor),
      content: ColorPicker(
        pickerColor: pickedColor.value,
        onColorChanged: (color) => pickedColor.value = color,
      ),
      actions: [
        TextButton(
          onPressed: () async => context.maybePop(pickedColor),
          child: Text(S.of(context).decideColor),
        ),
      ],
    );
  }
}
