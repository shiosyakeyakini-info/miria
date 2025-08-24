// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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


/// Adds pattern-matching-related methods to [TabIcon].
extension TabIconPatterns on TabIcon {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TabIcon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TabIcon() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TabIcon value)  $default,){
final _that = this;
switch (_that) {
case _TabIcon():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TabIcon value)?  $default,){
final _that = this;
switch (_that) {
case _TabIcon() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? codePoint,  String? customEmojiName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TabIcon() when $default != null:
return $default(_that.codePoint,_that.customEmojiName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? codePoint,  String? customEmojiName)  $default,) {final _that = this;
switch (_that) {
case _TabIcon():
return $default(_that.codePoint,_that.customEmojiName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? codePoint,  String? customEmojiName)?  $default,) {final _that = this;
switch (_that) {
case _TabIcon() when $default != null:
return $default(_that.codePoint,_that.customEmojiName);case _:
  return null;

}
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
