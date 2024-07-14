import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:json5/json5.dart";
import "package:miria/model/account.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:url_launcher/url_launcher.dart";

class AddReactionsDialog extends HookConsumerWidget {
  const AddReactionsDialog({
    required this.account,
    super.key,
    this.domain = "system",
  });

  final Account account;
  final String domain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useState(GlobalKey<FormState>());

    final host = account.host;
    final uri = Uri(
      scheme: "https",
      host: host,
      pathSegments: [
        "registry",
        "value",
        domain,
        "client",
        "base",
        "reactions",
      ],
    );
    return AlertDialog(
      title: Text(S.of(context).bulkAddReactions),
      scrollable: true,
      content: Form(
        key: formKey.value,
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
                        onPressed: () async => launchUrl(
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
                  (JSON5.parse(value) as List).map((name) => name as String);
                } catch (e) {
                  return S.of(context).invalidInput;
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (value) {
                if (formKey.value.currentState!.validate()) {
                  final emojiNames = JSON5.parse(value!) as List;
                  Navigator.of(context)
                      .pop(emojiNames.map((name) => name as String).toList());
                }
              },
            ),
            ElevatedButton(
              onPressed: () => formKey.value.currentState?.save(),
              child: Text(S.of(context).done),
            ),
          ],
        ),
      ),
    );
  }
}
