import 'package:flutter/material.dart';

class FontTypeSelect extends StatefulWidget {
  const FontTypeSelect({super.key});

  @override
  State<StatefulWidget> createState() => FontTypeSelectState();
}

class FontTypeSelectState extends State<FontTypeSelect> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("フォントタイプを選択",),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop("serif");
          },
          child: Text("明朝体"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop("monospace");
          },
          child: Text("等幅"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop("cursive");
          },
          child: Text("草書体"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop("fantasy");
          },
          child: Text("装飾"),
        ),
      ],
    );
  }
}