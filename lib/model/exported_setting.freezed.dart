// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exported_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExportedSetting _$ExportedSettingFromJson(Map<String, dynamic> json) {
  return _ExportedSetting.fromJson(json);
}

/// @nodoc
mixin _$ExportedSetting {
  GeneralSettings get generalSettings => throw _privateConstructorUsedError;
  List<AccountSettings> get accountSettings =>
      throw _privateConstructorUsedError;
  List<TabSetting> get tabSettings => throw _privateConstructorUsedError;

  /// Serializes this ExportedSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportedSettingCopyWith<ExportedSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportedSettingCopyWith<$Res> {
  factory $ExportedSettingCopyWith(
          ExportedSetting value, $Res Function(ExportedSetting) then) =
      _$ExportedSettingCopyWithImpl<$Res, ExportedSetting>;
  @useResult
  $Res call(
      {GeneralSettings generalSettings,
      List<AccountSettings> accountSettings,
      List<TabSetting> tabSettings});

  $GeneralSettingsCopyWith<$Res> get generalSettings;
}

/// @nodoc
class _$ExportedSettingCopyWithImpl<$Res, $Val extends ExportedSetting>
    implements $ExportedSettingCopyWith<$Res> {
  _$ExportedSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generalSettings = null,
    Object? accountSettings = null,
    Object? tabSettings = null,
  }) {
    return _then(_value.copyWith(
      generalSettings: null == generalSettings
          ? _value.generalSettings
          : generalSettings // ignore: cast_nullable_to_non_nullable
              as GeneralSettings,
      accountSettings: null == accountSettings
          ? _value.accountSettings
          : accountSettings // ignore: cast_nullable_to_non_nullable
              as List<AccountSettings>,
      tabSettings: null == tabSettings
          ? _value.tabSettings
          : tabSettings // ignore: cast_nullable_to_non_nullable
              as List<TabSetting>,
    ) as $Val);
  }

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeneralSettingsCopyWith<$Res> get generalSettings {
    return $GeneralSettingsCopyWith<$Res>(_value.generalSettings, (value) {
      return _then(_value.copyWith(generalSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExportedSettingImplCopyWith<$Res>
    implements $ExportedSettingCopyWith<$Res> {
  factory _$$ExportedSettingImplCopyWith(_$ExportedSettingImpl value,
          $Res Function(_$ExportedSettingImpl) then) =
      __$$ExportedSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GeneralSettings generalSettings,
      List<AccountSettings> accountSettings,
      List<TabSetting> tabSettings});

  @override
  $GeneralSettingsCopyWith<$Res> get generalSettings;
}

/// @nodoc
class __$$ExportedSettingImplCopyWithImpl<$Res>
    extends _$ExportedSettingCopyWithImpl<$Res, _$ExportedSettingImpl>
    implements _$$ExportedSettingImplCopyWith<$Res> {
  __$$ExportedSettingImplCopyWithImpl(
      _$ExportedSettingImpl _value, $Res Function(_$ExportedSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generalSettings = null,
    Object? accountSettings = null,
    Object? tabSettings = null,
  }) {
    return _then(_$ExportedSettingImpl(
      generalSettings: null == generalSettings
          ? _value.generalSettings
          : generalSettings // ignore: cast_nullable_to_non_nullable
              as GeneralSettings,
      accountSettings: null == accountSettings
          ? _value._accountSettings
          : accountSettings // ignore: cast_nullable_to_non_nullable
              as List<AccountSettings>,
      tabSettings: null == tabSettings
          ? _value._tabSettings
          : tabSettings // ignore: cast_nullable_to_non_nullable
              as List<TabSetting>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExportedSettingImpl implements _ExportedSetting {
  const _$ExportedSettingImpl(
      {required this.generalSettings,
      final List<AccountSettings> accountSettings = const [],
      final List<TabSetting> tabSettings = const []})
      : _accountSettings = accountSettings,
        _tabSettings = tabSettings;

  factory _$ExportedSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExportedSettingImplFromJson(json);

  @override
  final GeneralSettings generalSettings;
  final List<AccountSettings> _accountSettings;
  @override
  @JsonKey()
  List<AccountSettings> get accountSettings {
    if (_accountSettings is EqualUnmodifiableListView) return _accountSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accountSettings);
  }

  final List<TabSetting> _tabSettings;
  @override
  @JsonKey()
  List<TabSetting> get tabSettings {
    if (_tabSettings is EqualUnmodifiableListView) return _tabSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tabSettings);
  }

  @override
  String toString() {
    return 'ExportedSetting(generalSettings: $generalSettings, accountSettings: $accountSettings, tabSettings: $tabSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportedSettingImpl &&
            (identical(other.generalSettings, generalSettings) ||
                other.generalSettings == generalSettings) &&
            const DeepCollectionEquality()
                .equals(other._accountSettings, _accountSettings) &&
            const DeepCollectionEquality()
                .equals(other._tabSettings, _tabSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      generalSettings,
      const DeepCollectionEquality().hash(_accountSettings),
      const DeepCollectionEquality().hash(_tabSettings));

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportedSettingImplCopyWith<_$ExportedSettingImpl> get copyWith =>
      __$$ExportedSettingImplCopyWithImpl<_$ExportedSettingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExportedSettingImplToJson(
      this,
    );
  }
}

abstract class _ExportedSetting implements ExportedSetting {
  const factory _ExportedSetting(
      {required final GeneralSettings generalSettings,
      final List<AccountSettings> accountSettings,
      final List<TabSetting> tabSettings}) = _$ExportedSettingImpl;

  factory _ExportedSetting.fromJson(Map<String, dynamic> json) =
      _$ExportedSettingImpl.fromJson;

  @override
  GeneralSettings get generalSettings;
  @override
  List<AccountSettings> get accountSettings;
  @override
  List<TabSetting> get tabSettings;

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportedSettingImplCopyWith<_$ExportedSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
