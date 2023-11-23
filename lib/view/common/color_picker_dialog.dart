import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
        title: const Text("色を選んでや"),
        content: ColorPicker(
          pickerColor: pickedColor,
          onColorChanged: (color) => setState(() => pickedColor = color),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(pickedColor);
              },
              child: const Text("これにする"))
        ]);
  }
}
