import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SimpleMessageDialog extends StatelessWidget {
  final String message;

  static Future<void> show(BuildContext context, String message) async =>
      await showDialog(
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
            child: Text(S.of(context).done))
      ],
    );
  }
}
