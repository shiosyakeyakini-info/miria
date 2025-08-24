// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisskeyTheme {

 String get id; String get name; Map<String, String> get props; String? get author; String? get desc; String? get base;
/// Create a copy of MisskeyTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyThemeCopyWith<MisskeyTheme> get copyWith => _$MisskeyThemeCopyWithImpl<MisskeyTheme>(this as MisskeyTheme, _$identity);

  /// Serializes this MisskeyTheme to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyTheme&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.props, props)&&(identical(other.author, author) || other.author == author)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.base, base) || other.base == base));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(props),author,desc,base);

@override
String toString() {
  return 'MisskeyTheme(id: $id, name: $name, props: $props, author: $author, desc: $desc, base: $base)';
}


}

/// @nodoc
abstract mixin class $MisskeyThemeCopyWith<$Res>  {
  factory $MisskeyThemeCopyWith(MisskeyTheme value, $Res Function(MisskeyTheme) _then) = _$MisskeyThemeCopyWithImpl;
@useResult
$Res call({
 String id, String name, Map<String, String> props, String? author, String? desc, String? base
});




}
/// @nodoc
class _$MisskeyThemeCopyWithImpl<$Res>
    implements $MisskeyThemeCopyWith<$Res> {
  _$MisskeyThemeCopyWithImpl(this._self, this._then);

  final MisskeyTheme _self;
  final $Res Function(MisskeyTheme) _then;

/// Create a copy of MisskeyTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? props = null,Object? author = freezed,Object? desc = freezed,Object? base = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,props: null == props ? _self.props : props // ignore: cast_nullable_to_non_nullable
as Map<String, String>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String?,base: freezed == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MisskeyTheme].
extension MisskeyThemePatterns on MisskeyTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MisskeyTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MisskeyTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MisskeyTheme value)  $default,){
final _that = this;
switch (_that) {
case _MisskeyTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MisskeyTheme value)?  $default,){
final _that = this;
switch (_that) {
case _MisskeyTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Map<String, String> props,  String? author,  String? desc,  String? base)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MisskeyTheme() when $default != null:
return $default(_that.id,_that.name,_that.props,_that.author,_that.desc,_that.base);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Map<String, String> props,  String? author,  String? desc,  String? base)  $default,) {final _that = this;
switch (_that) {
case _MisskeyTheme():
return $default(_that.id,_that.name,_that.props,_that.author,_that.desc,_that.base);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Map<String, String> props,  String? author,  String? desc,  String? base)?  $default,) {final _that = this;
switch (_that) {
case _MisskeyTheme() when $default != null:
return $default(_that.id,_that.name,_that.props,_that.author,_that.desc,_that.base);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MisskeyTheme implements MisskeyTheme {
  const _MisskeyTheme({required this.id, required this.name, required final  Map<String, String> props, this.author, this.desc, this.base}): _props = props;
  factory _MisskeyTheme.fromJson(Map<String, dynamic> json) => _$MisskeyThemeFromJson(json);

@override final  String id;
@override final  String name;
 final  Map<String, String> _props;
@override Map<String, String> get props {
  if (_props is EqualUnmodifiableMapView) return _props;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_props);
}

@override final  String? author;
@override final  String? desc;
@override final  String? base;

/// Create a copy of MisskeyTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MisskeyThemeCopyWith<_MisskeyTheme> get copyWith => __$MisskeyThemeCopyWithImpl<_MisskeyTheme>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MisskeyThemeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MisskeyTheme&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._props, _props)&&(identical(other.author, author) || other.author == author)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.base, base) || other.base == base));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_props),author,desc,base);

@override
String toString() {
  return 'MisskeyTheme(id: $id, name: $name, props: $props, author: $author, desc: $desc, base: $base)';
}


}

/// @nodoc
abstract mixin class _$MisskeyThemeCopyWith<$Res> implements $MisskeyThemeCopyWith<$Res> {
  factory _$MisskeyThemeCopyWith(_MisskeyTheme value, $Res Function(_MisskeyTheme) _then) = __$MisskeyThemeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Map<String, String> props, String? author, String? desc, String? base
});




}
/// @nodoc
class __$MisskeyThemeCopyWithImpl<$Res>
    implements _$MisskeyThemeCopyWith<$Res> {
  __$MisskeyThemeCopyWithImpl(this._self, this._then);

  final _MisskeyTheme _self;
  final $Res Function(_MisskeyTheme) _then;

/// Create a copy of MisskeyTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? props = null,Object? author = freezed,Object? desc = freezed,Object? base = freezed,}) {
  return _then(_MisskeyTheme(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,props: null == props ? _self._props : props // ignore: cast_nullable_to_non_nullable
as Map<String, String>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String?,base: freezed == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
