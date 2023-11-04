// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unicode_emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnicodeEmojiImpl _$$UnicodeEmojiImplFromJson(Map<String, dynamic> json) =>
    _$UnicodeEmojiImpl(
      category: json['category'] as String,
      char: json['char'] as String,
      name: json['name'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$UnicodeEmojiImplToJson(_$UnicodeEmojiImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'char': instance.char,
      'name': instance.name,
      'keywords': instance.keywords,
    };
