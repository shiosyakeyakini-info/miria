// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountSettingsImpl _$$AccountSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$AccountSettingsImpl(
      userId: json['userId'] as String,
      host: json['host'] as String,
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      defaultNoteVisibility: $enumDecodeNullable(
              _$NoteVisibilityEnumMap, json['defaultNoteVisibility']) ??
          NoteVisibility.public,
      defaultIsLocalOnly: json['defaultIsLocalOnly'] as bool? ?? false,
      defaultReactionAcceptance: $enumDecodeNullable(
              _$ReactionAcceptanceEnumMap, json['defaultReactionAcceptance']) ??
          null,
    );

Map<String, dynamic> _$$AccountSettingsImplToJson(
        _$AccountSettingsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'host': instance.host,
      'reactions': instance.reactions,
      'defaultNoteVisibility':
          _$NoteVisibilityEnumMap[instance.defaultNoteVisibility]!,
      'defaultIsLocalOnly': instance.defaultIsLocalOnly,
      'defaultReactionAcceptance':
          _$ReactionAcceptanceEnumMap[instance.defaultReactionAcceptance],
    };

const _$NoteVisibilityEnumMap = {
  NoteVisibility.public: 'public',
  NoteVisibility.home: 'home',
  NoteVisibility.followers: 'followers',
  NoteVisibility.specified: 'specified',
};

const _$ReactionAcceptanceEnumMap = {
  ReactionAcceptance.likeOnlyForRemote: 'likeOnlyForRemote',
  ReactionAcceptance.nonSensitiveOnly: 'nonSensitiveOnly',
  ReactionAcceptance.nonSensitiveOnlyForLocalLikeOnlyForRemote:
      'nonSensitiveOnlyForLocalLikeOnlyForRemote',
  ReactionAcceptance.likeOnly: 'likeOnly',
};
