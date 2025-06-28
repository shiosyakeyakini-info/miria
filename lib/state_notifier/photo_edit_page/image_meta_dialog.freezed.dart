// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_meta_dialog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImageMeta {

 String get fileName; bool get isNsfw; String get caption;
/// Create a copy of ImageMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageMetaCopyWith<ImageMeta> get copyWith => _$ImageMetaCopyWithImpl<ImageMeta>(this as ImageMeta, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageMeta&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.isNsfw, isNsfw) || other.isNsfw == isNsfw)&&(identical(other.caption, caption) || other.caption == caption));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,isNsfw,caption);

@override
String toString() {
  return 'ImageMeta(fileName: $fileName, isNsfw: $isNsfw, caption: $caption)';
}


}

/// @nodoc
abstract mixin class $ImageMetaCopyWith<$Res>  {
  factory $ImageMetaCopyWith(ImageMeta value, $Res Function(ImageMeta) _then) = _$ImageMetaCopyWithImpl;
@useResult
$Res call({
 String fileName, bool isNsfw, String caption
});




}
/// @nodoc
class _$ImageMetaCopyWithImpl<$Res>
    implements $ImageMetaCopyWith<$Res> {
  _$ImageMetaCopyWithImpl(this._self, this._then);

  final ImageMeta _self;
  final $Res Function(ImageMeta) _then;

/// Create a copy of ImageMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? isNsfw = null,Object? caption = null,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,isNsfw: null == isNsfw ? _self.isNsfw : isNsfw // ignore: cast_nullable_to_non_nullable
as bool,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _ImageMeta implements ImageMeta {
  const _ImageMeta({required this.fileName, required this.isNsfw, required this.caption});
  

@override final  String fileName;
@override final  bool isNsfw;
@override final  String caption;

/// Create a copy of ImageMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageMetaCopyWith<_ImageMeta> get copyWith => __$ImageMetaCopyWithImpl<_ImageMeta>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageMeta&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.isNsfw, isNsfw) || other.isNsfw == isNsfw)&&(identical(other.caption, caption) || other.caption == caption));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,isNsfw,caption);

@override
String toString() {
  return 'ImageMeta(fileName: $fileName, isNsfw: $isNsfw, caption: $caption)';
}


}

/// @nodoc
abstract mixin class _$ImageMetaCopyWith<$Res> implements $ImageMetaCopyWith<$Res> {
  factory _$ImageMetaCopyWith(_ImageMeta value, $Res Function(_ImageMeta) _then) = __$ImageMetaCopyWithImpl;
@override @useResult
$Res call({
 String fileName, bool isNsfw, String caption
});




}
/// @nodoc
class __$ImageMetaCopyWithImpl<$Res>
    implements _$ImageMetaCopyWith<$Res> {
  __$ImageMetaCopyWithImpl(this._self, this._then);

  final _ImageMeta _self;
  final $Res Function(_ImageMeta) _then;

/// Create a copy of ImageMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? isNsfw = null,Object? caption = null,}) {
  return _then(_ImageMeta(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,isNsfw: null == isNsfw ? _self.isNsfw : isNsfw // ignore: cast_nullable_to_non_nullable
as bool,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
