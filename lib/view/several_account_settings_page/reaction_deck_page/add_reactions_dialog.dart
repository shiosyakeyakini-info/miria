import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:json5/json5.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AddReactionsDialog extends StatefulWidget {
  const AddReactionsDialog({
    super.key,
    required this.account,
    this.domain = "system",
  });

  final Account account;
  final String domain;

  @override
  State<AddReactionsDialog> createState() => _AddReactionsDialogState();
}

class _AddReactionsDialogState extends State<AddReactionsDialog> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final host = widget.account.host;
    final uri = Uri(
      scheme: "https",
      host: host,
      pathSegments: [
        "registry",
        "value",
        widget.domain,
        "client",
        "base",
        "reactions",
      ],
    );
    return AlertDialog(
      title: Text(S.of(context).bulkAddReactions),
      scrollable: true,
      content: Form(
        key: formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("1"),
                  subtitle: Text(S.of(context).bulkAddReactionsDescription1),
                ),
                ListTile(
                  title: const Text("2"),
                  subtitle: Column(
                    children: [
                      Text(S.of(context).bulkAddReactionsDescription2),
                      TextButton(
                        onPressed: () => launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Text(
                          uri.toString(),
                          style: AppTheme.of(context).linkStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text("3"),
                  subtitle: Text(S.of(context).bulkAddReactionsDescription3),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: S.of(context).pasteHere,
                contentPadding: const EdgeInsets.all(10),
                isDense: true,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 10,
              textAlignVertical: TextAlignVertical.top,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).pleaseInput;
                }
                try {
                  final emojiNames = JSON5.parse(value) as List;
                  emojiNames.map((name) => name as String);
                } catch (e) {
                  return S.of(context).invalidInput;
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (value) {
                if (formKey.currentState!.validate()) {
                  final emojiNames = JSON5.parse(value!) as List;
                  Navigator.of(context)
                      .pop(emojiNames.map((name) => name as String).toList());
                }
              },
            ),
            ElevatedButton(
              onPressed: () => formKey.currentState?.save.call(),
              child: Text(S.of(context).done),
            ),
          ],
        ),
      ),
    );
  }
}
