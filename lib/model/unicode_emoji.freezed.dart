// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unicode_emoji.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnicodeEmoji {

 String get category; String get char; String get name; List<String> get keywords;
/// Create a copy of UnicodeEmoji
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnicodeEmojiCopyWith<UnicodeEmoji> get copyWith => _$UnicodeEmojiCopyWithImpl<UnicodeEmoji>(this as UnicodeEmoji, _$identity);

  /// Serializes this UnicodeEmoji to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnicodeEmoji&&(identical(other.category, category) || other.category == category)&&(identical(other.char, char) || other.char == char)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.keywords, keywords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,char,name,const DeepCollectionEquality().hash(keywords));

@override
String toString() {
  return 'UnicodeEmoji(category: $category, char: $char, name: $name, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class $UnicodeEmojiCopyWith<$Res>  {
  factory $UnicodeEmojiCopyWith(UnicodeEmoji value, $Res Function(UnicodeEmoji) _then) = _$UnicodeEmojiCopyWithImpl;
@useResult
$Res call({
 String category, String char, String name, List<String> keywords
});




}
/// @nodoc
class _$UnicodeEmojiCopyWithImpl<$Res>
    implements $UnicodeEmojiCopyWith<$Res> {
  _$UnicodeEmojiCopyWithImpl(this._self, this._then);

  final UnicodeEmoji _self;
  final $Res Function(UnicodeEmoji) _then;

/// Create a copy of UnicodeEmoji
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? char = null,Object? name = null,Object? keywords = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,char: null == char ? _self.char : char // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UnicodeEmoji implements UnicodeEmoji {
  const _UnicodeEmoji({required this.category, required this.char, required this.name, required final  List<String> keywords}): _keywords = keywords;
  factory _UnicodeEmoji.fromJson(Map<String, dynamic> json) => _$UnicodeEmojiFromJson(json);

@override final  String category;
@override final  String char;
@override final  String name;
 final  List<String> _keywords;
@override List<String> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}


/// Create a copy of UnicodeEmoji
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnicodeEmojiCopyWith<_UnicodeEmoji> get copyWith => __$UnicodeEmojiCopyWithImpl<_UnicodeEmoji>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnicodeEmojiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnicodeEmoji&&(identical(other.category, category) || other.category == category)&&(identical(other.char, char) || other.char == char)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._keywords, _keywords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,char,name,const DeepCollectionEquality().hash(_keywords));

@override
String toString() {
  return 'UnicodeEmoji(category: $category, char: $char, name: $name, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class _$UnicodeEmojiCopyWith<$Res> implements $UnicodeEmojiCopyWith<$Res> {
  factory _$UnicodeEmojiCopyWith(_UnicodeEmoji value, $Res Function(_UnicodeEmoji) _then) = __$UnicodeEmojiCopyWithImpl;
@override @useResult
$Res call({
 String category, String char, String name, List<String> keywords
});




}
/// @nodoc
class __$UnicodeEmojiCopyWithImpl<$Res>
    implements _$UnicodeEmojiCopyWith<$Res> {
  __$UnicodeEmojiCopyWithImpl(this._self, this._then);

  final _UnicodeEmoji _self;
  final $Res Function(_UnicodeEmoji) _then;

/// Create a copy of UnicodeEmoji
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? char = null,Object? name = null,Object? keywords = null,}) {
  return _then(_UnicodeEmoji(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,char: null == char ? _self.char : char // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
