import 'package:flutter/material.dart';

class SimpleConfirmDialog extends StatelessWidget {
  final String message;
  final String primary;
  final String secondary;

  const SimpleConfirmDialog(
      {super.key,
      required this.message,
      required this.primary,
      required this.secondary});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: [
        OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(secondary)),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(primary))
      ],
    );
  }
}
