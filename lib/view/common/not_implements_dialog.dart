import 'package:flutter/material.dart';

class NotImplementationDialog extends StatelessWidget {
  const NotImplementationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("まだこの機能できてへんねん"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("しゃーない"),
        ),
      ],
    );
  }
}
