import "package:miria/model/ai_settings.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "ai_settings_repository.g.dart";

@riverpod
class AiSettingsRepository extends _$AiSettingsRepository {
  static const String _keyReactionSuggestion = "ai_reaction_suggestion_enabled";
  static const String _keyTranslation = "ai_translation_enabled";
  static const String _keyModelDownloaded = "ai_model_downloaded";
  static const String _keyModelPath = "ai_model_path";
  static const String _keyTemperature = "ai_temperature";
  static const String _keyMaxTokens = "ai_max_tokens";

  @override
  Future<AiSettings> build() async {
    return await load();
  }

  /// AI設定を読み込む
  Future<AiSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    return AiSettings(
      isReactionSuggestionEnabled:
          prefs.getBool(_keyReactionSuggestion) ?? false,
      isTranslationEnabled: prefs.getBool(_keyTranslation) ?? false,
      isModelDownloaded: prefs.getBool(_keyModelDownloaded) ?? false,
      modelPath: prefs.getString(_keyModelPath) ?? "",
      temperature: prefs.getDouble(_keyTemperature) ?? 0.8,
      maxTokens: prefs.getInt(_keyMaxTokens) ?? 100,
    );
  }

  /// リアクション提案機能の有効/無効を設定
  Future<void> setReactionSuggestionEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyReactionSuggestion, enabled);

    final current = await future;
    state = AsyncValue.data(
      current.copyWith(isReactionSuggestionEnabled: enabled),
    );
  }

  /// 翻訳機能の有効/無効を設定
  Future<void> setTranslationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTranslation, enabled);

    final current = await future;
    state = AsyncValue.data(current.copyWith(isTranslationEnabled: enabled));
  }

  /// モデルダウンロード状態を設定
  Future<void> setModelDownloaded(bool downloaded, [String? modelPath]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyModelDownloaded, downloaded);

    if (modelPath != null) {
      await prefs.setString(_keyModelPath, modelPath);
    }

    final current = await future;
    state = AsyncValue.data(
      current.copyWith(
        isModelDownloaded: downloaded,
        modelPath: modelPath ?? current.modelPath,
      ),
    );
  }

  /// 温度パラメータを設定
  Future<void> setTemperature(double temperature) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTemperature, temperature);

    final current = await future;
    state = AsyncValue.data(current.copyWith(temperature: temperature));
  }

  /// 最大トークン数を設定
  Future<void> setMaxTokens(int maxTokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMaxTokens, maxTokens);

    final current = await future;
    state = AsyncValue.data(current.copyWith(maxTokens: maxTokens));
  }

  /// 設定を一括更新
  Future<void> updateSettings(AiSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.setBool(
        _keyReactionSuggestion,
        settings.isReactionSuggestionEnabled,
      ),
      prefs.setBool(_keyTranslation, settings.isTranslationEnabled),
      prefs.setBool(_keyModelDownloaded, settings.isModelDownloaded),
      prefs.setString(_keyModelPath, settings.modelPath),
      prefs.setDouble(_keyTemperature, settings.temperature),
      prefs.setInt(_keyMaxTokens, settings.maxTokens),
    ]);

    state = AsyncValue.data(settings);
  }
}
