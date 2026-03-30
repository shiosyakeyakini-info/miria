import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:riverpod_shared_preferences/legacy.dart";

part "storage_provider.g.dart";

@Riverpod(keepAlive: true)
Future<LegacyJsonSharedPreferencesStorage> storage(Ref ref) async {
  return await LegacyJsonSharedPreferencesStorage.open();
}
