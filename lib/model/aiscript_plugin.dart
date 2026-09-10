import "package:freezed_annotation/freezed_annotation.dart";

part "aiscript_plugin.freezed.dart";
part "aiscript_plugin.g.dart";

/// 入れてあるクライアントプラグイン。
///
/// 本家 Misskey の `Plugin` 型に対応する。プラグインは端末ごとに持ち、
/// アカウントでは分けない。「このプラグインを入れた」は端末の話なので。
/// 実行はアカウントごとに行う (`Mk:api` が使うトークンが違うため)。
@freezed
abstract class AiScriptPlugin with _$AiScriptPlugin {
  const factory AiScriptPlugin({
    /// 入れたときに振る識別子。同じプラグインを入れ直すと変わる。
    required String installId,
    required String name,
    required String version,
    required String author,

    /// AiScript のソース。
    required String src,
    String? description,

    /// プラグインが要求する権限。miria はまだトークンを分けていないので、
    /// 表示するだけで使っていない。
    @Default(<String>[]) List<String> permissions,

    /// メタデータに書かれた設定の定義。`{ キー: { type, label, default } }`。
    @Default(<String, dynamic>{}) Map<String, dynamic> config,

    /// 利用者が設定した値。`Plugin:config` にはこれを混ぜたものが渡る。
    @Default(<String, dynamic>{}) Map<String, dynamic> configData,

    @Default(true) bool active,
  }) = _AiScriptPlugin;

  const AiScriptPlugin._();

  factory AiScriptPlugin.fromJson(Map<String, Object?> json) =>
      _$AiScriptPluginFromJson(json);

  /// `Plugin:config` に渡す値。設定済みならその値を、なければ既定値を使う。
  Map<String, dynamic> get effectiveConfig => {
    for (final MapEntry(:key, :value) in config.entries)
      key: configData.containsKey(key)
          ? configData[key]
          : (value is Map ? value["default"] : null),
  };
}

/// プラグインのメタデータ。`parsePluginMeta` の結果。
@freezed
abstract class AiScriptPluginMeta with _$AiScriptPluginMeta {
  const factory AiScriptPluginMeta({
    required String name,
    required String version,
    required String author,
    String? description,
    @Default(<String>[]) List<String> permissions,
    @Default(<String, dynamic>{}) Map<String, dynamic> config,
  }) = _AiScriptPluginMeta;

  factory AiScriptPluginMeta.fromJson(Map<String, Object?> json) =>
      _$AiScriptPluginMetaFromJson(json);
}
