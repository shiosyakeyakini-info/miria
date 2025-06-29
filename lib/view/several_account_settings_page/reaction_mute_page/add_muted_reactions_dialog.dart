import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:json5/json5.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:url_launcher/url_launcher.dart";

class AddMutedReactionsDialog extends HookConsumerWidget {
  const AddMutedReactionsDialog({required this.account, super.key});

  final Account account;

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
        "@",
        "client",
        "preferences",
        "sync",
        "default:mutingEmojis",
      ],
    );
    final s = S.of(context);

    return AlertDialog(
      title: Text(s.bulkAddMutedReactions),
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
                  subtitle: Text(s.bulkAddMutedReactionsDescription1),
                ),
                ListTile(
                  title: const Text("2"),
                  subtitle: Column(
                    children: [
                      Text(s.bulkAddMutedReactionsDescription2),
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
                  subtitle: Text(s.bulkAddMutedReactionsDescription3),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: s.pasteHere,
                contentPadding: const EdgeInsets.all(10),
                isDense: true,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 10,
              textAlignVertical: TextAlignVertical.top,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return s.pleaseInput;
                }
                final text = value.trim();
                if (text.startsWith("[")) {
                  try {
                    (JSON5.parse(value) as List).map((name) => name as String);
                  } catch (e) {
                    return s.invalidInput;
                  }
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (value) {
                if (formKey.value.currentState!.validate()) {
                  final text = value?.trim();
                  if (text == null) return;
                  final List<String> mutedReactions;
                  if (text.startsWith("[")) {
                    final parsed = JSON5.parse(value!) as List;
                    mutedReactions = parsed
                        .map((name) => name as String)
                        .toList();
                  } else {
                    mutedReactions = text
                        .split("\n")
                        .where((line) => line.trim().isNotEmpty)
                        .map((line) => line.trim())
                        .toList();
                  }
                  Navigator.of(context).pop(mutedReactions);
                }
              },
            ),
            ElevatedButton(
              onPressed: () => formKey.value.currentState?.save(),
              child: Text(s.done),
            ),
          ],
        ),
      ),
    );
  }
}
