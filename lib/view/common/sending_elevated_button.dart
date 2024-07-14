import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class SendingElevatedButton extends StatelessWidget {
  const SendingElevatedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: null,
      label: Text(S.of(context).sending),
      icon: const CircularProgressIndicator.adaptive(),
    );
  }
}
