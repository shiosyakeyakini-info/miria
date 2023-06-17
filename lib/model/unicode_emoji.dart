import 'package:freezed_annotation/freezed_annotation.dart';

part 'unicode_emoji.freezed.dart';
part 'unicode_emoji.g.dart';

@freezed
class UnicodeEmoji with _$UnicodeEmoji {
  const factory UnicodeEmoji({
    required String category,
    required String char,
    required String name,
    required List<String> keywords,
  }) = _UnicodeEmoji;

  factory UnicodeEmoji.fromJson(Map<String, dynamic> json) =>
      _$UnicodeEmojiFromJson(json);
}
