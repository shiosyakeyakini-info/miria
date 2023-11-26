// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unicode_emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UnicodeEmoji _$$_UnicodeEmojiFromJson(Map<String, dynamic> json) =>
    _$_UnicodeEmoji(
      category: json['category'] as String,
      char: json['char'] as String,
      name: json['name'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_UnicodeEmojiToJson(_$_UnicodeEmoji instance) =>
    <String, dynamic>{
      'category': instance.category,
      'char': instance.char,
      'name': instance.name,
      'keywords': instance.keywords,
    };
