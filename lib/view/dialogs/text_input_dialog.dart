import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";

/// 文字を打ってもらうだけのダイアログ。
///
/// [TextEditingController] をこのウィジェット自身が持って破棄するのが要点。
/// 呼び出し側で `showDialog` の後に `dispose()` すると、閉じるアニメーションの
/// 最中にコントローラが死んで
/// 「A TextEditingController was used after being disposed」で落ちる。
class TextInputDialog extends StatefulWidget {
  final String? title;
  final String? hint;
  final String? initialValue;
  final int minLines;
  final int maxLines;

  /// コードを貼るときなど、等幅で出したいとき。
  final bool isMonospace;

  const TextInputDialog({
    this.title,
    this.hint,
    this.initialValue,
    this.minLines = 1,
    this.maxLines = 1,
    this.isMonospace = false,
    super.key,
  });

  /// 打たれた内容を返す。取り消されたら null。
  static Future<String?> show(
    BuildContext context, {
    String? title,
    String? hint,
    String? initialValue,
    int minLines = 1,
    int maxLines = 1,
    bool isMonospace = false,
  }) => showDialog<String>(
    context: context,
    builder: (context) => TextInputDialog(
      title: title,
      hint: hint,
      initialValue: initialValue,
      minLines: minLines,
      maxLines: maxLines,
      isMonospace: isMonospace,
    ),
  );

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title != null ? Text(widget.title!) : null,
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        keyboardType: widget.maxLines > 1 ? TextInputType.multiline : null,
        style: widget.isMonospace
            ? const TextStyle(fontFamily: "monospace")
            : null,
        decoration: InputDecoration(
          labelText: widget.hint,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: widget.maxLines > 1
            ? null
            : (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(S.of(context).done),
        ),
      ],
    );
  }
}
