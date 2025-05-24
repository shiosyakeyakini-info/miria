// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unicode_emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnicodeEmoji _$UnicodeEmojiFromJson(Map<String, dynamic> json) =>
    _UnicodeEmoji(
      category: json['category'] as String,
      char: json['char'] as String,
      name: json['name'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UnicodeEmojiToJson(_UnicodeEmoji instance) =>
    <String, dynamic>{
      'category': instance.category,
      'char': instance.char,
      'name': instance.name,
      'keywords': instance.keywords,
    };
