// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_extension_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ShareExtensionData _$ShareExtensionDataFromJson(Map<String, dynamic> json) {
  return _ShareExtensionData.fromJson(json);
}

/// @nodoc
mixin _$ShareExtensionData {
  List<String> get text => throw _privateConstructorUsedError;
  List<SharedFiles> get files => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShareExtensionDataCopyWith<ShareExtensionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareExtensionDataCopyWith<$Res> {
  factory $ShareExtensionDataCopyWith(
          ShareExtensionData value, $Res Function(ShareExtensionData) then) =
      _$ShareExtensionDataCopyWithImpl<$Res, ShareExtensionData>;
  @useResult
  $Res call({List<String> text, List<SharedFiles> files});
}

/// @nodoc
class _$ShareExtensionDataCopyWithImpl<$Res, $Val extends ShareExtensionData>
    implements $ShareExtensionDataCopyWith<$Res> {
  _$ShareExtensionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? files = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as List<String>,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<SharedFiles>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShareExtensionDataImplCopyWith<$Res>
    implements $ShareExtensionDataCopyWith<$Res> {
  factory _$$ShareExtensionDataImplCopyWith(_$ShareExtensionDataImpl value,
          $Res Function(_$ShareExtensionDataImpl) then) =
      __$$ShareExtensionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> text, List<SharedFiles> files});
}

/// @nodoc
class __$$ShareExtensionDataImplCopyWithImpl<$Res>
    extends _$ShareExtensionDataCopyWithImpl<$Res, _$ShareExtensionDataImpl>
    implements _$$ShareExtensionDataImplCopyWith<$Res> {
  __$$ShareExtensionDataImplCopyWithImpl(_$ShareExtensionDataImpl _value,
      $Res Function(_$ShareExtensionDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? files = null,
  }) {
    return _then(_$ShareExtensionDataImpl(
      text: null == text
          ? _value._text
          : text // ignore: cast_nullable_to_non_nullable
              as List<String>,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<SharedFiles>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShareExtensionDataImpl implements _ShareExtensionData {
  _$ShareExtensionDataImpl(
      {required final List<String> text,
      required final List<SharedFiles> files})
      : _text = text,
        _files = files;

  factory _$ShareExtensionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareExtensionDataImplFromJson(json);

  final List<String> _text;
  @override
  List<String> get text {
    if (_text is EqualUnmodifiableListView) return _text;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_text);
  }

  final List<SharedFiles> _files;
  @override
  List<SharedFiles> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'ShareExtensionData(text: $text, files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareExtensionDataImpl &&
            const DeepCollectionEquality().equals(other._text, _text) &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_text),
      const DeepCollectionEquality().hash(_files));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareExtensionDataImplCopyWith<_$ShareExtensionDataImpl> get copyWith =>
      __$$ShareExtensionDataImplCopyWithImpl<_$ShareExtensionDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShareExtensionDataImplToJson(
      this,
    );
  }
}

abstract class _ShareExtensionData implements ShareExtensionData {
  factory _ShareExtensionData(
      {required final List<String> text,
      required final List<SharedFiles> files}) = _$ShareExtensionDataImpl;

  factory _ShareExtensionData.fromJson(Map<String, dynamic> json) =
      _$ShareExtensionDataImpl.fromJson;

  @override
  List<String> get text;
  @override
  List<SharedFiles> get files;
  @override
  @JsonKey(ignore: true)
  _$$ShareExtensionDataImplCopyWith<_$ShareExtensionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SharedFiles _$SharedFilesFromJson(Map<String, dynamic> json) {
  return _SharedFiles.fromJson(json);
}

/// @nodoc
mixin _$SharedFiles {
  String get path => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharedFilesCopyWith<SharedFiles> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedFilesCopyWith<$Res> {
  factory $SharedFilesCopyWith(
          SharedFiles value, $Res Function(SharedFiles) then) =
      _$SharedFilesCopyWithImpl<$Res, SharedFiles>;
  @useResult
  $Res call({String path, int type});
}

/// @nodoc
class _$SharedFilesCopyWithImpl<$Res, $Val extends SharedFiles>
    implements $SharedFilesCopyWith<$Res> {
  _$SharedFilesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedFilesImplCopyWith<$Res>
    implements $SharedFilesCopyWith<$Res> {
  factory _$$SharedFilesImplCopyWith(
          _$SharedFilesImpl value, $Res Function(_$SharedFilesImpl) then) =
      __$$SharedFilesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, int type});
}

/// @nodoc
class __$$SharedFilesImplCopyWithImpl<$Res>
    extends _$SharedFilesCopyWithImpl<$Res, _$SharedFilesImpl>
    implements _$$SharedFilesImplCopyWith<$Res> {
  __$$SharedFilesImplCopyWithImpl(
      _$SharedFilesImpl _value, $Res Function(_$SharedFilesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? type = null,
  }) {
    return _then(_$SharedFilesImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharedFilesImpl implements _SharedFiles {
  _$SharedFilesImpl({required this.path, required this.type});

  factory _$SharedFilesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharedFilesImplFromJson(json);

  @override
  final String path;
  @override
  final int type;

  @override
  String toString() {
    return 'SharedFiles(path: $path, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedFilesImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedFilesImplCopyWith<_$SharedFilesImpl> get copyWith =>
      __$$SharedFilesImplCopyWithImpl<_$SharedFilesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharedFilesImplToJson(
      this,
    );
  }
}

abstract class _SharedFiles implements SharedFiles {
  factory _SharedFiles({required final String path, required final int type}) =
      _$SharedFilesImpl;

  factory _SharedFiles.fromJson(Map<String, dynamic> json) =
      _$SharedFilesImpl.fromJson;

  @override
  String get path;
  @override
  int get type;
  @override
  @JsonKey(ignore: true)
  _$$SharedFilesImplCopyWith<_$SharedFilesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
