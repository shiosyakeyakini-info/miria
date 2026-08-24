import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

/// スクラッチパッドに書きかけのコードの置き場。
///
/// 本家 Misskey も localStorage に 1 本だけ持っていて、アカウントでは
/// 分けていない。ここもそれに倣う。
class ScratchpadRepository {
  static const _key = "aiscript:scratchpad";

  const ScratchpadRepository();

  Future<String?> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<void> save(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }
}

final scratchpadRepositoryProvider = Provider(
  (ref) => const ScratchpadRepository(),
);
