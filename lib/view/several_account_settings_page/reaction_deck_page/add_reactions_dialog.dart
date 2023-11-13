import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
      title: const Text("一括追加"),
      scrollable: true,
      content: Form(
        key: formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  title: Text("1"),
                  subtitle: Text(
                    "お使いのブラウザでリアクションデッキをコピーしたい"
                    "アカウントにログインしてください",
                  ),
                ),
                ListTile(
                  title: const Text("2"),
                  subtitle: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "同じブラウザで "),
                        TextSpan(
                          text: uri.toString(),
                          style: AppTheme.of(context).linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                ),
                        ),
                        const TextSpan(
                          text: //
                              " にアクセスして「値 (JSON)」の内容をすべて選択して"
                              "コピーしてください",
                        )
                      ],
                    ),
                  ),
                ),
                const ListTile(
                  title: Text("3"),
                  subtitle: Text(
                    "コピーしたものを下のテキストボックスに貼り付けてください",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "ここに貼り付け",
                contentPadding: EdgeInsets.all(10),
                isDense: true,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 10,
              textAlignVertical: TextAlignVertical.top,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "値が入力されていません";
                }
                try {
                  final emojiNames = JSON5.parse(value) as List;
                  emojiNames.map((name) => name as String);
                } catch (e) {
                  return "入力が有効な値ではありません";
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
              child: const Text("確定"),
            ),
          ],
        ),
      ),
    );
  }
}
