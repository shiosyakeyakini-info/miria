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
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter/services.dart";
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
      extractText: extractMarionetteText,
    ),
  );
  logger.onLogged = (log, info) => logCollector.addLog(log);

  registerRiverpodMarionetteExtensions(containerLocator: _observer!.locate);
  _registerSubmitTextExtension();
  _registerPerformanceExtensions();
  SchedulerBinding.instance.addTimingsCallback(_collectFrameTimings);
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

/// marionette の `extractText` に渡す本体。
///
/// 組み込みの抽出（[Text] や [TextField] など）が null を返したときだけ呼ばれる。
@visibleForTesting
String? extractMarionetteText(Element element) =>
    _extractMfmText(element) ?? _extractButtonLabel(element);

/// ラベルを直接持たないボタン類に、配下の [Text] をラベルとして与える。
///
/// marionette は操作可能ウィジェットで走査を打ち切る（`shouldStopAtType`）。
/// [InkWell] と [GestureDetector] だけは例外で子まで降りるため、それらで
/// 組まれたタブなどはラベルが要素一覧に出る。一方 Material のボタン類は
/// 走査が止まるので、子の [Text] が一覧にまったく現れない。結果、確認
/// ダイアログの「削除する」「やっぱやめる」がどちらも `TextButton ''` になり、
/// 座標でしか撃ち分けられなくなる（実際に取り違えが起きた）。
///
/// 走査が止まる前に呼ばれる `extractText` で配下を自前で辿ってラベルを
/// 組み立てれば、`tap --text "削除する"` が通るようになる。
///
/// 走査が止まるウィジェットにしか適用しないので、要素の数は増えない。
/// これらは元から操作可能で一覧に載っており、空だった `text` が埋まるだけ。
String? _extractButtonLabel(Element element) {
  if (!_isLabelledButton(element.widget)) return null;

  final parts = <String>[];

  void visit(Element element) {
    if (parts.length >= _maxLabelParts) return;

    // アイコンは [Icon] が内部で [RichText] を作り、その平文はフォントの
    // 私用領域のコードポイント（`` など）になる。ラベルとしては
    // ノイズにしかならないので、[Icon] より下は見ない。
    if (element.widget is Icon) return;

    final text = _extractMfmText(element) ?? _labelTextOf(element.widget);
    if (text != null) {
      final trimmed = text.trim();
      if (trimmed.isNotEmpty) parts.add(trimmed);
      // [Text] より下は同じ文字列の作り直しなので降りない。
      return;
    }

    element.visitChildren(visit);
  }

  element.visitChildren(visit);

  return parts.isEmpty ? null : parts.join(" ");
}

/// ラベルを合成する対象。いずれも marionette の走査が止まるウィジェット。
bool _isLabelledButton(Widget widget) =>
    widget is ButtonStyleButton ||
    widget is FloatingActionButton ||
    widget is IconButton ||
    widget is DropdownButton ||
    widget is PopupMenuButton ||
    widget is CheckboxListTile ||
    widget is RadioListTile ||
    widget is SwitchListTile;

/// ラベルとして読める平文を持つウィジェットならそれを返す。
String? _labelTextOf(Widget widget) => switch (widget) {
  Text(:final data?) => data,
  Text(:final textSpan?) => textSpan.toPlainText(),
  RichText(:final text) => text.toPlainText(),
  _ => null,
};

/// 1 つのボタンから拾うラベルの上限。
///
/// アイコン + 短い語という構成を想定しており、これを超える要素を持つボタンの
/// 全文が要るとは考えにくい。走査が止まらない構造を踏んだときの保険でもある。
const _maxLabelParts = 4;

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

/// 直近のフレームの計測値。`perf.frames` が読む。
///
/// [FrameTiming] は「そのフレームを何ミリ秒で組み立て、何ミリ秒でラスタライズ
/// したか」を engine が事後に報告してくるもの。UI スレッドと raster スレッドが
/// 分かれて出るので、「ビルドが重い」のか「描画が重い」のかがここで分かれる。
final _frameTimings = <FrameTiming>[];

/// 保持するフレーム数。60fps でおよそ10秒ぶん。
const _frameHistoryLength = 600;

void _collectFrameTimings(List<FrameTiming> timings) {
  _frameTimings.addAll(timings);
  final excess = _frameTimings.length - _frameHistoryLength;
  if (excess > 0) _frameTimings.removeRange(0, excess);
}

/// 動いているアプリの重さを外から測るための拡張を登録する。
///
/// DevTools を開けば同じものは見られるが、エージェントからは GUI を読めない。
/// VM Service には `getMemoryUsage` / `getProcessMemoryUsage` /
/// `getAllocationProfile` があってヒープと RSS はそれで足りるので、ここで足すのは
/// Flutter 側にしかない3つ  —  フレーム時間、画像キャッシュ、ツリーの大きさ。
void _registerPerformanceExtensions() {
  registerMarionetteExtension(
    name: "perf.frames",
    description:
        "Frame timings the engine reported for the last few seconds, split "
        "into UI (build+layout+paint) and raster (GPU) time. Use it to tell a "
        "slow build from slow rasterization while scrolling.",
    inputSchema: const ExtensionInputSchema(
      description: "Reads the buffered frame timings.",
      properties: {
        "reset": ExtensionParam.boolean(
          description:
              "Drop the buffer after reading, so the next call only covers "
              "what happened after this one. Measure an interaction by "
              "resetting, doing it, then reading.",
          defaultValue: false,
        ),
      },
    ),
    callback: (params) async {
      final timings = List<FrameTiming>.from(_frameTimings);
      if (params["reset"] == "true") _frameTimings.clear();

      if (timings.isEmpty) {
        return MarionetteExtensionResult.success({
          "frames": 0,
          "message":
              "No frames were recorded. A still screen produces no frames at "
              "all; do something first, or scroll.",
        });
      }

      final build = timings
          .map((t) => t.buildDuration.inMicroseconds / 1000)
          .toList();
      final raster = timings
          .map((t) => t.rasterDuration.inMicroseconds / 1000)
          .toList();
      final total = timings
          .map((t) => t.totalSpan.inMicroseconds / 1000)
          .toList();

      return MarionetteExtensionResult.success({
        "frames": timings.length,
        "buildMs": _describe(build),
        "rasterMs": _describe(raster),
        "totalSpanMs": _describe(total),
        // 16.7ms を越えたフレームは 60Hz なら落としている。
        "over16ms": total.where((ms) => ms > 16.7).length,
        "over100ms": total.where((ms) => ms > 100).length,
      });
    },
  );

  registerMarionetteExtension(
    name: "perf.imageCache",
    description:
        "Flutter's decoded-image cache. `liveBytes` is what on-screen widgets "
        "are holding right now; a screen that keeps every tile alive keeps "
        "every bitmap alive with it.",
    inputSchema: const ExtensionInputSchema(
      description: "Reads (and optionally empties) the image cache.",
      properties: {
        "clear": ExtensionParam.boolean(
          description:
              "Evict everything after reading. Useful to see how much of the "
              "memory comes back on its own.",
          defaultValue: false,
        ),
      },
    ),
    callback: (params) async {
      final cache = PaintingBinding.instance.imageCache;
      final result = {
        "count": cache.currentSize,
        "bytes": cache.currentSizeBytes,
        "liveCount": cache.liveImageCount,
        "pendingCount": cache.pendingImageCount,
        "maximumCount": cache.maximumSize,
        "maximumBytes": cache.maximumSizeBytes,
      };
      if (params["clear"] == "true") {
        cache
          ..clear()
          ..clearLiveImages();
      }
      return MarionetteExtensionResult.success(result);
    },
  );

  registerMarionetteExtension(
    name: "perf.tree",
    description:
        "How many elements and render objects the tree currently holds, and "
        "which widget types dominate. A lazily built list keeps this flat as "
        "you scroll; one that materializes everything does not.",
    inputSchema: const ExtensionInputSchema(
      description: "Counts the live element tree.",
      properties: {
        "top": ExtensionParam.integer(
          description: "How many of the most numerous widget types to list.",
          defaultValue: 15,
          minimum: 0,
        ),
        "filter": ExtensionParam.string(
          description:
              "Only count widget types whose name contains this substring "
              "(case-insensitive). The totals still cover the whole tree.",
        ),
      },
    ),
    callback: (params) async {
      final root = WidgetsBinding.instance.rootElement;
      if (root == null) {
        return MarionetteExtensionResult.invalidParams(
          "The widget tree is not mounted yet.",
        );
      }

      final counts = <String, int>{};
      var elements = 0;
      var renderObjects = 0;
      final filter = params["filter"]?.toLowerCase();

      void visit(Element element) {
        elements++;
        if (element is RenderObjectElement) renderObjects++;
        final name = element.widget.runtimeType.toString();
        if (filter == null || name.toLowerCase().contains(filter)) {
          counts[name] = (counts[name] ?? 0) + 1;
        }
        element.visitChildren(visit);
      }

      visit(root);

      final top = int.tryParse(params["top"] ?? "") ?? 15;
      final ranked = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return MarionetteExtensionResult.success({
        "elements": elements,
        "renderObjects": renderObjects,
        "widgets": {
          for (final entry in ranked.take(top)) entry.key: entry.value,
        },
      });
    },
  );
}

/// 平均・中央値・p90・最大をまとめる。小数第2位まで。
Map<String, double> _describe(List<double> values) {
  final sorted = List<double>.from(values)..sort();
  double at(double q) =>
      sorted[(sorted.length * q).clamp(0, sorted.length - 1).floor()];
  double round(double value) => (value * 100).roundToDouble() / 100;

  return {
    "avg": round(values.reduce((a, b) => a + b) / values.length),
    "p50": round(at(0.5)),
    "p90": round(at(0.9)),
    "max": round(sorted.last),
  };
}
