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
      iCacheStrategy:
          $enumDecodeNullable(_$CacheStrategyEnumMap, json['iCacheStrategy']) ??
              CacheStrategy.whenTabChange,
      latestICached: json['latestICached'] == null
          ? null
          : DateTime.parse(json['latestICached'] as String),
      emojiCacheStrategy: $enumDecodeNullable(
              _$CacheStrategyEnumMap, json['emojiCacheStrategy']) ??
          CacheStrategy.whenLaunch,
      latestEmojiCached: json['latestEmojiCached'] == null
          ? null
          : DateTime.parse(json['latestEmojiCached'] as String),
      metaChacheStrategy: $enumDecodeNullable(
              _$CacheStrategyEnumMap, json['metaChacheStrategy']) ??
          CacheStrategy.whenOneDay,
      latestMetaCached: json['latestMetaCached'] == null
          ? null
          : DateTime.parse(json['latestMetaCached'] as String),
      forceShowAd: json['forceShowAd'] as bool? ?? false,
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
      'iCacheStrategy': _$CacheStrategyEnumMap[instance.iCacheStrategy]!,
      'latestICached': instance.latestICached?.toIso8601String(),
      'emojiCacheStrategy':
          _$CacheStrategyEnumMap[instance.emojiCacheStrategy]!,
      'latestEmojiCached': instance.latestEmojiCached?.toIso8601String(),
      'metaChacheStrategy':
          _$CacheStrategyEnumMap[instance.metaChacheStrategy]!,
      'latestMetaCached': instance.latestMetaCached?.toIso8601String(),
      'forceShowAd': instance.forceShowAd,
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

const _$CacheStrategyEnumMap = {
  CacheStrategy.whenTabChange: 'whenTabChange',
  CacheStrategy.whenLaunch: 'whenLaunch',
  CacheStrategy.whenOneDay: 'whenOneDay',
};
