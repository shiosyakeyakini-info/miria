import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/aiscript_plugin.dart";
import "package:shared_preferences/shared_preferences.dart";

/// 入れてあるプラグインの一覧の置き場。
///
/// 端末に 1 本だけ持つ。アカウントでは分けない。
class AiScriptPluginRepository {
  static const _key = "aiscript:plugins";

  const AiScriptPluginRepository();

  Future<List<AiScriptPlugin>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => AiScriptPlugin.fromJson(e as Map<String, Object?>))
          .toList();
    } catch (_) {
      // 壊れていたら握りつぶす。ここで例外を投げるとアプリが起動しない
      return const [];
    }
  }

  Future<void> save(List<AiScriptPlugin> plugins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(plugins.map((e) => e.toJson()).toList()),
    );
  }

  /// プラグインが `Mk:save` で置いたものを消す。
  ///
  /// 本家もアンインストール時に `aiscript:plugins:<installId>` で始まる
  /// localStorage のキーを消している。
  Future<void> clearStorage(String installId) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = "aiscript:";
    final infix = ":plugins:$installId:";
    for (final key in prefs.getKeys().where(
      (key) => key.startsWith(prefix) && key.contains(infix),
    )) {
      await prefs.remove(key);
    }
  }
}

final aiScriptPluginRepositoryProvider = Provider(
  (ref) => const AiScriptPluginRepository(),
);
