import 'package:flutter/material.dart';

class SimpleMessageDialog extends StatelessWidget {
  final String message;

  static void show(BuildContext context, String message) => showDialog(
      context: context,
      builder: (context) => SimpleMessageDialog(message: message));

  const SimpleMessageDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("ほい"))
      ],
    );
  }
}
