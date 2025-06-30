// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exported_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExportedSetting {
  GeneralSettings get generalSettings;
  List<AccountSettings> get accountSettings;
  List<TabSetting> get tabSettings;

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExportedSettingCopyWith<ExportedSetting> get copyWith =>
      _$ExportedSettingCopyWithImpl<ExportedSetting>(
          this as ExportedSetting, _$identity);

  /// Serializes this ExportedSetting to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExportedSetting &&
            (identical(other.generalSettings, generalSettings) ||
                other.generalSettings == generalSettings) &&
            const DeepCollectionEquality()
                .equals(other.accountSettings, accountSettings) &&
            const DeepCollectionEquality()
                .equals(other.tabSettings, tabSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      generalSettings,
      const DeepCollectionEquality().hash(accountSettings),
      const DeepCollectionEquality().hash(tabSettings));

  @override
  String toString() {
    return 'ExportedSetting(generalSettings: $generalSettings, accountSettings: $accountSettings, tabSettings: $tabSettings)';
  }
}

/// @nodoc
abstract mixin class $ExportedSettingCopyWith<$Res> {
  factory $ExportedSettingCopyWith(
          ExportedSetting value, $Res Function(ExportedSetting) _then) =
      _$ExportedSettingCopyWithImpl;
  @useResult
  $Res call(
      {GeneralSettings generalSettings,
      List<AccountSettings> accountSettings,
      List<TabSetting> tabSettings});

  $GeneralSettingsCopyWith<$Res> get generalSettings;
}

/// @nodoc
class _$ExportedSettingCopyWithImpl<$Res>
    implements $ExportedSettingCopyWith<$Res> {
  _$ExportedSettingCopyWithImpl(this._self, this._then);

  final ExportedSetting _self;
  final $Res Function(ExportedSetting) _then;

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generalSettings = null,
    Object? accountSettings = null,
    Object? tabSettings = null,
  }) {
    return _then(_self.copyWith(
      generalSettings: null == generalSettings
          ? _self.generalSettings
          : generalSettings // ignore: cast_nullable_to_non_nullable
              as GeneralSettings,
      accountSettings: null == accountSettings
          ? _self.accountSettings
          : accountSettings // ignore: cast_nullable_to_non_nullable
              as List<AccountSettings>,
      tabSettings: null == tabSettings
          ? _self.tabSettings
          : tabSettings // ignore: cast_nullable_to_non_nullable
              as List<TabSetting>,
    ));
  }

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeneralSettingsCopyWith<$Res> get generalSettings {
    return $GeneralSettingsCopyWith<$Res>(_self.generalSettings, (value) {
      return _then(_self.copyWith(generalSettings: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _ExportedSetting implements ExportedSetting {
  const _ExportedSetting(
      {required this.generalSettings,
      final List<AccountSettings> accountSettings = const [],
      final List<TabSetting> tabSettings = const []})
      : _accountSettings = accountSettings,
        _tabSettings = tabSettings;
  factory _ExportedSetting.fromJson(Map<String, dynamic> json) =>
      _$ExportedSettingFromJson(json);

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

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExportedSettingCopyWith<_ExportedSetting> get copyWith =>
      __$ExportedSettingCopyWithImpl<_ExportedSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExportedSettingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExportedSetting &&
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

  @override
  String toString() {
    return 'ExportedSetting(generalSettings: $generalSettings, accountSettings: $accountSettings, tabSettings: $tabSettings)';
  }
}

/// @nodoc
abstract mixin class _$ExportedSettingCopyWith<$Res>
    implements $ExportedSettingCopyWith<$Res> {
  factory _$ExportedSettingCopyWith(
          _ExportedSetting value, $Res Function(_ExportedSetting) _then) =
      __$ExportedSettingCopyWithImpl;
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
class __$ExportedSettingCopyWithImpl<$Res>
    implements _$ExportedSettingCopyWith<$Res> {
  __$ExportedSettingCopyWithImpl(this._self, this._then);

  final _ExportedSetting _self;
  final $Res Function(_ExportedSetting) _then;

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? generalSettings = null,
    Object? accountSettings = null,
    Object? tabSettings = null,
  }) {
    return _then(_ExportedSetting(
      generalSettings: null == generalSettings
          ? _self.generalSettings
          : generalSettings // ignore: cast_nullable_to_non_nullable
              as GeneralSettings,
      accountSettings: null == accountSettings
          ? _self._accountSettings
          : accountSettings // ignore: cast_nullable_to_non_nullable
              as List<AccountSettings>,
      tabSettings: null == tabSettings
          ? _self._tabSettings
          : tabSettings // ignore: cast_nullable_to_non_nullable
              as List<TabSetting>,
    ));
  }

  /// Create a copy of ExportedSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeneralSettingsCopyWith<$Res> get generalSettings {
    return $GeneralSettingsCopyWith<$Res>(_self.generalSettings, (value) {
      return _then(_self.copyWith(generalSettings: value));
    });
  }
}

// dart format on
