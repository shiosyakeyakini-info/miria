import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:shared_preferences/shared_preferences.dart";

/// AiScript の `Mk:save` / `Mk:load` / `Mk:remove` の置き場。
///
/// 本家 Misskey は localStorage に `aiscript:<名前空間>:<キー>` で持つので、
/// それに倣って SharedPreferences 上に同じ形で置く。アカウントごとに
/// 分けたいので名前空間の手前にホストとユーザー名を挟む。
///
/// 値は AiScript 側で JSON 化された文字列がそのまま来る。中身は解釈しない。
class AiScriptStorageRepository {
  /// 名前空間。Play なら `flash:<PlayのID>` のような値が入る。
  final String namespace;

  const AiScriptStorageRepository({required this.namespace});

  String _key(String key) => "aiscript:$namespace:$key";

  Future<void> save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(key), value);
  }

  /// 未設定のキーは AiScript の null として返す。
  Future<String> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key(key)) ?? "null";
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(key));
  }

  /// この名前空間に属するものをすべて消す。
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = "aiscript:$namespace:";
    for (final key in prefs.getKeys().where((key) => key.startsWith(prefix))) {
      await prefs.remove(key);
    }
  }
}

/// アカウントと名前空間の組で AiScript のストレージを引く。
final aiScriptStorageRepositoryProvider = Provider.autoDispose
    .family<AiScriptStorageRepository, ({Account account, String namespace})>((
      ref,
      arg,
    ) {
      final account = arg.account;
      return AiScriptStorageRepository(
        namespace: "${account.host}:${account.userId}:${arg.namespace}",
      );
    });
