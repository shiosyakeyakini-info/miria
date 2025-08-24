// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountSettings {

 String get userId; String get host; List<String> get reactions; List<String> get mutedReactions; NoteVisibility get defaultNoteVisibility; bool get defaultIsLocalOnly; ReactionAcceptance? get defaultReactionAcceptance; CacheStrategy get iCacheStrategy; DateTime? get latestICached; CacheStrategy get emojiCacheStrategy; DateTime? get latestEmojiCached; CacheStrategy get metaChacheStrategy; DateTime? get latestMetaCached; bool get forceShowAd;
/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSettingsCopyWith<AccountSettings> get copyWith => _$AccountSettingsCopyWithImpl<AccountSettings>(this as AccountSettings, _$identity);

  /// Serializes this AccountSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.mutedReactions, mutedReactions)&&(identical(other.defaultNoteVisibility, defaultNoteVisibility) || other.defaultNoteVisibility == defaultNoteVisibility)&&(identical(other.defaultIsLocalOnly, defaultIsLocalOnly) || other.defaultIsLocalOnly == defaultIsLocalOnly)&&(identical(other.defaultReactionAcceptance, defaultReactionAcceptance) || other.defaultReactionAcceptance == defaultReactionAcceptance)&&(identical(other.iCacheStrategy, iCacheStrategy) || other.iCacheStrategy == iCacheStrategy)&&(identical(other.latestICached, latestICached) || other.latestICached == latestICached)&&(identical(other.emojiCacheStrategy, emojiCacheStrategy) || other.emojiCacheStrategy == emojiCacheStrategy)&&(identical(other.latestEmojiCached, latestEmojiCached) || other.latestEmojiCached == latestEmojiCached)&&(identical(other.metaChacheStrategy, metaChacheStrategy) || other.metaChacheStrategy == metaChacheStrategy)&&(identical(other.latestMetaCached, latestMetaCached) || other.latestMetaCached == latestMetaCached)&&(identical(other.forceShowAd, forceShowAd) || other.forceShowAd == forceShowAd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,host,const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(mutedReactions),defaultNoteVisibility,defaultIsLocalOnly,defaultReactionAcceptance,iCacheStrategy,latestICached,emojiCacheStrategy,latestEmojiCached,metaChacheStrategy,latestMetaCached,forceShowAd);

@override
String toString() {
  return 'AccountSettings(userId: $userId, host: $host, reactions: $reactions, mutedReactions: $mutedReactions, defaultNoteVisibility: $defaultNoteVisibility, defaultIsLocalOnly: $defaultIsLocalOnly, defaultReactionAcceptance: $defaultReactionAcceptance, iCacheStrategy: $iCacheStrategy, latestICached: $latestICached, emojiCacheStrategy: $emojiCacheStrategy, latestEmojiCached: $latestEmojiCached, metaChacheStrategy: $metaChacheStrategy, latestMetaCached: $latestMetaCached, forceShowAd: $forceShowAd)';
}


}

/// @nodoc
abstract mixin class $AccountSettingsCopyWith<$Res>  {
  factory $AccountSettingsCopyWith(AccountSettings value, $Res Function(AccountSettings) _then) = _$AccountSettingsCopyWithImpl;
@useResult
$Res call({
 String userId, String host, List<String> reactions, List<String> mutedReactions, NoteVisibility defaultNoteVisibility, bool defaultIsLocalOnly, ReactionAcceptance? defaultReactionAcceptance, CacheStrategy iCacheStrategy, DateTime? latestICached, CacheStrategy emojiCacheStrategy, DateTime? latestEmojiCached, CacheStrategy metaChacheStrategy, DateTime? latestMetaCached, bool forceShowAd
});




}
/// @nodoc
class _$AccountSettingsCopyWithImpl<$Res>
    implements $AccountSettingsCopyWith<$Res> {
  _$AccountSettingsCopyWithImpl(this._self, this._then);

  final AccountSettings _self;
  final $Res Function(AccountSettings) _then;

/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? host = null,Object? reactions = null,Object? mutedReactions = null,Object? defaultNoteVisibility = null,Object? defaultIsLocalOnly = null,Object? defaultReactionAcceptance = freezed,Object? iCacheStrategy = null,Object? latestICached = freezed,Object? emojiCacheStrategy = null,Object? latestEmojiCached = freezed,Object? metaChacheStrategy = null,Object? latestMetaCached = freezed,Object? forceShowAd = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<String>,mutedReactions: null == mutedReactions ? _self.mutedReactions : mutedReactions // ignore: cast_nullable_to_non_nullable
as List<String>,defaultNoteVisibility: null == defaultNoteVisibility ? _self.defaultNoteVisibility : defaultNoteVisibility // ignore: cast_nullable_to_non_nullable
as NoteVisibility,defaultIsLocalOnly: null == defaultIsLocalOnly ? _self.defaultIsLocalOnly : defaultIsLocalOnly // ignore: cast_nullable_to_non_nullable
as bool,defaultReactionAcceptance: freezed == defaultReactionAcceptance ? _self.defaultReactionAcceptance : defaultReactionAcceptance // ignore: cast_nullable_to_non_nullable
as ReactionAcceptance?,iCacheStrategy: null == iCacheStrategy ? _self.iCacheStrategy : iCacheStrategy // ignore: cast_nullable_to_non_nullable
as CacheStrategy,latestICached: freezed == latestICached ? _self.latestICached : latestICached // ignore: cast_nullable_to_non_nullable
as DateTime?,emojiCacheStrategy: null == emojiCacheStrategy ? _self.emojiCacheStrategy : emojiCacheStrategy // ignore: cast_nullable_to_non_nullable
as CacheStrategy,latestEmojiCached: freezed == latestEmojiCached ? _self.latestEmojiCached : latestEmojiCached // ignore: cast_nullable_to_non_nullable
as DateTime?,metaChacheStrategy: null == metaChacheStrategy ? _self.metaChacheStrategy : metaChacheStrategy // ignore: cast_nullable_to_non_nullable
as CacheStrategy,latestMetaCached: freezed == latestMetaCached ? _self.latestMetaCached : latestMetaCached // ignore: cast_nullable_to_non_nullable
as DateTime?,forceShowAd: null == forceShowAd ? _self.forceShowAd : forceShowAd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountSettings].
extension AccountSettingsPatterns on AccountSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountSettings value)  $default,){
final _that = this;
switch (_that) {
case _AccountSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AccountSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String host,  List<String> reactions,  List<String> mutedReactions,  NoteVisibility defaultNoteVisibility,  bool defaultIsLocalOnly,  ReactionAcceptance? defaultReactionAcceptance,  CacheStrategy iCacheStrategy,  DateTime? latestICached,  CacheStrategy emojiCacheStrategy,  DateTime? latestEmojiCached,  CacheStrategy metaChacheStrategy,  DateTime? latestMetaCached,  bool forceShowAd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountSettings() when $default != null:
return $default(_that.userId,_that.host,_that.reactions,_that.mutedReactions,_that.defaultNoteVisibility,_that.defaultIsLocalOnly,_that.defaultReactionAcceptance,_that.iCacheStrategy,_that.latestICached,_that.emojiCacheStrategy,_that.latestEmojiCached,_that.metaChacheStrategy,_that.latestMetaCached,_that.forceShowAd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String host,  List<String> reactions,  List<String> mutedReactions,  NoteVisibility defaultNoteVisibility,  bool defaultIsLocalOnly,  ReactionAcceptance? defaultReactionAcceptance,  CacheStrategy iCacheStrategy,  DateTime? latestICached,  CacheStrategy emojiCacheStrategy,  DateTime? latestEmojiCached,  CacheStrategy metaChacheStrategy,  DateTime? latestMetaCached,  bool forceShowAd)  $default,) {final _that = this;
switch (_that) {
case _AccountSettings():
return $default(_that.userId,_that.host,_that.reactions,_that.mutedReactions,_that.defaultNoteVisibility,_that.defaultIsLocalOnly,_that.defaultReactionAcceptance,_that.iCacheStrategy,_that.latestICached,_that.emojiCacheStrategy,_that.latestEmojiCached,_that.metaChacheStrategy,_that.latestMetaCached,_that.forceShowAd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String host,  List<String> reactions,  List<String> mutedReactions,  NoteVisibility defaultNoteVisibility,  bool defaultIsLocalOnly,  ReactionAcceptance? defaultReactionAcceptance,  CacheStrategy iCacheStrategy,  DateTime? latestICached,  CacheStrategy emojiCacheStrategy,  DateTime? latestEmojiCached,  CacheStrategy metaChacheStrategy,  DateTime? latestMetaCached,  bool forceShowAd)?  $default,) {final _that = this;
switch (_that) {
case _AccountSettings() when $default != null:
return $default(_that.userId,_that.host,_that.reactions,_that.mutedReactions,_that.defaultNoteVisibility,_that.defaultIsLocalOnly,_that.defaultReactionAcceptance,_that.iCacheStrategy,_that.latestICached,_that.emojiCacheStrategy,_that.latestEmojiCached,_that.metaChacheStrategy,_that.latestMetaCached,_that.forceShowAd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountSettings extends AccountSettings {
  const _AccountSettings({required this.userId, required this.host, final  List<String> reactions = const [], final  List<String> mutedReactions = const [], this.defaultNoteVisibility = NoteVisibility.public, this.defaultIsLocalOnly = false, this.defaultReactionAcceptance = null, this.iCacheStrategy = CacheStrategy.whenTabChange, this.latestICached, this.emojiCacheStrategy = CacheStrategy.whenLaunch, this.latestEmojiCached, this.metaChacheStrategy = CacheStrategy.whenOneDay, this.latestMetaCached, this.forceShowAd = false}): _reactions = reactions,_mutedReactions = mutedReactions,super._();
  factory _AccountSettings.fromJson(Map<String, dynamic> json) => _$AccountSettingsFromJson(json);

@override final  String userId;
@override final  String host;
 final  List<String> _reactions;
@override@JsonKey() List<String> get reactions {
  if (_reactions is EqualUnmodifiableListView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactions);
}

 final  List<String> _mutedReactions;
@override@JsonKey() List<String> get mutedReactions {
  if (_mutedReactions is EqualUnmodifiableListView) return _mutedReactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mutedReactions);
}

@override@JsonKey() final  NoteVisibility defaultNoteVisibility;
@override@JsonKey() final  bool defaultIsLocalOnly;
@override@JsonKey() final  ReactionAcceptance? defaultReactionAcceptance;
@override@JsonKey() final  CacheStrategy iCacheStrategy;
@override final  DateTime? latestICached;
@override@JsonKey() final  CacheStrategy emojiCacheStrategy;
@override final  DateTime? latestEmojiCached;
@override@JsonKey() final  CacheStrategy metaChacheStrategy;
@override final  DateTime? latestMetaCached;
@override@JsonKey() final  bool forceShowAd;

/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountSettingsCopyWith<_AccountSettings> get copyWith => __$AccountSettingsCopyWithImpl<_AccountSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountSettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other._reactions, _reactions)&&const DeepCollectionEquality().equals(other._mutedReactions, _mutedReactions)&&(identical(other.defaultNoteVisibility, defaultNoteVisibility) || other.defaultNoteVisibility == defaultNoteVisibility)&&(identical(other.defaultIsLocalOnly, defaultIsLocalOnly) || other.defaultIsLocalOnly == defaultIsLocalOnly)&&(identical(other.defaultReactionAcceptance, defaultReactionAcceptance) || other.defaultReactionAcceptance == defaultReactionAcceptance)&&(identical(other.iCacheStrategy, iCacheStrategy) || other.iCacheStrategy == iCacheStrategy)&&(identical(other.latestICached, latestICached) || other.latestICached == latestICached)&&(identical(other.emojiCacheStrategy, emojiCacheStrategy) || other.emojiCacheStrategy == emojiCacheStrategy)&&(identical(other.latestEmojiCached, latestEmojiCached) || other.latestEmojiCached == latestEmojiCached)&&(identical(other.metaChacheStrategy, metaChacheStrategy) || other.metaChacheStrategy == metaChacheStrategy)&&(identical(other.latestMetaCached, latestMetaCached) || other.latestMetaCached == latestMetaCached)&&(identical(other.forceShowAd, forceShowAd) || other.forceShowAd == forceShowAd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,host,const DeepCollectionEquality().hash(_reactions),const DeepCollectionEquality().hash(_mutedReactions),defaultNoteVisibility,defaultIsLocalOnly,defaultReactionAcceptance,iCacheStrategy,latestICached,emojiCacheStrategy,latestEmojiCached,metaChacheStrategy,latestMetaCached,forceShowAd);

@override
String toString() {
  return 'AccountSettings(userId: $userId, host: $host, reactions: $reactions, mutedReactions: $mutedReactions, defaultNoteVisibility: $defaultNoteVisibility, defaultIsLocalOnly: $defaultIsLocalOnly, defaultReactionAcceptance: $defaultReactionAcceptance, iCacheStrategy: $iCacheStrategy, latestICached: $latestICached, emojiCacheStrategy: $emojiCacheStrategy, latestEmojiCached: $latestEmojiCached, metaChacheStrategy: $metaChacheStrategy, latestMetaCached: $latestMetaCached, forceShowAd: $forceShowAd)';
}


}

/// @nodoc
abstract mixin class _$AccountSettingsCopyWith<$Res> implements $AccountSettingsCopyWith<$Res> {
  factory _$AccountSettingsCopyWith(_AccountSettings value, $Res Function(_AccountSettings) _then) = __$AccountSettingsCopyWithImpl;
@override @useResult
$Res call({
 String userId, String host, List<String> reactions, List<String> mutedReactions, NoteVisibility defaultNoteVisibility, bool defaultIsLocalOnly, ReactionAcceptance? defaultReactionAcceptance, CacheStrategy iCacheStrategy, DateTime? latestICached, CacheStrategy emojiCacheStrategy, DateTime? latestEmojiCached, CacheStrategy metaChacheStrategy, DateTime? latestMetaCached, bool forceShowAd
});




}
/// @nodoc
class __$AccountSettingsCopyWithImpl<$Res>
    implements _$AccountSettingsCopyWith<$Res> {
  __$AccountSettingsCopyWithImpl(this._self, this._then);

  final _AccountSettings _self;
  final $Res Function(_AccountSettings) _then;

/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? host = null,Object? reactions = null,Object? mutedReactions = null,Object? defaultNoteVisibility = null,Object? defaultIsLocalOnly = null,Object? defaultReactionAcceptance = freezed,Object? iCacheStrategy = null,Object? latestICached = freezed,Object? emojiCacheStrategy = null,Object? latestEmojiCached = freezed,Object? metaChacheStrategy = null,Object? latestMetaCached = freezed,Object? forceShowAd = null,}) {
  return _then(_AccountSettings(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<String>,mutedReactions: null == mutedReactions ? _self._mutedReactions : mutedReactions // ignore: cast_nullable_to_non_nullable
as List<String>,defaultNoteVisibility: null == defaultNoteVisibility ? _self.defaultNoteVisibility : defaultNoteVisibility // ignore: cast_nullable_to_non_nullable
as NoteVisibility,defaultIsLocalOnly: null == defaultIsLocalOnly ? _self.defaultIsLocalOnly : defaultIsLocalOnly // ignore: cast_nullable_to_non_nullable
as bool,defaultReactionAcceptance: freezed == defaultReactionAcceptance ? _self.defaultReactionAcceptance : defaultReactionAcceptance // ignore: cast_nullable_to_non_nullable
as ReactionAcceptance?,iCacheStrategy: null == iCacheStrategy ? _self.iCacheStrategy : iCacheStrategy // ignore: cast_nullable_to_non_nullable
as CacheStrategy,latestICached: freezed == latestICached ? _self.latestICached : latestICached // ignore: cast_nullable_to_non_nullable
as DateTime?,emojiCacheStrategy: null == emojiCacheStrategy ? _self.emojiCacheStrategy : emojiCacheStrategy // ignore: cast_nullable_to_non_nullable
as CacheStrategy,latestEmojiCached: freezed == latestEmojiCached ? _self.latestEmojiCached : latestEmojiCached // ignore: cast_nullable_to_non_nullable
as DateTime?,metaChacheStrategy: null == metaChacheStrategy ? _self.metaChacheStrategy : metaChacheStrategy // ignore: cast_nullable_to_non_nullable
as CacheStrategy,latestMetaCached: freezed == latestMetaCached ? _self.latestMetaCached : latestMetaCached // ignore: cast_nullable_to_non_nullable
as DateTime?,forceShowAd: null == forceShowAd ? _self.forceShowAd : forceShowAd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
