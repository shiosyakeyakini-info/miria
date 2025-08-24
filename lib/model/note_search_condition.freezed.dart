// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_search_condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteSearchCondition {

 String? get query; User? get user; CommunityChannel? get channel; bool get localOnly;
/// Create a copy of NoteSearchCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteSearchConditionCopyWith<NoteSearchCondition> get copyWith => _$NoteSearchConditionCopyWithImpl<NoteSearchCondition>(this as NoteSearchCondition, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteSearchCondition&&(identical(other.query, query) || other.query == query)&&(identical(other.user, user) || other.user == user)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly));
}


@override
int get hashCode => Object.hash(runtimeType,query,user,channel,localOnly);

@override
String toString() {
  return 'NoteSearchCondition(query: $query, user: $user, channel: $channel, localOnly: $localOnly)';
}


}

/// @nodoc
abstract mixin class $NoteSearchConditionCopyWith<$Res>  {
  factory $NoteSearchConditionCopyWith(NoteSearchCondition value, $Res Function(NoteSearchCondition) _then) = _$NoteSearchConditionCopyWithImpl;
@useResult
$Res call({
 String? query, User? user, CommunityChannel? channel, bool localOnly
});


$CommunityChannelCopyWith<$Res>? get channel;

}
/// @nodoc
class _$NoteSearchConditionCopyWithImpl<$Res>
    implements $NoteSearchConditionCopyWith<$Res> {
  _$NoteSearchConditionCopyWithImpl(this._self, this._then);

  final NoteSearchCondition _self;
  final $Res Function(NoteSearchCondition) _then;

/// Create a copy of NoteSearchCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = freezed,Object? user = freezed,Object? channel = freezed,Object? localOnly = null,}) {
  return _then(_self.copyWith(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as CommunityChannel?,localOnly: null == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of NoteSearchCondition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityChannelCopyWith<$Res>? get channel {
    if (_self.channel == null) {
    return null;
  }

  return $CommunityChannelCopyWith<$Res>(_self.channel!, (value) {
    return _then(_self.copyWith(channel: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoteSearchCondition].
extension NoteSearchConditionPatterns on NoteSearchCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteSearchCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteSearchCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteSearchCondition value)  $default,){
final _that = this;
switch (_that) {
case _NoteSearchCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteSearchCondition value)?  $default,){
final _that = this;
switch (_that) {
case _NoteSearchCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? query,  User? user,  CommunityChannel? channel,  bool localOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteSearchCondition() when $default != null:
return $default(_that.query,_that.user,_that.channel,_that.localOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? query,  User? user,  CommunityChannel? channel,  bool localOnly)  $default,) {final _that = this;
switch (_that) {
case _NoteSearchCondition():
return $default(_that.query,_that.user,_that.channel,_that.localOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? query,  User? user,  CommunityChannel? channel,  bool localOnly)?  $default,) {final _that = this;
switch (_that) {
case _NoteSearchCondition() when $default != null:
return $default(_that.query,_that.user,_that.channel,_that.localOnly);case _:
  return null;

}
}

}

/// @nodoc


class _NoteSearchCondition extends NoteSearchCondition {
  const _NoteSearchCondition({this.query, this.user, this.channel, this.localOnly = false}): super._();
  

@override final  String? query;
@override final  User? user;
@override final  CommunityChannel? channel;
@override@JsonKey() final  bool localOnly;

/// Create a copy of NoteSearchCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteSearchConditionCopyWith<_NoteSearchCondition> get copyWith => __$NoteSearchConditionCopyWithImpl<_NoteSearchCondition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteSearchCondition&&(identical(other.query, query) || other.query == query)&&(identical(other.user, user) || other.user == user)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly));
}


@override
int get hashCode => Object.hash(runtimeType,query,user,channel,localOnly);

@override
String toString() {
  return 'NoteSearchCondition(query: $query, user: $user, channel: $channel, localOnly: $localOnly)';
}


}

/// @nodoc
abstract mixin class _$NoteSearchConditionCopyWith<$Res> implements $NoteSearchConditionCopyWith<$Res> {
  factory _$NoteSearchConditionCopyWith(_NoteSearchCondition value, $Res Function(_NoteSearchCondition) _then) = __$NoteSearchConditionCopyWithImpl;
@override @useResult
$Res call({
 String? query, User? user, CommunityChannel? channel, bool localOnly
});


@override $CommunityChannelCopyWith<$Res>? get channel;

}
/// @nodoc
class __$NoteSearchConditionCopyWithImpl<$Res>
    implements _$NoteSearchConditionCopyWith<$Res> {
  __$NoteSearchConditionCopyWithImpl(this._self, this._then);

  final _NoteSearchCondition _self;
  final $Res Function(_NoteSearchCondition) _then;

/// Create a copy of NoteSearchCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = freezed,Object? user = freezed,Object? channel = freezed,Object? localOnly = null,}) {
  return _then(_NoteSearchCondition(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as CommunityChannel?,localOnly: null == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of NoteSearchCondition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityChannelCopyWith<$Res>? get channel {
    if (_self.channel == null) {
    return null;
  }

  return $CommunityChannelCopyWith<$Res>(_self.channel!, (value) {
    return _then(_self.copyWith(channel: value));
  });
}
}

// dart format on
