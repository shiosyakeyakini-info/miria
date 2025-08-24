// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerPresets {

@JsonKey(fromJson: _limitedApiServersFromJson) List<String> get limitedApiServers; List<TimelinePreset> get particularTimelinePresets;
/// Create a copy of ServerPresets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerPresetsCopyWith<ServerPresets> get copyWith => _$ServerPresetsCopyWithImpl<ServerPresets>(this as ServerPresets, _$identity);

  /// Serializes this ServerPresets to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerPresets&&const DeepCollectionEquality().equals(other.limitedApiServers, limitedApiServers)&&const DeepCollectionEquality().equals(other.particularTimelinePresets, particularTimelinePresets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(limitedApiServers),const DeepCollectionEquality().hash(particularTimelinePresets));

@override
String toString() {
  return 'ServerPresets(limitedApiServers: $limitedApiServers, particularTimelinePresets: $particularTimelinePresets)';
}


}

/// @nodoc
abstract mixin class $ServerPresetsCopyWith<$Res>  {
  factory $ServerPresetsCopyWith(ServerPresets value, $Res Function(ServerPresets) _then) = _$ServerPresetsCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _limitedApiServersFromJson) List<String> limitedApiServers, List<TimelinePreset> particularTimelinePresets
});




}
/// @nodoc
class _$ServerPresetsCopyWithImpl<$Res>
    implements $ServerPresetsCopyWith<$Res> {
  _$ServerPresetsCopyWithImpl(this._self, this._then);

  final ServerPresets _self;
  final $Res Function(ServerPresets) _then;

/// Create a copy of ServerPresets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limitedApiServers = null,Object? particularTimelinePresets = null,}) {
  return _then(_self.copyWith(
limitedApiServers: null == limitedApiServers ? _self.limitedApiServers : limitedApiServers // ignore: cast_nullable_to_non_nullable
as List<String>,particularTimelinePresets: null == particularTimelinePresets ? _self.particularTimelinePresets : particularTimelinePresets // ignore: cast_nullable_to_non_nullable
as List<TimelinePreset>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerPresets].
extension ServerPresetsPatterns on ServerPresets {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerPresets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerPresets() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerPresets value)  $default,){
final _that = this;
switch (_that) {
case _ServerPresets():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerPresets value)?  $default,){
final _that = this;
switch (_that) {
case _ServerPresets() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _limitedApiServersFromJson)  List<String> limitedApiServers,  List<TimelinePreset> particularTimelinePresets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerPresets() when $default != null:
return $default(_that.limitedApiServers,_that.particularTimelinePresets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _limitedApiServersFromJson)  List<String> limitedApiServers,  List<TimelinePreset> particularTimelinePresets)  $default,) {final _that = this;
switch (_that) {
case _ServerPresets():
return $default(_that.limitedApiServers,_that.particularTimelinePresets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _limitedApiServersFromJson)  List<String> limitedApiServers,  List<TimelinePreset> particularTimelinePresets)?  $default,) {final _that = this;
switch (_that) {
case _ServerPresets() when $default != null:
return $default(_that.limitedApiServers,_that.particularTimelinePresets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerPresets implements ServerPresets {
  const _ServerPresets({@JsonKey(fromJson: _limitedApiServersFromJson) final  List<String> limitedApiServers = const [], final  List<TimelinePreset> particularTimelinePresets = const []}): _limitedApiServers = limitedApiServers,_particularTimelinePresets = particularTimelinePresets;
  factory _ServerPresets.fromJson(Map<String, dynamic> json) => _$ServerPresetsFromJson(json);

 final  List<String> _limitedApiServers;
@override@JsonKey(fromJson: _limitedApiServersFromJson) List<String> get limitedApiServers {
  if (_limitedApiServers is EqualUnmodifiableListView) return _limitedApiServers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_limitedApiServers);
}

 final  List<TimelinePreset> _particularTimelinePresets;
@override@JsonKey() List<TimelinePreset> get particularTimelinePresets {
  if (_particularTimelinePresets is EqualUnmodifiableListView) return _particularTimelinePresets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_particularTimelinePresets);
}


/// Create a copy of ServerPresets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerPresetsCopyWith<_ServerPresets> get copyWith => __$ServerPresetsCopyWithImpl<_ServerPresets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerPresetsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerPresets&&const DeepCollectionEquality().equals(other._limitedApiServers, _limitedApiServers)&&const DeepCollectionEquality().equals(other._particularTimelinePresets, _particularTimelinePresets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_limitedApiServers),const DeepCollectionEquality().hash(_particularTimelinePresets));

@override
String toString() {
  return 'ServerPresets(limitedApiServers: $limitedApiServers, particularTimelinePresets: $particularTimelinePresets)';
}


}

/// @nodoc
abstract mixin class _$ServerPresetsCopyWith<$Res> implements $ServerPresetsCopyWith<$Res> {
  factory _$ServerPresetsCopyWith(_ServerPresets value, $Res Function(_ServerPresets) _then) = __$ServerPresetsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _limitedApiServersFromJson) List<String> limitedApiServers, List<TimelinePreset> particularTimelinePresets
});




}
/// @nodoc
class __$ServerPresetsCopyWithImpl<$Res>
    implements _$ServerPresetsCopyWith<$Res> {
  __$ServerPresetsCopyWithImpl(this._self, this._then);

  final _ServerPresets _self;
  final $Res Function(_ServerPresets) _then;

/// Create a copy of ServerPresets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? limitedApiServers = null,Object? particularTimelinePresets = null,}) {
  return _then(_ServerPresets(
limitedApiServers: null == limitedApiServers ? _self._limitedApiServers : limitedApiServers // ignore: cast_nullable_to_non_nullable
as List<String>,particularTimelinePresets: null == particularTimelinePresets ? _self._particularTimelinePresets : particularTimelinePresets // ignore: cast_nullable_to_non_nullable
as List<TimelinePreset>,
  ));
}


}


/// @nodoc
mixin _$TimelinePreset {

 String get host; String get name; String get endpoint; String get websocketChannelName;@JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson) Map<String, dynamic> get parameters;
/// Create a copy of TimelinePreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelinePresetCopyWith<TimelinePreset> get copyWith => _$TimelinePresetCopyWithImpl<TimelinePreset>(this as TimelinePreset, _$identity);

  /// Serializes this TimelinePreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelinePreset&&(identical(other.host, host) || other.host == host)&&(identical(other.name, name) || other.name == name)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.websocketChannelName, websocketChannelName) || other.websocketChannelName == websocketChannelName)&&const DeepCollectionEquality().equals(other.parameters, parameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,host,name,endpoint,websocketChannelName,const DeepCollectionEquality().hash(parameters));

@override
String toString() {
  return 'TimelinePreset(host: $host, name: $name, endpoint: $endpoint, websocketChannelName: $websocketChannelName, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class $TimelinePresetCopyWith<$Res>  {
  factory $TimelinePresetCopyWith(TimelinePreset value, $Res Function(TimelinePreset) _then) = _$TimelinePresetCopyWithImpl;
@useResult
$Res call({
 String host, String name, String endpoint, String websocketChannelName,@JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson) Map<String, dynamic> parameters
});




}
/// @nodoc
class _$TimelinePresetCopyWithImpl<$Res>
    implements $TimelinePresetCopyWith<$Res> {
  _$TimelinePresetCopyWithImpl(this._self, this._then);

  final TimelinePreset _self;
  final $Res Function(TimelinePreset) _then;

/// Create a copy of TimelinePreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,Object? name = null,Object? endpoint = null,Object? websocketChannelName = null,Object? parameters = null,}) {
  return _then(_self.copyWith(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,websocketChannelName: null == websocketChannelName ? _self.websocketChannelName : websocketChannelName // ignore: cast_nullable_to_non_nullable
as String,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelinePreset].
extension TimelinePresetPatterns on TimelinePreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelinePreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelinePreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelinePreset value)  $default,){
final _that = this;
switch (_that) {
case _TimelinePreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelinePreset value)?  $default,){
final _that = this;
switch (_that) {
case _TimelinePreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String host,  String name,  String endpoint,  String websocketChannelName, @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)  Map<String, dynamic> parameters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelinePreset() when $default != null:
return $default(_that.host,_that.name,_that.endpoint,_that.websocketChannelName,_that.parameters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String host,  String name,  String endpoint,  String websocketChannelName, @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)  Map<String, dynamic> parameters)  $default,) {final _that = this;
switch (_that) {
case _TimelinePreset():
return $default(_that.host,_that.name,_that.endpoint,_that.websocketChannelName,_that.parameters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String host,  String name,  String endpoint,  String websocketChannelName, @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)  Map<String, dynamic> parameters)?  $default,) {final _that = this;
switch (_that) {
case _TimelinePreset() when $default != null:
return $default(_that.host,_that.name,_that.endpoint,_that.websocketChannelName,_that.parameters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimelinePreset implements TimelinePreset {
  const _TimelinePreset({required this.host, required this.name, required this.endpoint, required this.websocketChannelName, @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson) final  Map<String, dynamic> parameters = const <String, dynamic>{}}): _parameters = parameters;
  factory _TimelinePreset.fromJson(Map<String, dynamic> json) => _$TimelinePresetFromJson(json);

@override final  String host;
@override final  String name;
@override final  String endpoint;
@override final  String websocketChannelName;
 final  Map<String, dynamic> _parameters;
@override@JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson) Map<String, dynamic> get parameters {
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parameters);
}


/// Create a copy of TimelinePreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelinePresetCopyWith<_TimelinePreset> get copyWith => __$TimelinePresetCopyWithImpl<_TimelinePreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimelinePresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelinePreset&&(identical(other.host, host) || other.host == host)&&(identical(other.name, name) || other.name == name)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.websocketChannelName, websocketChannelName) || other.websocketChannelName == websocketChannelName)&&const DeepCollectionEquality().equals(other._parameters, _parameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,host,name,endpoint,websocketChannelName,const DeepCollectionEquality().hash(_parameters));

@override
String toString() {
  return 'TimelinePreset(host: $host, name: $name, endpoint: $endpoint, websocketChannelName: $websocketChannelName, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class _$TimelinePresetCopyWith<$Res> implements $TimelinePresetCopyWith<$Res> {
  factory _$TimelinePresetCopyWith(_TimelinePreset value, $Res Function(_TimelinePreset) _then) = __$TimelinePresetCopyWithImpl;
@override @useResult
$Res call({
 String host, String name, String endpoint, String websocketChannelName,@JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson) Map<String, dynamic> parameters
});




}
/// @nodoc
class __$TimelinePresetCopyWithImpl<$Res>
    implements _$TimelinePresetCopyWith<$Res> {
  __$TimelinePresetCopyWithImpl(this._self, this._then);

  final _TimelinePreset _self;
  final $Res Function(_TimelinePreset) _then;

/// Create a copy of TimelinePreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,Object? name = null,Object? endpoint = null,Object? websocketChannelName = null,Object? parameters = null,}) {
  return _then(_TimelinePreset(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,websocketChannelName: null == websocketChannelName ? _self.websocketChannelName : websocketChannelName // ignore: cast_nullable_to_non_nullable
as String,parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
