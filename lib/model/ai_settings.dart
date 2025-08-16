import "package:freezed_annotation/freezed_annotation.dart";

part "ai_settings.freezed.dart";
part "ai_settings.g.dart";

@freezed
abstract class AiSettings with _$AiSettings {
  const factory AiSettings({
    @Default(false) bool isReactionSuggestionEnabled,
    @Default(false) bool isTranslationEnabled,
    @Default(false) bool isModelDownloaded,
    @Default("") String modelPath,
    @Default(0.8) double temperature,
    @Default(100) int maxTokens,
  }) = _AiSettings;

  factory AiSettings.fromJson(Map<String, Object?> json) =>
      _$AiSettingsFromJson(json);
}

enum AiFeatureType { reactionSuggestion, translation }

@freezed
abstract class AiInferenceRequest with _$AiInferenceRequest {
  const factory AiInferenceRequest({
    required String text,
    required AiFeatureType featureType,
    @Default("") String context,
    @Default(0.8) double temperature,
    @Default(100) int maxTokens,
  }) = _AiInferenceRequest;
}

@freezed
abstract class AiInferenceResult with _$AiInferenceResult {
  const factory AiInferenceResult({
    required String text,
    required bool isSuccess,
    String? error,
    @Default(0) int processingTimeMs,
  }) = _AiInferenceResult;
}
