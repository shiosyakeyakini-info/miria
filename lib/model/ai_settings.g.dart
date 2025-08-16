// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiSettings _$AiSettingsFromJson(Map<String, dynamic> json) => _AiSettings(
  isReactionSuggestionEnabled:
      json['isReactionSuggestionEnabled'] as bool? ?? false,
  isTranslationEnabled: json['isTranslationEnabled'] as bool? ?? false,
  isModelDownloaded: json['isModelDownloaded'] as bool? ?? false,
  modelPath: json['modelPath'] as String? ?? "",
  temperature: (json['temperature'] as num?)?.toDouble() ?? 0.8,
  maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 100,
);

Map<String, dynamic> _$AiSettingsToJson(_AiSettings instance) =>
    <String, dynamic>{
      'isReactionSuggestionEnabled': instance.isReactionSuggestionEnabled,
      'isTranslationEnabled': instance.isTranslationEnabled,
      'isModelDownloaded': instance.isModelDownloaded,
      'modelPath': instance.modelPath,
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
    };
