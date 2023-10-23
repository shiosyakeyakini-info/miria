import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFormFieldDialog extends StatefulWidget {
  const TextFormFieldDialog({
    super.key,
    this.title,
    this.labelText,
    this.buttonText,
    this.initialValue,
    this.maxLines = 1,
    this.validator,
  });

  final Widget? title;
  final String? labelText;
  final String? buttonText;
  final String? initialValue;
  final int? maxLines;
  final String? Function(String?)? validator;

  @override
  State<TextFormFieldDialog> createState() => _TextFormFieldDialogState();
}

class _TextFormFieldDialogState extends State<TextFormFieldDialog> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: Form(
        key: formKey,
        child: TextFormField(
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            labelText: widget.labelText,
            contentPadding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
          ),
          maxLines: widget.maxLines,
          onSaved: (value) => Navigator.of(context).pop(value),
          validator: widget.validator,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
            }
          },
          child: Text(widget.buttonText ?? S.of(context).confirm),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
