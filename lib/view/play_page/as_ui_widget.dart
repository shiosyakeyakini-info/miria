import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/router/app_router.dart";
import "package:miria/rust/api/aiscript/ui.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";

/// AiScript の `Ui:render` が組み立てたコンポーネントを描く。
///
/// Rust 側からは「id → コンポーネント」の対応表が届き、子は id の参照として
/// 表現される。ここはその対応表を辿りながら再帰的にウィジェットへ変換する。
///
/// 対応するのは本家 Misskey の `Ui:C:*` 14 種。
class AsUiWidget extends ConsumerWidget {
  /// AiScript から届いた「id → コンポーネント」の対応表。
  final Map<String, AsUiComponent> components;

  /// いま描こうとしているコンポーネントの id。
  final String componentId;

  final Account account;

  const AsUiWidget({
    required this.components,
    required this.account,
    this.componentId = rootComponentId,
    super.key,
  });

  /// `Ui:render` の受け皿。Rust 側もこの id で根を作る。
  static const rootComponentId = "___root___";

  AsUiWidget _child(String id) =>
      AsUiWidget(components: components, account: account, componentId: id);

  /// 非表示のコンテナは子ごと描かない。
  bool _isVisible(String id) => switch (components[id]) {
    AsUiComponent_Container(field0: AsUiContainer(hidden: true)) => false,
    _ => true,
  };

  List<Widget> _children(List<String>? ids) =>
      (ids ?? []).where(_isVisible).map(_child).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (components[componentId]) {
      AsUiComponent_Root(field0: AsUiRoot(:final children)) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: _children(children),
      ),
      AsUiComponent_Container(field0: final container) => _container(
        context,
        container,
      ),
      AsUiComponent_Text(field0: final text) => Text(
        text.text ?? "",
        style: _textStyle(context, text.size, text.bold, text.color),
      ),
      AsUiComponent_Mfm(field0: final mfm) => _mfm(context, mfm),
      AsUiComponent_Button(field0: final button) => _button(context, button),
      AsUiComponent_Buttons(field0: AsUiButtons(:final buttons)) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final button in buttons ?? <AsUiButton>[])
            _button(context, button),
        ],
      ),
      AsUiComponent_ToggleSwitch(field0: final toggle) => _AsUiSwitchField(
        component: toggle,
      ),
      AsUiComponent_Textarea(field0: final textarea) => _AsUiTextField(
        label: textarea.label,
        caption: textarea.caption,
        defaultValue: textarea.defaultValue,
        maxLines: 5,
        onInput: (value) => textarea.onInput?.call(value: value),
      ),
      AsUiComponent_TextInput(field0: final input) => _AsUiTextField(
        label: input.label,
        caption: input.caption,
        defaultValue: input.defaultValue,
        maxLines: 1,
        onInput: (value) => input.onInput?.call(value: value),
      ),
      AsUiComponent_NumberInput(field0: final input) => _AsUiTextField(
        label: input.label,
        caption: input.caption,
        defaultValue: input.defaultValue?.toString(),
        maxLines: 1,
        keyboardType: TextInputType.number,
        onInput: (value) {
          final number = double.tryParse(value);
          if (number != null) {
            unawaited(input.onInput?.call(value: number));
          }
        },
      ),
      AsUiComponent_Select(field0: final select) => _AsUiSelectField(
        component: select,
      ),
      AsUiComponent_Folder(field0: final folder) => ExpansionTile(
        title: Text(folder.title ?? ""),
        initiallyExpanded: folder.opened ?? true,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: _children(folder.children),
      ),
      AsUiComponent_PostFormButton(field0: final postFormButton) => _button(
        context,
        AsUiButton(
          text: postFormButton.text,
          primary: postFormButton.primary,
          rounded: postFormButton.rounded,
        ),
        onPressed: () => _openPostForm(context, postFormButton.form),
      ),
      AsUiComponent_PostForm(field0: AsUiPostForm(:final form)) => Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _openPostForm(context, form),
          icon: const Icon(Icons.edit),
          label: Text(form?.text ?? ""),
        ),
      ),
      // 未知のコンポーネントは黙って落とす。AiScript 側の実行は止めない
      null || _ => const SizedBox.shrink(),
    };
  }

  Widget _container(BuildContext context, AsUiContainer container) {
    final borderColor = _parseColor(container.borderColor);
    final borderWidth = container.borderWidth ?? 0;
    final radius =
        container.borderRadius ?? ((container.rounded ?? false) ? 8.0 : 0.0);
    final foreground = _parseColor(container.fgColor);

    final column = Column(
      crossAxisAlignment: switch (container.align) {
        "center" => CrossAxisAlignment.center,
        "right" => CrossAxisAlignment.end,
        _ => CrossAxisAlignment.stretch,
      },
      spacing: 8,
      children: _children(container.children),
    );

    return Container(
      padding: EdgeInsets.all(container.padding ?? 0),
      decoration: BoxDecoration(
        color: _parseColor(container.bgColor),
        borderRadius: BorderRadius.circular(radius),
        border: borderWidth > 0 && container.borderStyle != "none"
            ? Border.all(
                color: borderColor ?? Theme.of(context).colorScheme.outline,
                width: borderWidth,
              )
            : null,
      ),
      child: foreground != null
          ? DefaultTextStyle.merge(
              style: TextStyle(color: foreground),
              child: column,
            )
          : column,
    );
  }

  Widget _mfm(BuildContext context, AsUiMfm mfm) {
    final text = MfmText(
      mfmText: mfm.text ?? "",
      host: account.host,
      style: _textStyle(context, mfm.size, mfm.bold, mfm.color),
    );
    final onClickEv = mfm.onClickEv;
    if (onClickEv == null) return text;
    return InkWell(
      onTap: () => onClickEv.call(value: mfm.text ?? ""),
      child: text,
    );
  }

  Widget _button(
    BuildContext context,
    AsUiButton button, {
    VoidCallback? onPressed,
  }) {
    final label = Text(button.text ?? "");
    final callback = (button.disabled ?? false)
        ? null
        : onPressed ?? () => button.onClick?.call();
    final shape = (button.rounded ?? false)
        ? const StadiumBorder()
        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));

    return Align(
      alignment: Alignment.centerLeft,
      child: (button.primary ?? false)
          ? ElevatedButton(
              onPressed: callback,
              style: ElevatedButton.styleFrom(shape: shape),
              child: label,
            )
          : OutlinedButton(
              onPressed: callback,
              style: OutlinedButton.styleFrom(shape: shape),
              child: label,
            ),
    );
  }

  /// 投稿フォームを開く。
  ///
  /// 本家は cw と公開範囲もフォームに載せられるが、miria の
  /// [NoteCreateRoute] は本文しか受け取れないので、いまは本文だけ渡す。
  void _openPostForm(BuildContext context, PostFormPropsForAsUi? form) {
    unawaited(
      context.pushRoute(
        NoteCreateRoute(initialAccount: account, initialText: form?.text),
      ),
    );
  }

  TextStyle? _textStyle(
    BuildContext context,
    double? size,
    bool? bold,
    String? color,
  ) {
    if (size == null && bold == null && color == null) return null;
    final base = DefaultTextStyle.of(context).style;
    return base.copyWith(
      fontSize: size != null ? base.fontSize! * size : null,
      fontWeight: (bold ?? false) ? FontWeight.bold : null,
      color: _parseColor(color),
    );
  }
}

/// AiScript から来る色は `f00` や `ff0000` のような # のない 16 進。
Color? _parseColor(String? value) {
  if (value == null) return null;
  final hex = value.startsWith("#") ? value.substring(1) : value;
  final expanded = switch (hex.length) {
    3 => hex.split("").map((c) => "$c$c").join(),
    6 => hex,
    _ => null,
  };
  if (expanded == null) return null;
  final parsed = int.tryParse(expanded, radix: 16);
  return parsed != null ? Color(0xFF000000 | parsed) : null;
}

/// `Ui:C:textInput` / `textarea` / `numberInput` の入力欄。
class _AsUiTextField extends StatefulWidget {
  final String? label;
  final String? caption;
  final String? defaultValue;
  final int maxLines;
  final TextInputType? keyboardType;
  final void Function(String value) onInput;

  const _AsUiTextField({
    required this.maxLines,
    required this.onInput,
    this.label,
    this.caption,
    this.defaultValue,
    this.keyboardType,
  });

  @override
  State<_AsUiTextField> createState() => _AsUiTextFieldState();
}

class _AsUiTextFieldState extends State<_AsUiTextField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.defaultValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.caption,
        helperMaxLines: 5,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: widget.onInput,
    );
  }
}

/// `Ui:C:switch`。
class _AsUiSwitchField extends StatefulWidget {
  final AsUiSwitch component;

  const _AsUiSwitchField({required this.component});

  @override
  State<_AsUiSwitchField> createState() => _AsUiSwitchFieldState();
}

class _AsUiSwitchFieldState extends State<_AsUiSwitchField> {
  late bool _value = widget.component.defaultValue ?? false;

  @override
  Widget build(BuildContext context) {
    final caption = widget.component.caption;
    return SwitchListTile(
      value: _value,
      title: Text(widget.component.label ?? ""),
      subtitle: caption != null ? Text(caption) : null,
      contentPadding: EdgeInsets.zero,
      onChanged: (value) {
        setState(() => _value = value);
        unawaited(widget.component.onChange?.call(value: value));
      },
    );
  }
}

/// `Ui:C:select`。
class _AsUiSelectField extends StatefulWidget {
  final AsUiSelect component;

  const _AsUiSelectField({required this.component});

  @override
  State<_AsUiSelectField> createState() => _AsUiSelectFieldState();
}

class _AsUiSelectFieldState extends State<_AsUiSelectField> {
  late String? _value = widget.component.defaultValue;

  @override
  Widget build(BuildContext context) {
    final items = widget.component.items ?? const <(String, String)>[];
    return DropdownButtonFormField<String>(
      initialValue: items.any((item) => item.$2 == _value) ? _value : null,
      decoration: InputDecoration(
        labelText: widget.component.label,
        helperText: widget.component.caption,
        helperMaxLines: 5,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        for (final (text, value) in items)
          DropdownMenuItem(value: value, child: Text(text)),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() => _value = value);
        unawaited(widget.component.onChange?.call(value: value));
      },
    );
  }
}
