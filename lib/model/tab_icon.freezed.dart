// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tab_icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TabIcon _$TabIconFromJson(Map<String, dynamic> json) {
  return _TabIcon.fromJson(json);
}

/// @nodoc
mixin _$TabIcon {
  int? get codePoint => throw _privateConstructorUsedError;
  String? get customEmojiName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TabIconCopyWith<TabIcon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TabIconCopyWith<$Res> {
  factory $TabIconCopyWith(TabIcon value, $Res Function(TabIcon) then) =
      _$TabIconCopyWithImpl<$Res, TabIcon>;
  @useResult
  $Res call({int? codePoint, String? customEmojiName});
}

/// @nodoc
class _$TabIconCopyWithImpl<$Res, $Val extends TabIcon>
    implements $TabIconCopyWith<$Res> {
  _$TabIconCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codePoint = freezed,
    Object? customEmojiName = freezed,
  }) {
    return _then(_value.copyWith(
      codePoint: freezed == codePoint
          ? _value.codePoint
          : codePoint // ignore: cast_nullable_to_non_nullable
              as int?,
      customEmojiName: freezed == customEmojiName
          ? _value.customEmojiName
          : customEmojiName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TabIconImplCopyWith<$Res> implements $TabIconCopyWith<$Res> {
  factory _$$TabIconImplCopyWith(
          _$TabIconImpl value, $Res Function(_$TabIconImpl) then) =
      __$$TabIconImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? codePoint, String? customEmojiName});
}

/// @nodoc
class __$$TabIconImplCopyWithImpl<$Res>
    extends _$TabIconCopyWithImpl<$Res, _$TabIconImpl>
    implements _$$TabIconImplCopyWith<$Res> {
  __$$TabIconImplCopyWithImpl(
      _$TabIconImpl _value, $Res Function(_$TabIconImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codePoint = freezed,
    Object? customEmojiName = freezed,
  }) {
    return _then(_$TabIconImpl(
      codePoint: freezed == codePoint
          ? _value.codePoint
          : codePoint // ignore: cast_nullable_to_non_nullable
              as int?,
      customEmojiName: freezed == customEmojiName
          ? _value.customEmojiName
          : customEmojiName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TabIconImpl implements _TabIcon {
  const _$TabIconImpl({this.codePoint, this.customEmojiName});

  factory _$TabIconImpl.fromJson(Map<String, dynamic> json) =>
      _$$TabIconImplFromJson(json);

  @override
  final int? codePoint;
  @override
  final String? customEmojiName;

  @override
  String toString() {
    return 'TabIcon(codePoint: $codePoint, customEmojiName: $customEmojiName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TabIconImpl &&
            (identical(other.codePoint, codePoint) ||
                other.codePoint == codePoint) &&
            (identical(other.customEmojiName, customEmojiName) ||
                other.customEmojiName == customEmojiName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, codePoint, customEmojiName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TabIconImplCopyWith<_$TabIconImpl> get copyWith =>
      __$$TabIconImplCopyWithImpl<_$TabIconImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TabIconImplToJson(
      this,
    );
  }
}

abstract class _TabIcon implements TabIcon {
  const factory _TabIcon(
      {final int? codePoint, final String? customEmojiName}) = _$TabIconImpl;

  factory _TabIcon.fromJson(Map<String, dynamic> json) = _$TabIconImpl.fromJson;

  @override
  int? get codePoint;
  @override
  String? get customEmojiName;
  @override
  @JsonKey(ignore: true)
  _$$TabIconImplCopyWith<_$TabIconImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
