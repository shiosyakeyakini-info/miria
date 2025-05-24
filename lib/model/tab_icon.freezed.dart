// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tab_icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TabIcon {

 int? get codePoint; String? get customEmojiName;
/// Create a copy of TabIcon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabIconCopyWith<TabIcon> get copyWith => _$TabIconCopyWithImpl<TabIcon>(this as TabIcon, _$identity);

  /// Serializes this TabIcon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabIcon&&(identical(other.codePoint, codePoint) || other.codePoint == codePoint)&&(identical(other.customEmojiName, customEmojiName) || other.customEmojiName == customEmojiName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,codePoint,customEmojiName);

@override
String toString() {
  return 'TabIcon(codePoint: $codePoint, customEmojiName: $customEmojiName)';
}


}

/// @nodoc
abstract mixin class $TabIconCopyWith<$Res>  {
  factory $TabIconCopyWith(TabIcon value, $Res Function(TabIcon) _then) = _$TabIconCopyWithImpl;
@useResult
$Res call({
 int? codePoint, String? customEmojiName
});




}
/// @nodoc
class _$TabIconCopyWithImpl<$Res>
    implements $TabIconCopyWith<$Res> {
  _$TabIconCopyWithImpl(this._self, this._then);

  final TabIcon _self;
  final $Res Function(TabIcon) _then;

/// Create a copy of TabIcon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? codePoint = freezed,Object? customEmojiName = freezed,}) {
  return _then(_self.copyWith(
codePoint: freezed == codePoint ? _self.codePoint : codePoint // ignore: cast_nullable_to_non_nullable
as int?,customEmojiName: freezed == customEmojiName ? _self.customEmojiName : customEmojiName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TabIcon implements TabIcon {
  const _TabIcon({this.codePoint, this.customEmojiName});
  factory _TabIcon.fromJson(Map<String, dynamic> json) => _$TabIconFromJson(json);

@override final  int? codePoint;
@override final  String? customEmojiName;

/// Create a copy of TabIcon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TabIconCopyWith<_TabIcon> get copyWith => __$TabIconCopyWithImpl<_TabIcon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TabIconToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TabIcon&&(identical(other.codePoint, codePoint) || other.codePoint == codePoint)&&(identical(other.customEmojiName, customEmojiName) || other.customEmojiName == customEmojiName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,codePoint,customEmojiName);

@override
String toString() {
  return 'TabIcon(codePoint: $codePoint, customEmojiName: $customEmojiName)';
}


}

/// @nodoc
abstract mixin class _$TabIconCopyWith<$Res> implements $TabIconCopyWith<$Res> {
  factory _$TabIconCopyWith(_TabIcon value, $Res Function(_TabIcon) _then) = __$TabIconCopyWithImpl;
@override @useResult
$Res call({
 int? codePoint, String? customEmojiName
});




}
/// @nodoc
class __$TabIconCopyWithImpl<$Res>
    implements _$TabIconCopyWith<$Res> {
  __$TabIconCopyWithImpl(this._self, this._then);

  final _TabIcon _self;
  final $Res Function(_TabIcon) _then;

/// Create a copy of TabIcon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? codePoint = freezed,Object? customEmojiName = freezed,}) {
  return _then(_TabIcon(
codePoint: freezed == codePoint ? _self.codePoint : codePoint // ignore: cast_nullable_to_non_nullable
as int?,customEmojiName: freezed == customEmojiName ? _self.customEmojiName : customEmojiName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
