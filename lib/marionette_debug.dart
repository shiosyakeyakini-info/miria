/// marionette_mcp（AI エージェントから実行中アプリを操作・観測する MCP サーバー）
/// との接続を debug ビルド限定で有効にする。
///
/// リリースビルドでは [kDebugMode] ガードによりすべて無効化され、marionette 由来の
/// コードはツリーシェイクで落ちる。アプリの状態を無制限に読めるため、
/// リリースに混入させてはならない。
///
/// 使い方は `marionette_riverpod_plugin/README.md` を参照。
library;

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:marionette_flutter/marionette_flutter.dart";
import "package:marionette_riverpod_plugin/marionette_riverpod_plugin.dart";
import "package:mfm/mfm.dart";
import "package:mfm_parser/mfm_parser.dart";
import "package:miria/log.dart";

/// root [ProviderContainer] を捕捉する observer。
///
/// Riverpod にはグローバルな container レジストリがないため、`riverpod_snapshot`
/// にどの container を見せるかはアプリ側から渡す必要がある。observer なら
/// 既存の [ProviderScope] に引数を 1 つ足すだけで済み、
/// `UncontrolledProviderScope` への組み替えが要らない。
final _observer = kDebugMode ? MarionetteRiverpodObserver() : null;

/// Flutter の binding を初期化する。
///
/// [WidgetsFlutterBinding.ensureInitialized] の代わりに `main()` の先頭で呼ぶこと。
/// debug 時は marionette の binding（[WidgetsFlutterBinding] の派生）を立て、
/// release 時は通常の binding を立てる。
void initializeMarionetteBinding() {
  if (!kDebugMode) {
    WidgetsFlutterBinding.ensureInitialized();
    return;
  }

  // miria のログ (lib/log.dart) を marionette の `get_logs` に流す。
  // これがないと `get_logs` は「ロガーが未設定」というエラーを返すだけになる。
  final logCollector = PrintLogCollector();
  MarionetteBinding.ensureInitialized(
    MarionetteConfiguration(
      logCollector: logCollector,
      extractText: _extractMfmText,
    ),
  );
  logger.onLogged = (log, info) => logCollector.addLog(log);

  registerRiverpodMarionetteExtensions(containerLocator: _observer!.locate);
  _registerSubmitTextExtension();
}

/// `TextInputAction` の名前と値の対応。拡張の `action` パラメータで使う。
const _textInputActions = <String, TextInputAction>{
  "done": TextInputAction.done,
  "go": TextInputAction.go,
  "search": TextInputAction.search,
  "send": TextInputAction.send,
  "next": TextInputAction.next,
  "previous": TextInputAction.previous,
  "newline": TextInputAction.newline,
  "unspecified": TextInputAction.unspecified,
};

/// フォーカスされているテキストフィールドに「確定」を送る拡張を登録する。
///
/// marionette 0.6.0 には submit にあたる操作がない。`enterText` は
/// [EditableTextState.updateEditingValue] を呼ぶだけで `performAction` を
/// 呼ばず、`pressKey enter` は [HardwareKeyboard] 経由なので
/// [TextInputClient] には届かない。結果として `onSubmitted` でしか起動しない
/// UI（miria ではノート検索）をエージェントから動かせない。
///
/// [EditableTextState.performAction] は [TextInputClient] の公開メソッドなので、
/// 拡張として登録すれば穴は埋まる。本来は marionette_flutter 本体
/// （あるいは `enterText` の `submit` オプション）に置かれるべきもので、
/// ここにあるのは上流に入るまでの暫定措置。
void _registerSubmitTextExtension() {
  registerMarionetteExtension(
    name: "text.submit",
    description:
        "Sends a TextInputAction to the focused text field, the way a "
        "software keyboard's confirm key does. enterText only rewrites the "
        "value and pressKey does not reach TextInputClient, so this is the "
        "only way to fire onSubmitted / onFieldSubmitted.",
    inputSchema: const ExtensionInputSchema(
      description: "Which confirm action to send. The field must be focused.",
      properties: {
        "action": ExtensionParam.string(
          description:
              "TextInputAction to perform. 'done' finalizes editing and "
              "unfocuses; 'next'/'previous' move focus; 'newline' is a no-op "
              "on a multiline field.",
          defaultValue: "done",
          enumValues: [
            "done",
            "go",
            "search",
            "send",
            "next",
            "previous",
            "newline",
            "unspecified",
          ],
        ),
      },
    ),
    callback: (params) async {
      final name = params["action"] ?? "done";
      final action = _textInputActions[name];
      if (action == null) {
        return MarionetteExtensionResult.invalidParams(
          'Unknown action "$name". Supported: '
          "${_textInputActions.keys.join(", ")}.",
        );
      }

      final state = _focusedEditableTextState();
      if (state == null) {
        return MarionetteExtensionResult.invalidParams(
          "No text field is focused. Tap the field first, then submit.",
        );
      }

      state.performAction(action);
      WidgetsBinding.instance.scheduleFrame();

      return MarionetteExtensionResult.success({
        "message": "Performed $name on the focused text field",
      });
    },
  );
}

/// フォーカス中の [EditableTextState] を返す。無ければ null。
///
/// marionette 内部の `TextInputSimulator` と同じ辿り方だが、あちらは
/// エクスポートされていないので複製している。
EditableTextState? _focusedEditableTextState() {
  final context = FocusManager.instance.primaryFocus?.context;
  if (context == null) {
    return null;
  }

  EditableTextState? found;
  context.visitAncestorElements((element) {
    if (element case StatefulElement(state: final EditableTextState state)) {
      found = state;
      return false;
    }
    return true;
  });
  return found;
}

/// ノート本文を marionette の要素ツリーに載せる。
///
/// mfm_renderer は最終的に `Text.rich(TextSpan(children: [WidgetSpan(...)]))`
/// を返す。marionette の走査は [Text] に達した時点で打ち切られ（この挙動は
/// 設定で外せない）、その [Text] の `toPlainText()` は WidgetSpan の
/// プレースホルダ `￼` だけなので、本文がまったく読めなくなる。
///
/// [Mfm] / [SimpleMfm] は [Text] より上にあるので、ここで元テキストを返せば
/// 走査が止まる前に拾われる。marionette 側の都合を mfm_renderer に持ち込まず、
/// debug ビルドだけで完結させるためにこの位置に置いている。
String? _extractMfmText(Element element) {
  return switch (element.widget) {
    Mfm(:final mfmText?) => mfmText,
    Mfm(:final mfmNode?) => _plainTextOf(mfmNode),
    SimpleMfm(:final mfmText) => mfmText,
    _ => null,
  };
}

/// パース済みの MFM を、書かれていた文字列に近い平文へ戻す。
///
/// 読むための文字列なので厳密な MFM の復元ではない。装飾（`**`、`$[...]`）は
/// 落として中身だけを繋ぎ、絵文字・メンション・ハッシュタグ・URL は
/// 表示上そう見える形に整える。
String? _plainTextOf(List<MfmNode> nodes) {
  final buffer = StringBuffer();

  void visit(List<MfmNode> nodes) {
    for (final node in nodes) {
      switch (node) {
        case MfmText(:final text):
          buffer.write(text);
        case MfmPlain(:final text):
          buffer.write(text);
        case MfmUnicodeEmoji(:final emoji):
          buffer.write(emoji);
        case MfmEmojiCode(:final name):
          buffer.write(":$name:");
        case MfmHashTag(:final hashTag):
          buffer.write("#$hashTag");
        case MfmMention(:final acct):
          buffer.write(acct);
        case MfmURL(:final value):
          buffer.write(value);
        case MfmInlineCode(:final code):
          buffer.write(code);
        case MfmCodeBlock(:final code):
          buffer.write(code);
        case MfmMathInline(:final formula):
          buffer.write(formula);
        case MfmMathBlock(:final formula):
          buffer.write(formula);
        case MfmSearch(:final content):
          buffer.write(content);
        default:
          if (node.children case final children?) {
            visit(children);
          }
      }
    }
  }

  visit(nodes);
  return buffer.isEmpty ? null : buffer.toString();
}

/// [ProviderScope] に渡す observer。release ビルドでは空になる。
List<ProviderObserver> get marionetteObservers => [?_observer];
