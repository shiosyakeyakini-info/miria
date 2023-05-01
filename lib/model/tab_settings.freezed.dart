// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tab_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TabSettings {
  IconData get icon => throw _privateConstructorUsedError;
  TabType get tabType => throw _privateConstructorUsedError;
  String? get channelId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TabSettingsCopyWith<TabSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TabSettingsCopyWith<$Res> {
  factory $TabSettingsCopyWith(
          TabSettings value, $Res Function(TabSettings) then) =
      _$TabSettingsCopyWithImpl<$Res, TabSettings>;
  @useResult
  $Res call({IconData icon, TabType tabType, String? channelId, String name});
}

/// @nodoc
class _$TabSettingsCopyWithImpl<$Res, $Val extends TabSettings>
    implements $TabSettingsCopyWith<$Res> {
  _$TabSettingsCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TabSettingsCopyWith<$Res>
    implements $TabSettingsCopyWith<$Res> {
  factory _$$_TabSettingsCopyWith(
          _$_TabSettings value, $Res Function(_$_TabSettings) then) =
      __$$_TabSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IconData icon, TabType tabType, String? channelId, String name});
}

/// @nodoc
class __$$_TabSettingsCopyWithImpl<$Res>
    extends _$TabSettingsCopyWithImpl<$Res, _$_TabSettings>
    implements _$$_TabSettingsCopyWith<$Res> {
  __$$_TabSettingsCopyWithImpl(
      _$_TabSettings _value, $Res Function(_$_TabSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? tabType = null,
    Object? channelId = freezed,
    Object? name = null,
  }) {
    return _then(_$_TabSettings(
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
    ));
  }
}

/// @nodoc

class _$_TabSettings extends _TabSettings {
  const _$_TabSettings(
      {required this.icon,
      required this.tabType,
      this.channelId,
      required this.name})
      : super._();

  @override
  final IconData icon;
  @override
  final TabType tabType;
  @override
  final String? channelId;
  @override
  final String name;

  @override
  String toString() {
    return 'TabSettings(icon: $icon, tabType: $tabType, channelId: $channelId, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TabSettings &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.tabType, tabType) || other.tabType == tabType) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, icon, tabType, channelId, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TabSettingsCopyWith<_$_TabSettings> get copyWith =>
      __$$_TabSettingsCopyWithImpl<_$_TabSettings>(this, _$identity);
}

abstract class _TabSettings extends TabSettings {
  const factory _TabSettings(
      {required final IconData icon,
      required final TabType tabType,
      final String? channelId,
      required final String name}) = _$_TabSettings;
  const _TabSettings._() : super._();

  @override
  IconData get icon;
  @override
  TabType get tabType;
  @override
  String? get channelId;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_TabSettingsCopyWith<_$_TabSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
