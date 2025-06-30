// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_viewer_info_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImageViewerInfo {

 double get scale; double get lastScale; int get pointersCount; bool get isDoubleTap; Offset? get lastTapLocalPosition;
/// Create a copy of ImageViewerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageViewerInfoCopyWith<ImageViewerInfo> get copyWith => _$ImageViewerInfoCopyWithImpl<ImageViewerInfo>(this as ImageViewerInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageViewerInfo&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.lastScale, lastScale) || other.lastScale == lastScale)&&(identical(other.pointersCount, pointersCount) || other.pointersCount == pointersCount)&&(identical(other.isDoubleTap, isDoubleTap) || other.isDoubleTap == isDoubleTap)&&(identical(other.lastTapLocalPosition, lastTapLocalPosition) || other.lastTapLocalPosition == lastTapLocalPosition));
}


@override
int get hashCode => Object.hash(runtimeType,scale,lastScale,pointersCount,isDoubleTap,lastTapLocalPosition);

@override
String toString() {
  return 'ImageViewerInfo(scale: $scale, lastScale: $lastScale, pointersCount: $pointersCount, isDoubleTap: $isDoubleTap, lastTapLocalPosition: $lastTapLocalPosition)';
}


}

/// @nodoc
abstract mixin class $ImageViewerInfoCopyWith<$Res>  {
  factory $ImageViewerInfoCopyWith(ImageViewerInfo value, $Res Function(ImageViewerInfo) _then) = _$ImageViewerInfoCopyWithImpl;
@useResult
$Res call({
 double scale, double lastScale, int pointersCount, bool isDoubleTap, Offset? lastTapLocalPosition
});




}
/// @nodoc
class _$ImageViewerInfoCopyWithImpl<$Res>
    implements $ImageViewerInfoCopyWith<$Res> {
  _$ImageViewerInfoCopyWithImpl(this._self, this._then);

  final ImageViewerInfo _self;
  final $Res Function(ImageViewerInfo) _then;

/// Create a copy of ImageViewerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scale = null,Object? lastScale = null,Object? pointersCount = null,Object? isDoubleTap = null,Object? lastTapLocalPosition = freezed,}) {
  return _then(_self.copyWith(
scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as double,lastScale: null == lastScale ? _self.lastScale : lastScale // ignore: cast_nullable_to_non_nullable
as double,pointersCount: null == pointersCount ? _self.pointersCount : pointersCount // ignore: cast_nullable_to_non_nullable
as int,isDoubleTap: null == isDoubleTap ? _self.isDoubleTap : isDoubleTap // ignore: cast_nullable_to_non_nullable
as bool,lastTapLocalPosition: freezed == lastTapLocalPosition ? _self.lastTapLocalPosition : lastTapLocalPosition // ignore: cast_nullable_to_non_nullable
as Offset?,
  ));
}

}


/// @nodoc


class _ImageViewerInfo implements ImageViewerInfo {
  const _ImageViewerInfo({this.scale = 1.0, this.lastScale = 1.0, this.pointersCount = 0, this.isDoubleTap = false, this.lastTapLocalPosition = null});
  

@override@JsonKey() final  double scale;
@override@JsonKey() final  double lastScale;
@override@JsonKey() final  int pointersCount;
@override@JsonKey() final  bool isDoubleTap;
@override@JsonKey() final  Offset? lastTapLocalPosition;

/// Create a copy of ImageViewerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageViewerInfoCopyWith<_ImageViewerInfo> get copyWith => __$ImageViewerInfoCopyWithImpl<_ImageViewerInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageViewerInfo&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.lastScale, lastScale) || other.lastScale == lastScale)&&(identical(other.pointersCount, pointersCount) || other.pointersCount == pointersCount)&&(identical(other.isDoubleTap, isDoubleTap) || other.isDoubleTap == isDoubleTap)&&(identical(other.lastTapLocalPosition, lastTapLocalPosition) || other.lastTapLocalPosition == lastTapLocalPosition));
}


@override
int get hashCode => Object.hash(runtimeType,scale,lastScale,pointersCount,isDoubleTap,lastTapLocalPosition);

@override
String toString() {
  return 'ImageViewerInfo(scale: $scale, lastScale: $lastScale, pointersCount: $pointersCount, isDoubleTap: $isDoubleTap, lastTapLocalPosition: $lastTapLocalPosition)';
}


}

/// @nodoc
abstract mixin class _$ImageViewerInfoCopyWith<$Res> implements $ImageViewerInfoCopyWith<$Res> {
  factory _$ImageViewerInfoCopyWith(_ImageViewerInfo value, $Res Function(_ImageViewerInfo) _then) = __$ImageViewerInfoCopyWithImpl;
@override @useResult
$Res call({
 double scale, double lastScale, int pointersCount, bool isDoubleTap, Offset? lastTapLocalPosition
});




}
/// @nodoc
class __$ImageViewerInfoCopyWithImpl<$Res>
    implements _$ImageViewerInfoCopyWith<$Res> {
  __$ImageViewerInfoCopyWithImpl(this._self, this._then);

  final _ImageViewerInfo _self;
  final $Res Function(_ImageViewerInfo) _then;

/// Create a copy of ImageViewerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scale = null,Object? lastScale = null,Object? pointersCount = null,Object? isDoubleTap = null,Object? lastTapLocalPosition = freezed,}) {
  return _then(_ImageViewerInfo(
scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as double,lastScale: null == lastScale ? _self.lastScale : lastScale // ignore: cast_nullable_to_non_nullable
as double,pointersCount: null == pointersCount ? _self.pointersCount : pointersCount // ignore: cast_nullable_to_non_nullable
as int,isDoubleTap: null == isDoubleTap ? _self.isDoubleTap : isDoubleTap // ignore: cast_nullable_to_non_nullable
as bool,lastTapLocalPosition: freezed == lastTapLocalPosition ? _self.lastTapLocalPosition : lastTapLocalPosition // ignore: cast_nullable_to_non_nullable
as Offset?,
  ));
}


}

// dart format on
