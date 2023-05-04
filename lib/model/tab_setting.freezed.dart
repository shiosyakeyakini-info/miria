// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tab_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TabSetting _$TabSettingFromJson(Map<String, dynamic> json) {
  return _TabSetting.fromJson(json);
}

/// @nodoc
mixin _$TabSetting {
  @IconDataConverter()
  IconData get icon => throw _privateConstructorUsedError;
  TabType get tabType => throw _privateConstructorUsedError;
  String? get channelId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Account get account => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TabSettingCopyWith<TabSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TabSettingCopyWith<$Res> {
  factory $TabSettingCopyWith(
          TabSetting value, $Res Function(TabSetting) then) =
      _$TabSettingCopyWithImpl<$Res, TabSetting>;
  @useResult
  $Res call(
      {@IconDataConverter() IconData icon,
      TabType tabType,
      String? channelId,
      String name,
      Account account});

  $AccountCopyWith<$Res> get account;
}

/// @nodoc
class _$TabSettingCopyWithImpl<$Res, $Val extends TabSetting>
    implements $TabSettingCopyWith<$Res> {
  _$TabSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? tabType = null,
    Object? channelId = freezed,
    Object? name = null,
    Object? account = null,
  }) {
    return _then(_value.copyWith(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      tabType: null == tabType
          ? _value.tabType
          : tabType // ignore: cast_nullable_to_non_nullable
              as TabType,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AccountCopyWith<$Res> get account {
    return $AccountCopyWith<$Res>(_value.account, (value) {
      return _then(_value.copyWith(account: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TabSettingCopyWith<$Res>
    implements $TabSettingCopyWith<$Res> {
  factory _$$_TabSettingCopyWith(
          _$_TabSetting value, $Res Function(_$_TabSetting) then) =
      __$$_TabSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@IconDataConverter() IconData icon,
      TabType tabType,
      String? channelId,
      String name,
      Account account});

  @override
  $AccountCopyWith<$Res> get account;
}

/// @nodoc
class __$$_TabSettingCopyWithImpl<$Res>
    extends _$TabSettingCopyWithImpl<$Res, _$_TabSetting>
    implements _$$_TabSettingCopyWith<$Res> {
  __$$_TabSettingCopyWithImpl(
      _$_TabSetting _value, $Res Function(_$_TabSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? tabType = null,
    Object? channelId = freezed,
    Object? name = null,
    Object? account = null,
  }) {
    return _then(_$_TabSetting(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      tabType: null == tabType
          ? _value.tabType
          : tabType // ignore: cast_nullable_to_non_nullable
              as TabType,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TabSetting extends _TabSetting {
  const _$_TabSetting(
      {@IconDataConverter() required this.icon,
      required this.tabType,
      this.channelId,
      required this.name,
      required this.account})
      : super._();

  factory _$_TabSetting.fromJson(Map<String, dynamic> json) =>
      _$$_TabSettingFromJson(json);

  @override
  @IconDataConverter()
  final IconData icon;
  @override
  final TabType tabType;
  @override
  final String? channelId;
  @override
  final String name;
  @override
  final Account account;

  @override
  String toString() {
    return 'TabSetting(icon: $icon, tabType: $tabType, channelId: $channelId, name: $name, account: $account)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TabSetting &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.tabType, tabType) || other.tabType == tabType) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.account, account) || other.account == account));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, icon, tabType, channelId, name, account);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TabSettingCopyWith<_$_TabSetting> get copyWith =>
      __$$_TabSettingCopyWithImpl<_$_TabSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TabSettingToJson(
      this,
    );
  }
}

abstract class _TabSetting extends TabSetting {
  const factory _TabSetting(
      {@IconDataConverter() required final IconData icon,
      required final TabType tabType,
      final String? channelId,
      required final String name,
      required final Account account}) = _$_TabSetting;
  const _TabSetting._() : super._();

  factory _TabSetting.fromJson(Map<String, dynamic> json) =
      _$_TabSetting.fromJson;

  @override
  @IconDataConverter()
  IconData get icon;
  @override
  TabType get tabType;
  @override
  String? get channelId;
  @override
  String get name;
  @override
  Account get account;
  @override
  @JsonKey(ignore: true)
  _$$_TabSettingCopyWith<_$_TabSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
