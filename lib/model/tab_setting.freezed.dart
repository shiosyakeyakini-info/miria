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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TabSetting _$TabSettingFromJson(Map<String, dynamic> json) {
  return _TabSetting.fromJson(json);
}

/// @nodoc
mixin _$TabSetting {
  @IconDataConverter()
  TabIcon get icon => throw _privateConstructorUsedError;

  /// タブ種別
  TabType get tabType => throw _privateConstructorUsedError;

  /// アカウント情報
// https://github.com/rrousselGit/freezed/issues/488
// ignore: invalid_annotation_target
  @JsonKey(readValue: _readAcct)
  Acct get acct => throw _privateConstructorUsedError;

  /// ロールタイムラインのノートの場合、ロールID
  String? get roleId => throw _privateConstructorUsedError;

  /// チャンネルのノートの場合、チャンネルID
  String? get channelId => throw _privateConstructorUsedError;

  /// リストのノートの場合、リストID
  String? get listId => throw _privateConstructorUsedError;

  /// アンテナのノートの場合、アンテナID
  String? get antennaId => throw _privateConstructorUsedError;

  /// ノートの投稿のキャプチャをするかどうか
  bool get isSubscribe => throw _privateConstructorUsedError;

  /// 返信を含むかどうか
  bool get isIncludeReplies => throw _privateConstructorUsedError;

  /// ファイルのみにするかどうか
  bool get isMediaOnly => throw _privateConstructorUsedError;

  /// タブ名
  String? get name => throw _privateConstructorUsedError;

  /// Renoteを表示するかどうか
  bool get renoteDisplay => throw _privateConstructorUsedError;

  /// Serializes this TabSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TabSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {@IconDataConverter() TabIcon icon,
      TabType tabType,
      @JsonKey(readValue: _readAcct) Acct acct,
      String? roleId,
      String? channelId,
      String? listId,
      String? antennaId,
      bool isSubscribe,
      bool isIncludeReplies,
      bool isMediaOnly,
      String? name,
      bool renoteDisplay});

  $TabIconCopyWith<$Res> get icon;
  $AcctCopyWith<$Res> get acct;
}

/// @nodoc
class _$TabSettingCopyWithImpl<$Res, $Val extends TabSetting>
    implements $TabSettingCopyWith<$Res> {
  _$TabSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TabSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? tabType = null,
    Object? acct = null,
    Object? roleId = freezed,
    Object? channelId = freezed,
    Object? listId = freezed,
    Object? antennaId = freezed,
    Object? isSubscribe = null,
    Object? isIncludeReplies = null,
    Object? isMediaOnly = null,
    Object? name = freezed,
    Object? renoteDisplay = null,
  }) {
    return _then(_value.copyWith(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as TabIcon,
      tabType: null == tabType
          ? _value.tabType
          : tabType // ignore: cast_nullable_to_non_nullable
              as TabType,
      acct: null == acct
          ? _value.acct
          : acct // ignore: cast_nullable_to_non_nullable
              as Acct,
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String?,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      listId: freezed == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String?,
      antennaId: freezed == antennaId
          ? _value.antennaId
          : antennaId // ignore: cast_nullable_to_non_nullable
              as String?,
      isSubscribe: null == isSubscribe
          ? _value.isSubscribe
          : isSubscribe // ignore: cast_nullable_to_non_nullable
              as bool,
      isIncludeReplies: null == isIncludeReplies
          ? _value.isIncludeReplies
          : isIncludeReplies // ignore: cast_nullable_to_non_nullable
              as bool,
      isMediaOnly: null == isMediaOnly
          ? _value.isMediaOnly
          : isMediaOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      renoteDisplay: null == renoteDisplay
          ? _value.renoteDisplay
          : renoteDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of TabSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TabIconCopyWith<$Res> get icon {
    return $TabIconCopyWith<$Res>(_value.icon, (value) {
      return _then(_value.copyWith(icon: value) as $Val);
    });
  }

  /// Create a copy of TabSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AcctCopyWith<$Res> get acct {
    return $AcctCopyWith<$Res>(_value.acct, (value) {
      return _then(_value.copyWith(acct: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TabSettingImplCopyWith<$Res>
    implements $TabSettingCopyWith<$Res> {
  factory _$$TabSettingImplCopyWith(
          _$TabSettingImpl value, $Res Function(_$TabSettingImpl) then) =
      __$$TabSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@IconDataConverter() TabIcon icon,
      TabType tabType,
      @JsonKey(readValue: _readAcct) Acct acct,
      String? roleId,
      String? channelId,
      String? listId,
      String? antennaId,
      bool isSubscribe,
      bool isIncludeReplies,
      bool isMediaOnly,
      String? name,
      bool renoteDisplay});

  @override
  $TabIconCopyWith<$Res> get icon;
  @override
  $AcctCopyWith<$Res> get acct;
}

/// @nodoc
class __$$TabSettingImplCopyWithImpl<$Res>
    extends _$TabSettingCopyWithImpl<$Res, _$TabSettingImpl>
    implements _$$TabSettingImplCopyWith<$Res> {
  __$$TabSettingImplCopyWithImpl(
      _$TabSettingImpl _value, $Res Function(_$TabSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of TabSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? tabType = null,
    Object? acct = null,
    Object? roleId = freezed,
    Object? channelId = freezed,
    Object? listId = freezed,
    Object? antennaId = freezed,
    Object? isSubscribe = null,
    Object? isIncludeReplies = null,
    Object? isMediaOnly = null,
    Object? name = freezed,
    Object? renoteDisplay = null,
  }) {
    return _then(_$TabSettingImpl(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as TabIcon,
      tabType: null == tabType
          ? _value.tabType
          : tabType // ignore: cast_nullable_to_non_nullable
              as TabType,
      acct: null == acct
          ? _value.acct
          : acct // ignore: cast_nullable_to_non_nullable
              as Acct,
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String?,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      listId: freezed == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String?,
      antennaId: freezed == antennaId
          ? _value.antennaId
          : antennaId // ignore: cast_nullable_to_non_nullable
              as String?,
      isSubscribe: null == isSubscribe
          ? _value.isSubscribe
          : isSubscribe // ignore: cast_nullable_to_non_nullable
              as bool,
      isIncludeReplies: null == isIncludeReplies
          ? _value.isIncludeReplies
          : isIncludeReplies // ignore: cast_nullable_to_non_nullable
              as bool,
      isMediaOnly: null == isMediaOnly
          ? _value.isMediaOnly
          : isMediaOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      renoteDisplay: null == renoteDisplay
          ? _value.renoteDisplay
          : renoteDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TabSettingImpl extends _TabSetting {
  const _$TabSettingImpl(
      {@IconDataConverter() required this.icon,
      required this.tabType,
      @JsonKey(readValue: _readAcct) required this.acct,
      this.roleId,
      this.channelId,
      this.listId,
      this.antennaId,
      this.isSubscribe = true,
      this.isIncludeReplies = true,
      this.isMediaOnly = false,
      this.name,
      this.renoteDisplay = true})
      : super._();

  factory _$TabSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$TabSettingImplFromJson(json);

  @override
  @IconDataConverter()
  final TabIcon icon;

  /// タブ種別
  @override
  final TabType tabType;

  /// アカウント情報
// https://github.com/rrousselGit/freezed/issues/488
// ignore: invalid_annotation_target
  @override
  @JsonKey(readValue: _readAcct)
  final Acct acct;

  /// ロールタイムラインのノートの場合、ロールID
  @override
  final String? roleId;

  /// チャンネルのノートの場合、チャンネルID
  @override
  final String? channelId;

  /// リストのノートの場合、リストID
  @override
  final String? listId;

  /// アンテナのノートの場合、アンテナID
  @override
  final String? antennaId;

  /// ノートの投稿のキャプチャをするかどうか
  @override
  @JsonKey()
  final bool isSubscribe;

  /// 返信を含むかどうか
  @override
  @JsonKey()
  final bool isIncludeReplies;

  /// ファイルのみにするかどうか
  @override
  @JsonKey()
  final bool isMediaOnly;

  /// タブ名
  @override
  final String? name;

  /// Renoteを表示するかどうか
  @override
  @JsonKey()
  final bool renoteDisplay;

  @override
  String toString() {
    return 'TabSetting(icon: $icon, tabType: $tabType, acct: $acct, roleId: $roleId, channelId: $channelId, listId: $listId, antennaId: $antennaId, isSubscribe: $isSubscribe, isIncludeReplies: $isIncludeReplies, isMediaOnly: $isMediaOnly, name: $name, renoteDisplay: $renoteDisplay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TabSettingImpl &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.tabType, tabType) || other.tabType == tabType) &&
            (identical(other.acct, acct) || other.acct == acct) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.listId, listId) || other.listId == listId) &&
            (identical(other.antennaId, antennaId) ||
                other.antennaId == antennaId) &&
            (identical(other.isSubscribe, isSubscribe) ||
                other.isSubscribe == isSubscribe) &&
            (identical(other.isIncludeReplies, isIncludeReplies) ||
                other.isIncludeReplies == isIncludeReplies) &&
            (identical(other.isMediaOnly, isMediaOnly) ||
                other.isMediaOnly == isMediaOnly) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.renoteDisplay, renoteDisplay) ||
                other.renoteDisplay == renoteDisplay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      icon,
      tabType,
      acct,
      roleId,
      channelId,
      listId,
      antennaId,
      isSubscribe,
      isIncludeReplies,
      isMediaOnly,
      name,
      renoteDisplay);

  /// Create a copy of TabSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TabSettingImplCopyWith<_$TabSettingImpl> get copyWith =>
      __$$TabSettingImplCopyWithImpl<_$TabSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TabSettingImplToJson(
      this,
    );
  }
}

abstract class _TabSetting extends TabSetting {
  const factory _TabSetting(
      {@IconDataConverter() required final TabIcon icon,
      required final TabType tabType,
      @JsonKey(readValue: _readAcct) required final Acct acct,
      final String? roleId,
      final String? channelId,
      final String? listId,
      final String? antennaId,
      final bool isSubscribe,
      final bool isIncludeReplies,
      final bool isMediaOnly,
      final String? name,
      final bool renoteDisplay}) = _$TabSettingImpl;
  const _TabSetting._() : super._();

  factory _TabSetting.fromJson(Map<String, dynamic> json) =
      _$TabSettingImpl.fromJson;

  @override
  @IconDataConverter()
  TabIcon get icon;

  /// タブ種別
  @override
  TabType get tabType;

  /// アカウント情報
// https://github.com/rrousselGit/freezed/issues/488
// ignore: invalid_annotation_target
  @override
  @JsonKey(readValue: _readAcct)
  Acct get acct;

  /// ロールタイムラインのノートの場合、ロールID
  @override
  String? get roleId;

  /// チャンネルのノートの場合、チャンネルID
  @override
  String? get channelId;

  /// リストのノートの場合、リストID
  @override
  String? get listId;

  /// アンテナのノートの場合、アンテナID
  @override
  String? get antennaId;

  /// ノートの投稿のキャプチャをするかどうか
  @override
  bool get isSubscribe;

  /// 返信を含むかどうか
  @override
  bool get isIncludeReplies;

  /// ファイルのみにするかどうか
  @override
  bool get isMediaOnly;

  /// タブ名
  @override
  String? get name;

  /// Renoteを表示するかどうか
  @override
  bool get renoteDisplay;

  /// Create a copy of TabSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TabSettingImplCopyWith<_$TabSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
