// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_meta_dialog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImageMeta {
  String get fileName => throw _privateConstructorUsedError;
  bool get isNsfw => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageMetaCopyWith<ImageMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageMetaCopyWith<$Res> {
  factory $ImageMetaCopyWith(ImageMeta value, $Res Function(ImageMeta) then) =
      _$ImageMetaCopyWithImpl<$Res, ImageMeta>;
  @useResult
  $Res call({String fileName, bool isNsfw, String caption});
}

/// @nodoc
class _$ImageMetaCopyWithImpl<$Res, $Val extends ImageMeta>
    implements $ImageMetaCopyWith<$Res> {
  _$ImageMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? isNsfw = null,
    Object? caption = null,
  }) {
    return _then(_value.copyWith(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      isNsfw: null == isNsfw
          ? _value.isNsfw
          : isNsfw // ignore: cast_nullable_to_non_nullable
              as bool,
      caption: null == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageMetaImplCopyWith<$Res>
    implements $ImageMetaCopyWith<$Res> {
  factory _$$ImageMetaImplCopyWith(
          _$ImageMetaImpl value, $Res Function(_$ImageMetaImpl) then) =
      __$$ImageMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fileName, bool isNsfw, String caption});
}

/// @nodoc
class __$$ImageMetaImplCopyWithImpl<$Res>
    extends _$ImageMetaCopyWithImpl<$Res, _$ImageMetaImpl>
    implements _$$ImageMetaImplCopyWith<$Res> {
  __$$ImageMetaImplCopyWithImpl(
      _$ImageMetaImpl _value, $Res Function(_$ImageMetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? isNsfw = null,
    Object? caption = null,
  }) {
    return _then(_$ImageMetaImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      isNsfw: null == isNsfw
          ? _value.isNsfw
          : isNsfw // ignore: cast_nullable_to_non_nullable
              as bool,
      caption: null == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ImageMetaImpl implements _ImageMeta {
  const _$ImageMetaImpl(
      {required this.fileName, required this.isNsfw, required this.caption});

  @override
  final String fileName;
  @override
  final bool isNsfw;
  @override
  final String caption;

  @override
  String toString() {
    return 'ImageMeta(fileName: $fileName, isNsfw: $isNsfw, caption: $caption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageMetaImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.isNsfw, isNsfw) || other.isNsfw == isNsfw) &&
            (identical(other.caption, caption) || other.caption == caption));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileName, isNsfw, caption);

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageMetaImplCopyWith<_$ImageMetaImpl> get copyWith =>
      __$$ImageMetaImplCopyWithImpl<_$ImageMetaImpl>(this, _$identity);
}

abstract class _ImageMeta implements ImageMeta {
  const factory _ImageMeta(
      {required final String fileName,
      required final bool isNsfw,
      required final String caption}) = _$ImageMetaImpl;

  @override
  String get fileName;
  @override
  bool get isNsfw;
  @override
  String get caption;

  /// Create a copy of ImageMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageMetaImplCopyWith<_$ImageMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
