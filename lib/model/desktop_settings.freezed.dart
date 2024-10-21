// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'desktop_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DesktopSettings _$DesktopSettingsFromJson(Map<String, dynamic> json) {
  return _DesktopSettings.fromJson(json);
}

/// @nodoc
mixin _$DesktopSettings {
  DesktopWindowSettings get window => throw _privateConstructorUsedError;

  /// Serializes this DesktopSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DesktopSettingsCopyWith<DesktopSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesktopSettingsCopyWith<$Res> {
  factory $DesktopSettingsCopyWith(
          DesktopSettings value, $Res Function(DesktopSettings) then) =
      _$DesktopSettingsCopyWithImpl<$Res, DesktopSettings>;
  @useResult
  $Res call({DesktopWindowSettings window});

  $DesktopWindowSettingsCopyWith<$Res> get window;
}

/// @nodoc
class _$DesktopSettingsCopyWithImpl<$Res, $Val extends DesktopSettings>
    implements $DesktopSettingsCopyWith<$Res> {
  _$DesktopSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? window = null,
  }) {
    return _then(_value.copyWith(
      window: null == window
          ? _value.window
          : window // ignore: cast_nullable_to_non_nullable
              as DesktopWindowSettings,
    ) as $Val);
  }

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DesktopWindowSettingsCopyWith<$Res> get window {
    return $DesktopWindowSettingsCopyWith<$Res>(_value.window, (value) {
      return _then(_value.copyWith(window: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DesktopSettingsImplCopyWith<$Res>
    implements $DesktopSettingsCopyWith<$Res> {
  factory _$$DesktopSettingsImplCopyWith(_$DesktopSettingsImpl value,
          $Res Function(_$DesktopSettingsImpl) then) =
      __$$DesktopSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DesktopWindowSettings window});

  @override
  $DesktopWindowSettingsCopyWith<$Res> get window;
}

/// @nodoc
class __$$DesktopSettingsImplCopyWithImpl<$Res>
    extends _$DesktopSettingsCopyWithImpl<$Res, _$DesktopSettingsImpl>
    implements _$$DesktopSettingsImplCopyWith<$Res> {
  __$$DesktopSettingsImplCopyWithImpl(
      _$DesktopSettingsImpl _value, $Res Function(_$DesktopSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? window = null,
  }) {
    return _then(_$DesktopSettingsImpl(
      window: null == window
          ? _value.window
          : window // ignore: cast_nullable_to_non_nullable
              as DesktopWindowSettings,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DesktopSettingsImpl implements _DesktopSettings {
  const _$DesktopSettingsImpl({this.window = const DesktopWindowSettings()});

  factory _$DesktopSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DesktopSettingsImplFromJson(json);

  @override
  @JsonKey()
  final DesktopWindowSettings window;

  @override
  String toString() {
    return 'DesktopSettings(window: $window)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DesktopSettingsImpl &&
            (identical(other.window, window) || other.window == window));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, window);

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DesktopSettingsImplCopyWith<_$DesktopSettingsImpl> get copyWith =>
      __$$DesktopSettingsImplCopyWithImpl<_$DesktopSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DesktopSettingsImplToJson(
      this,
    );
  }
}

abstract class _DesktopSettings implements DesktopSettings {
  const factory _DesktopSettings({final DesktopWindowSettings window}) =
      _$DesktopSettingsImpl;

  factory _DesktopSettings.fromJson(Map<String, dynamic> json) =
      _$DesktopSettingsImpl.fromJson;

  @override
  DesktopWindowSettings get window;

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DesktopSettingsImplCopyWith<_$DesktopSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DesktopWindowSettings _$DesktopWindowSettingsFromJson(
    Map<String, dynamic> json) {
  return _DesktopWindowSettings.fromJson(json);
}

/// @nodoc
mixin _$DesktopWindowSettings {
  double? get x => throw _privateConstructorUsedError;
  double? get y => throw _privateConstructorUsedError;
  double get w => throw _privateConstructorUsedError;
  double get h => throw _privateConstructorUsedError;

  /// Serializes this DesktopWindowSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DesktopWindowSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DesktopWindowSettingsCopyWith<DesktopWindowSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesktopWindowSettingsCopyWith<$Res> {
  factory $DesktopWindowSettingsCopyWith(DesktopWindowSettings value,
          $Res Function(DesktopWindowSettings) then) =
      _$DesktopWindowSettingsCopyWithImpl<$Res, DesktopWindowSettings>;
  @useResult
  $Res call({double? x, double? y, double w, double h});
}

/// @nodoc
class _$DesktopWindowSettingsCopyWithImpl<$Res,
        $Val extends DesktopWindowSettings>
    implements $DesktopWindowSettingsCopyWith<$Res> {
  _$DesktopWindowSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DesktopWindowSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = freezed,
    Object? y = freezed,
    Object? w = null,
    Object? h = null,
  }) {
    return _then(_value.copyWith(
      x: freezed == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double?,
      y: freezed == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double?,
      w: null == w
          ? _value.w
          : w // ignore: cast_nullable_to_non_nullable
              as double,
      h: null == h
          ? _value.h
          : h // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DesktopWindowSettingsImplCopyWith<$Res>
    implements $DesktopWindowSettingsCopyWith<$Res> {
  factory _$$DesktopWindowSettingsImplCopyWith(
          _$DesktopWindowSettingsImpl value,
          $Res Function(_$DesktopWindowSettingsImpl) then) =
      __$$DesktopWindowSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? x, double? y, double w, double h});
}

/// @nodoc
class __$$DesktopWindowSettingsImplCopyWithImpl<$Res>
    extends _$DesktopWindowSettingsCopyWithImpl<$Res,
        _$DesktopWindowSettingsImpl>
    implements _$$DesktopWindowSettingsImplCopyWith<$Res> {
  __$$DesktopWindowSettingsImplCopyWithImpl(_$DesktopWindowSettingsImpl _value,
      $Res Function(_$DesktopWindowSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DesktopWindowSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = freezed,
    Object? y = freezed,
    Object? w = null,
    Object? h = null,
  }) {
    return _then(_$DesktopWindowSettingsImpl(
      x: freezed == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double?,
      y: freezed == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double?,
      w: null == w
          ? _value.w
          : w // ignore: cast_nullable_to_non_nullable
              as double,
      h: null == h
          ? _value.h
          : h // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DesktopWindowSettingsImpl implements _DesktopWindowSettings {
  const _$DesktopWindowSettingsImpl(
      {this.x = null, this.y = null, this.w = 400, this.h = 700});

  factory _$DesktopWindowSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DesktopWindowSettingsImplFromJson(json);

  @override
  @JsonKey()
  final double? x;
  @override
  @JsonKey()
  final double? y;
  @override
  @JsonKey()
  final double w;
  @override
  @JsonKey()
  final double h;

  @override
  String toString() {
    return 'DesktopWindowSettings(x: $x, y: $y, w: $w, h: $h)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DesktopWindowSettingsImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.w, w) || other.w == w) &&
            (identical(other.h, h) || other.h == h));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, w, h);

  /// Create a copy of DesktopWindowSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DesktopWindowSettingsImplCopyWith<_$DesktopWindowSettingsImpl>
      get copyWith => __$$DesktopWindowSettingsImplCopyWithImpl<
          _$DesktopWindowSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DesktopWindowSettingsImplToJson(
      this,
    );
  }
}

abstract class _DesktopWindowSettings implements DesktopWindowSettings {
  const factory _DesktopWindowSettings(
      {final double? x,
      final double? y,
      final double w,
      final double h}) = _$DesktopWindowSettingsImpl;

  factory _DesktopWindowSettings.fromJson(Map<String, dynamic> json) =
      _$DesktopWindowSettingsImpl.fromJson;

  @override
  double? get x;
  @override
  double? get y;
  @override
  double get w;
  @override
  double get h;

  /// Create a copy of DesktopWindowSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DesktopWindowSettingsImplCopyWith<_$DesktopWindowSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
