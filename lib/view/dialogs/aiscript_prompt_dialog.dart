import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";

/// AiScript の `Mk:readline` の入力欄。
///
/// 画面を持つ Play やスクラッチパッドから使う。常駐するプラグインには
/// 出す先の画面がないので渡さない (その場合 `Mk:readline` は空文字を返す)。
Future<String?> showAiScriptPrompt(BuildContext context, String prompt) async {
  final controller = TextEditingController();
  try {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: prompt),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(S.of(context).done),
          ),
        ],
      ),
    );
  } finally {
    controller.dispose();
  }
}
