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
  TabIcon get icon => throw _privateConstructorUsedError;

  /// タブ種別
  TabType get tabType => throw _privateConstructorUsedError;

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

  /// アカウント情報
// https://github.com/rrousselGit/freezed/issues/488
// ignore: invalid_annotation_target
  @JsonKey(readValue: _readAcct)
  Acct get acct => throw _privateConstructorUsedError;

  /// Renoteを表示するかどうか
  bool get renoteDisplay => throw _privateConstructorUsedError;

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
      {@IconDataConverter() TabIcon icon,
      TabType tabType,
      String? roleId,
      String? channelId,
      String? listId,
      String? antennaId,
      bool isSubscribe,
      bool isIncludeReplies,
      bool isMediaOnly,
      String? name,
      @JsonKey(readValue: _readAcct) Acct acct,
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? tabType = null,
    Object? roleId = freezed,
    Object? channelId = freezed,
    Object? listId = freezed,
    Object? antennaId = freezed,
    Object? isSubscribe = null,
    Object? isIncludeReplies = null,
    Object? isMediaOnly = null,
    Object? name = freezed,
    Object? acct = null,
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
      acct: null == acct
          ? _value.acct
          : acct // ignore: cast_nullable_to_non_nullable
              as Acct,
      renoteDisplay: null == renoteDisplay
          ? _value.renoteDisplay
          : renoteDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TabIconCopyWith<$Res> get icon {
    return $TabIconCopyWith<$Res>(_value.icon, (value) {
      return _then(_value.copyWith(icon: value) as $Val);
    });
  }

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
      String? roleId,
      String? channelId,
      String? listId,
      String? antennaId,
      bool isSubscribe,
      bool isIncludeReplies,
      bool isMediaOnly,
      String? name,
      @JsonKey(readValue: _readAcct) Acct acct,
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? tabType = null,
    Object? roleId = freezed,
    Object? channelId = freezed,
    Object? listId = freezed,
    Object? antennaId = freezed,
    Object? isSubscribe = null,
    Object? isIncludeReplies = null,
    Object? isMediaOnly = null,
    Object? name = freezed,
    Object? acct = null,
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
      acct: null == acct
          ? _value.acct
          : acct // ignore: cast_nullable_to_non_nullable
              as Acct,
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
      this.roleId,
      this.channelId,
      this.listId,
      this.antennaId,
      this.isSubscribe = true,
      this.isIncludeReplies = true,
      this.isMediaOnly = false,
      this.name,
      @JsonKey(readValue: _readAcct) required this.acct,
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

  /// アカウント情報
// https://github.com/rrousselGit/freezed/issues/488
// ignore: invalid_annotation_target
  @override
  @JsonKey(readValue: _readAcct)
  final Acct acct;

  /// Renoteを表示するかどうか
  @override
  @JsonKey()
  final bool renoteDisplay;

  @override
  String toString() {
    return 'TabSetting(icon: $icon, tabType: $tabType, roleId: $roleId, channelId: $channelId, listId: $listId, antennaId: $antennaId, isSubscribe: $isSubscribe, isIncludeReplies: $isIncludeReplies, isMediaOnly: $isMediaOnly, name: $name, acct: $acct, renoteDisplay: $renoteDisplay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TabSettingImpl &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.tabType, tabType) || other.tabType == tabType) &&
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
            (identical(other.acct, acct) || other.acct == acct) &&
            (identical(other.renoteDisplay, renoteDisplay) ||
                other.renoteDisplay == renoteDisplay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      icon,
      tabType,
      roleId,
      channelId,
      listId,
      antennaId,
      isSubscribe,
      isIncludeReplies,
      isMediaOnly,
      name,
      acct,
      renoteDisplay);

  @JsonKey(ignore: true)
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
      final String? roleId,
      final String? channelId,
      final String? listId,
      final String? antennaId,
      final bool isSubscribe,
      final bool isIncludeReplies,
      final bool isMediaOnly,
      final String? name,
      @JsonKey(readValue: _readAcct) required final Acct acct,
      final bool renoteDisplay}) = _$TabSettingImpl;
  const _TabSetting._() : super._();

  factory _TabSetting.fromJson(Map<String, dynamic> json) =
      _$TabSettingImpl.fromJson;

  @override
  @IconDataConverter()
  TabIcon get icon;
  @override

  /// タブ種別
  TabType get tabType;
  @override

  /// ロールタイムラインのノートの場合、ロールID
  String? get roleId;
  @override

  /// チャンネルのノートの場合、チャンネルID
  String? get channelId;
  @override

  /// リストのノートの場合、リストID
  String? get listId;
  @override

  /// アンテナのノートの場合、アンテナID
  String? get antennaId;
  @override

  /// ノートの投稿のキャプチャをするかどうか
  bool get isSubscribe;
  @override

  /// 返信を含むかどうか
  bool get isIncludeReplies;
  @override

  /// ファイルのみにするかどうか
  bool get isMediaOnly;
  @override

  /// タブ名
  String? get name;
  @override

  /// アカウント情報
// https://github.com/rrousselGit/freezed/issues/488
// ignore: invalid_annotation_target
  @JsonKey(readValue: _readAcct)
  Acct get acct;
  @override

  /// Renoteを表示するかどうか
  bool get renoteDisplay;
  @override
  @JsonKey(ignore: true)
  _$$TabSettingImplCopyWith<_$TabSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
