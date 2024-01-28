import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json5/json5.dart';
import 'package:miria/model/color_theme.dart';
import 'package:miria/model/misskey_theme.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/themes/built_in_color_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class ColorThemeException implements Exception {}

class InvalidThemeFormatException implements ColorThemeException {}

class DuplicatedThemeException implements ColorThemeException {}

class ColorThemeRepository extends Notifier<List<ColorTheme>> {
  @override
  List<ColorTheme> build() {
    final codes = ref.watch(installedThemeCodeRepositoryProvider);
    return [
      ...builtInColorThemes,
      ...codes.map((code) {
        try {
          return ColorTheme.misskey(
            MisskeyTheme.fromJson(json5Decode(code) as Map<String, dynamic>),
          );
        } catch (e) {
          return null;
        }
      }).nonNulls,
    ];
  }

  Future<void> addTheme(String code) async {
    final ColorTheme theme;
    try {
      theme = ColorTheme.misskey(
        MisskeyTheme.fromJson(json5Decode(code) as Map<String, dynamic>),
      );
    } catch (e) {
      throw InvalidThemeFormatException();
    }
    if (state.any((element) => element.id == theme.id)) {
      throw DuplicatedThemeException();
    }

    await ref
        .read(installedThemeCodeRepositoryProvider.notifier)
        .addTheme(code);
  }

  Future<void> removeTheme(String id) async {
    await ref
        .read(installedThemeCodeRepositoryProvider.notifier)
        .removeTheme(id);
  }
}

class InstalledThemeCodeRepository extends Notifier<List<String>> {
  final prefsKey = "themes";

  @override
  List<String> build() {
    Future(load);
    return [];
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themes = prefs.getStringList(prefsKey);
    if (themes == null) {
      return;
    }
    state = themes;
  }

  Future<void> addTheme(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(prefsKey) ?? [];
    codes.add(code);
    await prefs.setStringList(prefsKey, codes);
    state = codes;
  }

  Future<void> removeTheme(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(prefsKey);
    codes!.removeWhere(
      (code) => (json5Decode(code) as Map<String, dynamic>)["id"] == id,
    );
    await prefs.setStringList(prefsKey, codes);
    state = codes;
  }
}
