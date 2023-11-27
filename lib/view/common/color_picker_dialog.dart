import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({super.key});

  @override
  State<StatefulWidget> createState() => ColorPickerDialogState();
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  Color pickedColor = const Color.fromRGBO(134, 179, 0, 1.0);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title:  Text(S.of(context).pickColor),
        content: ColorPicker(
          pickerColor: pickedColor,
          onColorChanged: (color) => setState(() => pickedColor = color),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(pickedColor);
              },
              child: Text(S.of(context).decideColor))
        ]);
  }
}
