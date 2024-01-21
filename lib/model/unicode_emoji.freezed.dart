// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unicode_emoji.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UnicodeEmoji _$UnicodeEmojiFromJson(Map<String, dynamic> json) {
  return _UnicodeEmoji.fromJson(json);
}

/// @nodoc
mixin _$UnicodeEmoji {
  String get category => throw _privateConstructorUsedError;
  String get char => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnicodeEmojiCopyWith<UnicodeEmoji> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnicodeEmojiCopyWith<$Res> {
  factory $UnicodeEmojiCopyWith(
          UnicodeEmoji value, $Res Function(UnicodeEmoji) then) =
      _$UnicodeEmojiCopyWithImpl<$Res, UnicodeEmoji>;
  @useResult
  $Res call({String category, String char, String name, List<String> keywords});
}

/// @nodoc
class _$UnicodeEmojiCopyWithImpl<$Res, $Val extends UnicodeEmoji>
    implements $UnicodeEmojiCopyWith<$Res> {
  _$UnicodeEmojiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? char = null,
    Object? name = null,
    Object? keywords = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      char: null == char
          ? _value.char
          : char // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UnicodeEmojiCopyWith<$Res>
    implements $UnicodeEmojiCopyWith<$Res> {
  factory _$$_UnicodeEmojiCopyWith(
          _$_UnicodeEmoji value, $Res Function(_$_UnicodeEmoji) then) =
      __$$_UnicodeEmojiCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, String char, String name, List<String> keywords});
}

/// @nodoc
class __$$_UnicodeEmojiCopyWithImpl<$Res>
    extends _$UnicodeEmojiCopyWithImpl<$Res, _$_UnicodeEmoji>
    implements _$$_UnicodeEmojiCopyWith<$Res> {
  __$$_UnicodeEmojiCopyWithImpl(
      _$_UnicodeEmoji _value, $Res Function(_$_UnicodeEmoji) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? char = null,
    Object? name = null,
    Object? keywords = null,
  }) {
    return _then(_$_UnicodeEmoji(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      char: null == char
          ? _value.char
          : char // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UnicodeEmoji implements _UnicodeEmoji {
  const _$_UnicodeEmoji(
      {required this.category,
      required this.char,
      required this.name,
      required final List<String> keywords})
      : _keywords = keywords;

  factory _$_UnicodeEmoji.fromJson(Map<String, dynamic> json) =>
      _$$_UnicodeEmojiFromJson(json);

  @override
  final String category;
  @override
  final String char;
  @override
  final String name;
  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  String toString() {
    return 'UnicodeEmoji(category: $category, char: $char, name: $name, keywords: $keywords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UnicodeEmoji &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.char, char) || other.char == char) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, category, char, name,
      const DeepCollectionEquality().hash(_keywords));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UnicodeEmojiCopyWith<_$_UnicodeEmoji> get copyWith =>
      __$$_UnicodeEmojiCopyWithImpl<_$_UnicodeEmoji>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UnicodeEmojiToJson(
      this,
    );
  }
}

abstract class _UnicodeEmoji implements UnicodeEmoji {
  const factory _UnicodeEmoji(
      {required final String category,
      required final String char,
      required final String name,
      required final List<String> keywords}) = _$_UnicodeEmoji;

  factory _UnicodeEmoji.fromJson(Map<String, dynamic> json) =
      _$_UnicodeEmoji.fromJson;

  @override
  String get category;
  @override
  String get char;
  @override
  String get name;
  @override
  List<String> get keywords;
  @override
  @JsonKey(ignore: true)
  _$$_UnicodeEmojiCopyWith<_$_UnicodeEmoji> get copyWith =>
      throw _privateConstructorUsedError;
}
