import "package:json5/json5.dart";
import "package:miria/model/color_theme.dart";
import "package:miria/model/misskey_theme.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "misskey_theme_codes_notifier.g.dart";

@riverpod
class MisskeyThemeCodesNotifier extends _$MisskeyThemeCodesNotifier {
  @override
  FutureOr<List<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static const _key = "themes";

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final value = await future;
    await prefs.setStringList(_key, value);
  }

  Future<void> install(String code) async {
    state = AsyncData([...?state.value, code]);
    await _save();
  }

  Future<void> uninstall(int index) async {
    state = AsyncData([
      ...?state.value?.sublist(0, index),
      ...?state.value?.sublist(index + 1),
    ]);
    await _save();
  }

  Future<void> import(List<String> codes) async {
    state = AsyncData(codes);
    await _save();
  }
}

@riverpod
List<MisskeyTheme?> misskeyThemes(Ref ref) {
  final codes = ref.watch(misskeyThemeCodesNotifierProvider).value ?? [];
  return codes.map((code) {
    try {
      return MisskeyTheme.fromJson(json5Decode(code) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }).toList();
}

@riverpod
List<ColorTheme> installedColorThemes(Ref ref) {
  final themes = ref.watch(misskeyThemesProvider);
  return themes.nonNulls
      .map((theme) {
        try {
          return ColorTheme.misskey(theme);
        } catch (_) {
          return null;
        }
      })
      .nonNulls
      .toList();
}
