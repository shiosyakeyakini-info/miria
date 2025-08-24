// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tab_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TabSetting {

@IconDataConverter() TabIcon get icon;/// タブ種別
 TabType get tabType;/// アカウント情報
// https://github.com/rrousselGit/freezed/issues/488
// ignore: invalid_annotation_target
@JsonKey(readValue: _readAcct) Acct get acct;/// ロールタイムラインのノートの場合、ロールID
 String? get roleId;/// チャンネルのノートの場合、チャンネルID
 String? get channelId;/// リストのノートの場合、リストID
 String? get listId;/// アンテナのノートの場合、アンテナID
 String? get antennaId;/// カスタムタイムラインのチャンネル名
 String? get customChannelName;/// カスタムタイムラインのWebSocketパス
 String? get customWebSocketPath;/// カスタムタイムラインのAPIパス
 String? get customApiPath;/// カスタムタイムラインのパラメータ
 Map<String, dynamic>? get customParameters;/// ノートの投稿のキャプチャをするかどうか
 bool get isSubscribe;/// 返信を含むかどうか
 bool get isIncludeReplies;/// ファイルのみにするかどうか
 bool get isMediaOnly;/// タブ名
 String? get name;/// Renoteを表示するかどうか
 bool get renoteDisplay;
/// Create a copy of TabSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabSettingCopyWith<TabSetting> get copyWith => _$TabSettingCopyWithImpl<TabSetting>(this as TabSetting, _$identity);

  /// Serializes this TabSetting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabSetting&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.tabType, tabType) || other.tabType == tabType)&&(identical(other.acct, acct) || other.acct == acct)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.antennaId, antennaId) || other.antennaId == antennaId)&&(identical(other.customChannelName, customChannelName) || other.customChannelName == customChannelName)&&(identical(other.customWebSocketPath, customWebSocketPath) || other.customWebSocketPath == customWebSocketPath)&&(identical(other.customApiPath, customApiPath) || other.customApiPath == customApiPath)&&const DeepCollectionEquality().equals(other.customParameters, customParameters)&&(identical(other.isSubscribe, isSubscribe) || other.isSubscribe == isSubscribe)&&(identical(other.isIncludeReplies, isIncludeReplies) || other.isIncludeReplies == isIncludeReplies)&&(identical(other.isMediaOnly, isMediaOnly) || other.isMediaOnly == isMediaOnly)&&(identical(other.name, name) || other.name == name)&&(identical(other.renoteDisplay, renoteDisplay) || other.renoteDisplay == renoteDisplay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,tabType,acct,roleId,channelId,listId,antennaId,customChannelName,customWebSocketPath,customApiPath,const DeepCollectionEquality().hash(customParameters),isSubscribe,isIncludeReplies,isMediaOnly,name,renoteDisplay);

@override
String toString() {
  return 'TabSetting(icon: $icon, tabType: $tabType, acct: $acct, roleId: $roleId, channelId: $channelId, listId: $listId, antennaId: $antennaId, customChannelName: $customChannelName, customWebSocketPath: $customWebSocketPath, customApiPath: $customApiPath, customParameters: $customParameters, isSubscribe: $isSubscribe, isIncludeReplies: $isIncludeReplies, isMediaOnly: $isMediaOnly, name: $name, renoteDisplay: $renoteDisplay)';
}


}

/// @nodoc
abstract mixin class $TabSettingCopyWith<$Res>  {
  factory $TabSettingCopyWith(TabSetting value, $Res Function(TabSetting) _then) = _$TabSettingCopyWithImpl;
@useResult
$Res call({
@IconDataConverter() TabIcon icon, TabType tabType,@JsonKey(readValue: _readAcct) Acct acct, String? roleId, String? channelId, String? listId, String? antennaId, String? customChannelName, String? customWebSocketPath, String? customApiPath, Map<String, dynamic>? customParameters, bool isSubscribe, bool isIncludeReplies, bool isMediaOnly, String? name, bool renoteDisplay
});


$TabIconCopyWith<$Res> get icon;$AcctCopyWith<$Res> get acct;

}
/// @nodoc
class _$TabSettingCopyWithImpl<$Res>
    implements $TabSettingCopyWith<$Res> {
  _$TabSettingCopyWithImpl(this._self, this._then);

  final TabSetting _self;
  final $Res Function(TabSetting) _then;

/// Create a copy of TabSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? tabType = null,Object? acct = null,Object? roleId = freezed,Object? channelId = freezed,Object? listId = freezed,Object? antennaId = freezed,Object? customChannelName = freezed,Object? customWebSocketPath = freezed,Object? customApiPath = freezed,Object? customParameters = freezed,Object? isSubscribe = null,Object? isIncludeReplies = null,Object? isMediaOnly = null,Object? name = freezed,Object? renoteDisplay = null,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as TabIcon,tabType: null == tabType ? _self.tabType : tabType // ignore: cast_nullable_to_non_nullable
as TabType,acct: null == acct ? _self.acct : acct // ignore: cast_nullable_to_non_nullable
as Acct,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,channelId: freezed == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String?,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String?,antennaId: freezed == antennaId ? _self.antennaId : antennaId // ignore: cast_nullable_to_non_nullable
as String?,customChannelName: freezed == customChannelName ? _self.customChannelName : customChannelName // ignore: cast_nullable_to_non_nullable
as String?,customWebSocketPath: freezed == customWebSocketPath ? _self.customWebSocketPath : customWebSocketPath // ignore: cast_nullable_to_non_nullable
as String?,customApiPath: freezed == customApiPath ? _self.customApiPath : customApiPath // ignore: cast_nullable_to_non_nullable
as String?,customParameters: freezed == customParameters ? _self.customParameters : customParameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isSubscribe: null == isSubscribe ? _self.isSubscribe : isSubscribe // ignore: cast_nullable_to_non_nullable
as bool,isIncludeReplies: null == isIncludeReplies ? _self.isIncludeReplies : isIncludeReplies // ignore: cast_nullable_to_non_nullable
as bool,isMediaOnly: null == isMediaOnly ? _self.isMediaOnly : isMediaOnly // ignore: cast_nullable_to_non_nullable
as bool,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,renoteDisplay: null == renoteDisplay ? _self.renoteDisplay : renoteDisplay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TabSetting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TabIconCopyWith<$Res> get icon {
  
  return $TabIconCopyWith<$Res>(_self.icon, (value) {
    return _then(_self.copyWith(icon: value));
  });
}/// Create a copy of TabSetting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcctCopyWith<$Res> get acct {
  
  return $AcctCopyWith<$Res>(_self.acct, (value) {
    return _then(_self.copyWith(acct: value));
  });
}
}


/// Adds pattern-matching-related methods to [TabSetting].
extension TabSettingPatterns on TabSetting {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TabSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TabSetting() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TabSetting value)  $default,){
final _that = this;
switch (_that) {
case _TabSetting():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TabSetting value)?  $default,){
final _that = this;
switch (_that) {
case _TabSetting() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IconDataConverter()  TabIcon icon,  TabType tabType, @JsonKey(readValue: _readAcct)  Acct acct,  String? roleId,  String? channelId,  String? listId,  String? antennaId,  String? customChannelName,  String? customWebSocketPath,  String? customApiPath,  Map<String, dynamic>? customParameters,  bool isSubscribe,  bool isIncludeReplies,  bool isMediaOnly,  String? name,  bool renoteDisplay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TabSetting() when $default != null:
return $default(_that.icon,_that.tabType,_that.acct,_that.roleId,_that.channelId,_that.listId,_that.antennaId,_that.customChannelName,_that.customWebSocketPath,_that.customApiPath,_that.customParameters,_that.isSubscribe,_that.isIncludeReplies,_that.isMediaOnly,_that.name,_that.renoteDisplay);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IconDataConverter()  TabIcon icon,  TabType tabType, @JsonKey(readValue: _readAcct)  Acct acct,  String? roleId,  String? channelId,  String? listId,  String? antennaId,  String? customChannelName,  String? customWebSocketPath,  String? customApiPath,  Map<String, dynamic>? customParameters,  bool isSubscribe,  bool isIncludeReplies,  bool isMediaOnly,  String? name,  bool renoteDisplay)  $default,) {final _that = this;
switch (_that) {
case _TabSetting():
return $default(_that.icon,_that.tabType,_that.acct,_that.roleId,_that.channelId,_that.listId,_that.antennaId,_that.customChannelName,_that.customWebSocketPath,_that.customApiPath,_that.customParameters,_that.isSubscribe,_that.isIncludeReplies,_that.isMediaOnly,_that.name,_that.renoteDisplay);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IconDataConverter()  TabIcon icon,  TabType tabType, @JsonKey(readValue: _readAcct)  Acct acct,  String? roleId,  String? channelId,  String? listId,  String? antennaId,  String? customChannelName,  String? customWebSocketPath,  String? customApiPath,  Map<String, dynamic>? customParameters,  bool isSubscribe,  bool isIncludeReplies,  bool isMediaOnly,  String? name,  bool renoteDisplay)?  $default,) {final _that = this;
switch (_that) {
case _TabSetting() when $default != null:
return $default(_that.icon,_that.tabType,_that.acct,_that.roleId,_that.channelId,_that.listId,_that.antennaId,_that.customChannelName,_that.customWebSocketPath,_that.customApiPath,_that.customParameters,_that.isSubscribe,_that.isIncludeReplies,_that.isMediaOnly,_that.name,_that.renoteDisplay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TabSetting extends TabSetting {
  const _TabSetting({@IconDataConverter() required this.icon, required this.tabType, @JsonKey(readValue: _readAcct) required this.acct, this.roleId, this.channelId, this.listId, this.antennaId, this.customChannelName, this.customWebSocketPath, this.customApiPath, final  Map<String, dynamic>? customParameters, this.isSubscribe = true, this.isIncludeReplies = true, this.isMediaOnly = false, this.name, this.renoteDisplay = true}): _customParameters = customParameters,super._();
  factory _TabSetting.fromJson(Map<String, dynamic> json) => _$TabSettingFromJson(json);

@override@IconDataConverter() final  TabIcon icon;
/// タブ種別
@override final  TabType tabType;
/// アカウント情報
// https://github.com/rrousselGit/freezed/issues/488
// ignore: invalid_annotation_target
@override@JsonKey(readValue: _readAcct) final  Acct acct;
/// ロールタイムラインのノートの場合、ロールID
@override final  String? roleId;
/// チャンネルのノートの場合、チャンネルID
@override final  String? channelId;
/// リストのノートの場合、リストID
@override final  String? listId;
/// アンテナのノートの場合、アンテナID
@override final  String? antennaId;
/// カスタムタイムラインのチャンネル名
@override final  String? customChannelName;
/// カスタムタイムラインのWebSocketパス
@override final  String? customWebSocketPath;
/// カスタムタイムラインのAPIパス
@override final  String? customApiPath;
/// カスタムタイムラインのパラメータ
 final  Map<String, dynamic>? _customParameters;
/// カスタムタイムラインのパラメータ
@override Map<String, dynamic>? get customParameters {
  final value = _customParameters;
  if (value == null) return null;
  if (_customParameters is EqualUnmodifiableMapView) return _customParameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// ノートの投稿のキャプチャをするかどうか
@override@JsonKey() final  bool isSubscribe;
/// 返信を含むかどうか
@override@JsonKey() final  bool isIncludeReplies;
/// ファイルのみにするかどうか
@override@JsonKey() final  bool isMediaOnly;
/// タブ名
@override final  String? name;
/// Renoteを表示するかどうか
@override@JsonKey() final  bool renoteDisplay;

/// Create a copy of TabSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TabSettingCopyWith<_TabSetting> get copyWith => __$TabSettingCopyWithImpl<_TabSetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TabSettingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TabSetting&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.tabType, tabType) || other.tabType == tabType)&&(identical(other.acct, acct) || other.acct == acct)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.antennaId, antennaId) || other.antennaId == antennaId)&&(identical(other.customChannelName, customChannelName) || other.customChannelName == customChannelName)&&(identical(other.customWebSocketPath, customWebSocketPath) || other.customWebSocketPath == customWebSocketPath)&&(identical(other.customApiPath, customApiPath) || other.customApiPath == customApiPath)&&const DeepCollectionEquality().equals(other._customParameters, _customParameters)&&(identical(other.isSubscribe, isSubscribe) || other.isSubscribe == isSubscribe)&&(identical(other.isIncludeReplies, isIncludeReplies) || other.isIncludeReplies == isIncludeReplies)&&(identical(other.isMediaOnly, isMediaOnly) || other.isMediaOnly == isMediaOnly)&&(identical(other.name, name) || other.name == name)&&(identical(other.renoteDisplay, renoteDisplay) || other.renoteDisplay == renoteDisplay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,tabType,acct,roleId,channelId,listId,antennaId,customChannelName,customWebSocketPath,customApiPath,const DeepCollectionEquality().hash(_customParameters),isSubscribe,isIncludeReplies,isMediaOnly,name,renoteDisplay);

@override
String toString() {
  return 'TabSetting(icon: $icon, tabType: $tabType, acct: $acct, roleId: $roleId, channelId: $channelId, listId: $listId, antennaId: $antennaId, customChannelName: $customChannelName, customWebSocketPath: $customWebSocketPath, customApiPath: $customApiPath, customParameters: $customParameters, isSubscribe: $isSubscribe, isIncludeReplies: $isIncludeReplies, isMediaOnly: $isMediaOnly, name: $name, renoteDisplay: $renoteDisplay)';
}


}

/// @nodoc
abstract mixin class _$TabSettingCopyWith<$Res> implements $TabSettingCopyWith<$Res> {
  factory _$TabSettingCopyWith(_TabSetting value, $Res Function(_TabSetting) _then) = __$TabSettingCopyWithImpl;
@override @useResult
$Res call({
@IconDataConverter() TabIcon icon, TabType tabType,@JsonKey(readValue: _readAcct) Acct acct, String? roleId, String? channelId, String? listId, String? antennaId, String? customChannelName, String? customWebSocketPath, String? customApiPath, Map<String, dynamic>? customParameters, bool isSubscribe, bool isIncludeReplies, bool isMediaOnly, String? name, bool renoteDisplay
});


@override $TabIconCopyWith<$Res> get icon;@override $AcctCopyWith<$Res> get acct;

}
/// @nodoc
class __$TabSettingCopyWithImpl<$Res>
    implements _$TabSettingCopyWith<$Res> {
  __$TabSettingCopyWithImpl(this._self, this._then);

  final _TabSetting _self;
  final $Res Function(_TabSetting) _then;

/// Create a copy of TabSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? tabType = null,Object? acct = null,Object? roleId = freezed,Object? channelId = freezed,Object? listId = freezed,Object? antennaId = freezed,Object? customChannelName = freezed,Object? customWebSocketPath = freezed,Object? customApiPath = freezed,Object? customParameters = freezed,Object? isSubscribe = null,Object? isIncludeReplies = null,Object? isMediaOnly = null,Object? name = freezed,Object? renoteDisplay = null,}) {
  return _then(_TabSetting(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as TabIcon,tabType: null == tabType ? _self.tabType : tabType // ignore: cast_nullable_to_non_nullable
as TabType,acct: null == acct ? _self.acct : acct // ignore: cast_nullable_to_non_nullable
as Acct,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,channelId: freezed == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String?,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String?,antennaId: freezed == antennaId ? _self.antennaId : antennaId // ignore: cast_nullable_to_non_nullable
as String?,customChannelName: freezed == customChannelName ? _self.customChannelName : customChannelName // ignore: cast_nullable_to_non_nullable
as String?,customWebSocketPath: freezed == customWebSocketPath ? _self.customWebSocketPath : customWebSocketPath // ignore: cast_nullable_to_non_nullable
as String?,customApiPath: freezed == customApiPath ? _self.customApiPath : customApiPath // ignore: cast_nullable_to_non_nullable
as String?,customParameters: freezed == customParameters ? _self._customParameters : customParameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isSubscribe: null == isSubscribe ? _self.isSubscribe : isSubscribe // ignore: cast_nullable_to_non_nullable
as bool,isIncludeReplies: null == isIncludeReplies ? _self.isIncludeReplies : isIncludeReplies // ignore: cast_nullable_to_non_nullable
as bool,isMediaOnly: null == isMediaOnly ? _self.isMediaOnly : isMediaOnly // ignore: cast_nullable_to_non_nullable
as bool,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,renoteDisplay: null == renoteDisplay ? _self.renoteDisplay : renoteDisplay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TabSetting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TabIconCopyWith<$Res> get icon {
  
  return $TabIconCopyWith<$Res>(_self.icon, (value) {
    return _then(_self.copyWith(icon: value));
  });
}/// Create a copy of TabSetting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcctCopyWith<$Res> get acct {
  
  return $AcctCopyWith<$Res>(_self.acct, (value) {
    return _then(_self.copyWith(acct: value));
  });
}
}

// dart format on
