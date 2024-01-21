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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ExportedSetting _$ExportedSettingFromJson(Map<String, dynamic> json) {
  return _ExportedSetting.fromJson(json);
}

/// @nodoc
mixin _$ExportedSetting {
  List<AccountSettings> get accountSettings =>
      throw _privateConstructorUsedError;
  GeneralSettings get generalSettings => throw _privateConstructorUsedError;
  List<TabSetting> get tabSettings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      {List<AccountSettings> accountSettings,
      GeneralSettings generalSettings,
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountSettings = null,
    Object? generalSettings = null,
    Object? tabSettings = null,
  }) {
    return _then(_value.copyWith(
      accountSettings: null == accountSettings
          ? _value.accountSettings
          : accountSettings // ignore: cast_nullable_to_non_nullable
              as List<AccountSettings>,
      generalSettings: null == generalSettings
          ? _value.generalSettings
          : generalSettings // ignore: cast_nullable_to_non_nullable
              as GeneralSettings,
      tabSettings: null == tabSettings
          ? _value.tabSettings
          : tabSettings // ignore: cast_nullable_to_non_nullable
              as List<TabSetting>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GeneralSettingsCopyWith<$Res> get generalSettings {
    return $GeneralSettingsCopyWith<$Res>(_value.generalSettings, (value) {
      return _then(_value.copyWith(generalSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ExportedSettingCopyWith<$Res>
    implements $ExportedSettingCopyWith<$Res> {
  factory _$$_ExportedSettingCopyWith(
          _$_ExportedSetting value, $Res Function(_$_ExportedSetting) then) =
      __$$_ExportedSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AccountSettings> accountSettings,
      GeneralSettings generalSettings,
      List<TabSetting> tabSettings});

  @override
  $GeneralSettingsCopyWith<$Res> get generalSettings;
}

/// @nodoc
class __$$_ExportedSettingCopyWithImpl<$Res>
    extends _$ExportedSettingCopyWithImpl<$Res, _$_ExportedSetting>
    implements _$$_ExportedSettingCopyWith<$Res> {
  __$$_ExportedSettingCopyWithImpl(
      _$_ExportedSetting _value, $Res Function(_$_ExportedSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountSettings = null,
    Object? generalSettings = null,
    Object? tabSettings = null,
  }) {
    return _then(_$_ExportedSetting(
      accountSettings: null == accountSettings
          ? _value._accountSettings
          : accountSettings // ignore: cast_nullable_to_non_nullable
              as List<AccountSettings>,
      generalSettings: null == generalSettings
          ? _value.generalSettings
          : generalSettings // ignore: cast_nullable_to_non_nullable
              as GeneralSettings,
      tabSettings: null == tabSettings
          ? _value._tabSettings
          : tabSettings // ignore: cast_nullable_to_non_nullable
              as List<TabSetting>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ExportedSetting implements _ExportedSetting {
  const _$_ExportedSetting(
      {final List<AccountSettings> accountSettings = const [],
      required this.generalSettings,
      final List<TabSetting> tabSettings = const []})
      : _accountSettings = accountSettings,
        _tabSettings = tabSettings;

  factory _$_ExportedSetting.fromJson(Map<String, dynamic> json) =>
      _$$_ExportedSettingFromJson(json);

  final List<AccountSettings> _accountSettings;
  @override
  @JsonKey()
  List<AccountSettings> get accountSettings {
    if (_accountSettings is EqualUnmodifiableListView) return _accountSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accountSettings);
  }

  @override
  final GeneralSettings generalSettings;
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
    return 'ExportedSetting(accountSettings: $accountSettings, generalSettings: $generalSettings, tabSettings: $tabSettings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ExportedSetting &&
            const DeepCollectionEquality()
                .equals(other._accountSettings, _accountSettings) &&
            (identical(other.generalSettings, generalSettings) ||
                other.generalSettings == generalSettings) &&
            const DeepCollectionEquality()
                .equals(other._tabSettings, _tabSettings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_accountSettings),
      generalSettings,
      const DeepCollectionEquality().hash(_tabSettings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ExportedSettingCopyWith<_$_ExportedSetting> get copyWith =>
      __$$_ExportedSettingCopyWithImpl<_$_ExportedSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ExportedSettingToJson(
      this,
    );
  }
}

abstract class _ExportedSetting implements ExportedSetting {
  const factory _ExportedSetting(
      {final List<AccountSettings> accountSettings,
      required final GeneralSettings generalSettings,
      final List<TabSetting> tabSettings}) = _$_ExportedSetting;

  factory _ExportedSetting.fromJson(Map<String, dynamic> json) =
      _$_ExportedSetting.fromJson;

  @override
  List<AccountSettings> get accountSettings;
  @override
  GeneralSettings get generalSettings;
  @override
  List<TabSetting> get tabSettings;
  @override
  @JsonKey(ignore: true)
  _$$_ExportedSettingCopyWith<_$_ExportedSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
