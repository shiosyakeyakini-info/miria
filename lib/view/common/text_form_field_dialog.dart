import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:miria/l10n/app_localizations.dart";

@RoutePage()
class TextFormFieldDialog extends HookWidget {
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
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    return AlertDialog.adaptive(
      title: title,
      content: Form(
        key: formKey,
        child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            labelText: labelText,
            contentPadding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
          ),
          maxLines: maxLines,
          onSaved: (value) => Navigator.of(context).pop(value),
          validator: validator,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
            }
          },
          child: Text(buttonText ?? S.of(context).confirm),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
