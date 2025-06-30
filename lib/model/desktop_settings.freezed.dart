// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'desktop_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DesktopSettings {
  DesktopWindowSettings get window;

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DesktopSettingsCopyWith<DesktopSettings> get copyWith =>
      _$DesktopSettingsCopyWithImpl<DesktopSettings>(
          this as DesktopSettings, _$identity);

  /// Serializes this DesktopSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DesktopSettings &&
            (identical(other.window, window) || other.window == window));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, window);

  @override
  String toString() {
    return 'DesktopSettings(window: $window)';
  }
}

/// @nodoc
abstract mixin class $DesktopSettingsCopyWith<$Res> {
  factory $DesktopSettingsCopyWith(
          DesktopSettings value, $Res Function(DesktopSettings) _then) =
      _$DesktopSettingsCopyWithImpl;
  @useResult
  $Res call({DesktopWindowSettings window});

  $DesktopWindowSettingsCopyWith<$Res> get window;
}

/// @nodoc
class _$DesktopSettingsCopyWithImpl<$Res>
    implements $DesktopSettingsCopyWith<$Res> {
  _$DesktopSettingsCopyWithImpl(this._self, this._then);

  final DesktopSettings _self;
  final $Res Function(DesktopSettings) _then;

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? window = null,
  }) {
    return _then(_self.copyWith(
      window: null == window
          ? _self.window
          : window // ignore: cast_nullable_to_non_nullable
              as DesktopWindowSettings,
    ));
  }

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DesktopWindowSettingsCopyWith<$Res> get window {
    return $DesktopWindowSettingsCopyWith<$Res>(_self.window, (value) {
      return _then(_self.copyWith(window: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _DesktopSettings implements DesktopSettings {
  const _DesktopSettings({this.window = const DesktopWindowSettings()});
  factory _DesktopSettings.fromJson(Map<String, dynamic> json) =>
      _$DesktopSettingsFromJson(json);

  @override
  @JsonKey()
  final DesktopWindowSettings window;

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DesktopSettingsCopyWith<_DesktopSettings> get copyWith =>
      __$DesktopSettingsCopyWithImpl<_DesktopSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DesktopSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DesktopSettings &&
            (identical(other.window, window) || other.window == window));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, window);

  @override
  String toString() {
    return 'DesktopSettings(window: $window)';
  }
}

/// @nodoc
abstract mixin class _$DesktopSettingsCopyWith<$Res>
    implements $DesktopSettingsCopyWith<$Res> {
  factory _$DesktopSettingsCopyWith(
          _DesktopSettings value, $Res Function(_DesktopSettings) _then) =
      __$DesktopSettingsCopyWithImpl;
  @override
  @useResult
  $Res call({DesktopWindowSettings window});

  @override
  $DesktopWindowSettingsCopyWith<$Res> get window;
}

/// @nodoc
class __$DesktopSettingsCopyWithImpl<$Res>
    implements _$DesktopSettingsCopyWith<$Res> {
  __$DesktopSettingsCopyWithImpl(this._self, this._then);

  final _DesktopSettings _self;
  final $Res Function(_DesktopSettings) _then;

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? window = null,
  }) {
    return _then(_DesktopSettings(
      window: null == window
          ? _self.window
          : window // ignore: cast_nullable_to_non_nullable
              as DesktopWindowSettings,
    ));
  }

  /// Create a copy of DesktopSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DesktopWindowSettingsCopyWith<$Res> get window {
    return $DesktopWindowSettingsCopyWith<$Res>(_self.window, (value) {
      return _then(_self.copyWith(window: value));
    });
  }
}

/// @nodoc
mixin _$DesktopWindowSettings {
  double? get x;
  double? get y;
  double get w;
  double get h;

  /// Create a copy of DesktopWindowSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DesktopWindowSettingsCopyWith<DesktopWindowSettings> get copyWith =>
      _$DesktopWindowSettingsCopyWithImpl<DesktopWindowSettings>(
          this as DesktopWindowSettings, _$identity);

  /// Serializes this DesktopWindowSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DesktopWindowSettings &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.w, w) || other.w == w) &&
            (identical(other.h, h) || other.h == h));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, w, h);

  @override
  String toString() {
    return 'DesktopWindowSettings(x: $x, y: $y, w: $w, h: $h)';
  }
}

/// @nodoc
abstract mixin class $DesktopWindowSettingsCopyWith<$Res> {
  factory $DesktopWindowSettingsCopyWith(DesktopWindowSettings value,
          $Res Function(DesktopWindowSettings) _then) =
      _$DesktopWindowSettingsCopyWithImpl;
  @useResult
  $Res call({double? x, double? y, double w, double h});
}

/// @nodoc
class _$DesktopWindowSettingsCopyWithImpl<$Res>
    implements $DesktopWindowSettingsCopyWith<$Res> {
  _$DesktopWindowSettingsCopyWithImpl(this._self, this._then);

  final DesktopWindowSettings _self;
  final $Res Function(DesktopWindowSettings) _then;

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
    return _then(_self.copyWith(
      x: freezed == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double?,
      y: freezed == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double?,
      w: null == w
          ? _self.w
          : w // ignore: cast_nullable_to_non_nullable
              as double,
      h: null == h
          ? _self.h
          : h // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _DesktopWindowSettings implements DesktopWindowSettings {
  const _DesktopWindowSettings(
      {this.x = null, this.y = null, this.w = 400, this.h = 700});
  factory _DesktopWindowSettings.fromJson(Map<String, dynamic> json) =>
      _$DesktopWindowSettingsFromJson(json);

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

  /// Create a copy of DesktopWindowSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DesktopWindowSettingsCopyWith<_DesktopWindowSettings> get copyWith =>
      __$DesktopWindowSettingsCopyWithImpl<_DesktopWindowSettings>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DesktopWindowSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DesktopWindowSettings &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.w, w) || other.w == w) &&
            (identical(other.h, h) || other.h == h));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, w, h);

  @override
  String toString() {
    return 'DesktopWindowSettings(x: $x, y: $y, w: $w, h: $h)';
  }
}

/// @nodoc
abstract mixin class _$DesktopWindowSettingsCopyWith<$Res>
    implements $DesktopWindowSettingsCopyWith<$Res> {
  factory _$DesktopWindowSettingsCopyWith(_DesktopWindowSettings value,
          $Res Function(_DesktopWindowSettings) _then) =
      __$DesktopWindowSettingsCopyWithImpl;
  @override
  @useResult
  $Res call({double? x, double? y, double w, double h});
}

/// @nodoc
class __$DesktopWindowSettingsCopyWithImpl<$Res>
    implements _$DesktopWindowSettingsCopyWith<$Res> {
  __$DesktopWindowSettingsCopyWithImpl(this._self, this._then);

  final _DesktopWindowSettings _self;
  final $Res Function(_DesktopWindowSettings) _then;

  /// Create a copy of DesktopWindowSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? x = freezed,
    Object? y = freezed,
    Object? w = null,
    Object? h = null,
  }) {
    return _then(_DesktopWindowSettings(
      x: freezed == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double?,
      y: freezed == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double?,
      w: null == w
          ? _self.w
          : w // ignore: cast_nullable_to_non_nullable
              as double,
      h: null == h
          ? _self.h
          : h // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
