import "dart:convert";

import "package:miria/model/general_settings.dart";
import "package:miria/providers/storage_provider.dart";
import "package:riverpod/experimental/persist.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "general_settings_notifier.g.dart";

@Riverpod(keepAlive: true)
class GeneralSettingsNotifier extends _$GeneralSettingsNotifier {
  @override
  GeneralSettings build() {
    persist(
      ref.watch(storageProvider.future),
      key: "general_settings",
      options: const StorageOptions(cacheTime: StorageCacheTime.unsafe_forever),
      encode: (s) => jsonEncode(s.toJson()),
      decode: (json) =>
          GeneralSettings.fromJson(jsonDecode(json) as Map<String, dynamic>),
    );
    return const GeneralSettings();
  }

  void updateSettings(GeneralSettings settings) {
    state = settings;
  }
}
