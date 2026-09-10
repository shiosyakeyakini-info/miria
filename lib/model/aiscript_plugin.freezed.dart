// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aiscript_plugin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiScriptPlugin {

/// 入れたときに振る識別子。同じプラグインを入れ直すと変わる。
 String get installId; String get name; String get version; String get author;/// AiScript のソース。
 String get src; String? get description;/// プラグインが要求する権限。miria はまだトークンを分けていないので、
/// 表示するだけで使っていない。
 List<String> get permissions;/// メタデータに書かれた設定の定義。`{ キー: { type, label, default } }`。
 Map<String, dynamic> get config;/// 利用者が設定した値。`Plugin:config` にはこれを混ぜたものが渡る。
 Map<String, dynamic> get configData; bool get active;
/// Create a copy of AiScriptPlugin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiScriptPluginCopyWith<AiScriptPlugin> get copyWith => _$AiScriptPluginCopyWithImpl<AiScriptPlugin>(this as AiScriptPlugin, _$identity);

  /// Serializes this AiScriptPlugin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiScriptPlugin&&(identical(other.installId, installId) || other.installId == installId)&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.author, author) || other.author == author)&&(identical(other.src, src) || other.src == src)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&const DeepCollectionEquality().equals(other.config, config)&&const DeepCollectionEquality().equals(other.configData, configData)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,installId,name,version,author,src,description,const DeepCollectionEquality().hash(permissions),const DeepCollectionEquality().hash(config),const DeepCollectionEquality().hash(configData),active);

@override
String toString() {
  return 'AiScriptPlugin(installId: $installId, name: $name, version: $version, author: $author, src: $src, description: $description, permissions: $permissions, config: $config, configData: $configData, active: $active)';
}


}

/// @nodoc
abstract mixin class $AiScriptPluginCopyWith<$Res>  {
  factory $AiScriptPluginCopyWith(AiScriptPlugin value, $Res Function(AiScriptPlugin) _then) = _$AiScriptPluginCopyWithImpl;
@useResult
$Res call({
 String installId, String name, String version, String author, String src, String? description, List<String> permissions, Map<String, dynamic> config, Map<String, dynamic> configData, bool active
});




}
/// @nodoc
class _$AiScriptPluginCopyWithImpl<$Res>
    implements $AiScriptPluginCopyWith<$Res> {
  _$AiScriptPluginCopyWithImpl(this._self, this._then);

  final AiScriptPlugin _self;
  final $Res Function(AiScriptPlugin) _then;

/// Create a copy of AiScriptPlugin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? installId = null,Object? name = null,Object? version = null,Object? author = null,Object? src = null,Object? description = freezed,Object? permissions = null,Object? config = null,Object? configData = null,Object? active = null,}) {
  return _then(_self.copyWith(
installId: null == installId ? _self.installId : installId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,configData: null == configData ? _self.configData : configData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiScriptPlugin].
extension AiScriptPluginPatterns on AiScriptPlugin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiScriptPlugin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiScriptPlugin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiScriptPlugin value)  $default,){
final _that = this;
switch (_that) {
case _AiScriptPlugin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiScriptPlugin value)?  $default,){
final _that = this;
switch (_that) {
case _AiScriptPlugin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String installId,  String name,  String version,  String author,  String src,  String? description,  List<String> permissions,  Map<String, dynamic> config,  Map<String, dynamic> configData,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiScriptPlugin() when $default != null:
return $default(_that.installId,_that.name,_that.version,_that.author,_that.src,_that.description,_that.permissions,_that.config,_that.configData,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String installId,  String name,  String version,  String author,  String src,  String? description,  List<String> permissions,  Map<String, dynamic> config,  Map<String, dynamic> configData,  bool active)  $default,) {final _that = this;
switch (_that) {
case _AiScriptPlugin():
return $default(_that.installId,_that.name,_that.version,_that.author,_that.src,_that.description,_that.permissions,_that.config,_that.configData,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String installId,  String name,  String version,  String author,  String src,  String? description,  List<String> permissions,  Map<String, dynamic> config,  Map<String, dynamic> configData,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _AiScriptPlugin() when $default != null:
return $default(_that.installId,_that.name,_that.version,_that.author,_that.src,_that.description,_that.permissions,_that.config,_that.configData,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiScriptPlugin extends AiScriptPlugin {
  const _AiScriptPlugin({required this.installId, required this.name, required this.version, required this.author, required this.src, this.description, final  List<String> permissions = const <String>[], final  Map<String, dynamic> config = const <String, dynamic>{}, final  Map<String, dynamic> configData = const <String, dynamic>{}, this.active = true}): _permissions = permissions,_config = config,_configData = configData,super._();
  factory _AiScriptPlugin.fromJson(Map<String, dynamic> json) => _$AiScriptPluginFromJson(json);

/// 入れたときに振る識別子。同じプラグインを入れ直すと変わる。
@override final  String installId;
@override final  String name;
@override final  String version;
@override final  String author;
/// AiScript のソース。
@override final  String src;
@override final  String? description;
/// プラグインが要求する権限。miria はまだトークンを分けていないので、
/// 表示するだけで使っていない。
 final  List<String> _permissions;
/// プラグインが要求する権限。miria はまだトークンを分けていないので、
/// 表示するだけで使っていない。
@override@JsonKey() List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

/// メタデータに書かれた設定の定義。`{ キー: { type, label, default } }`。
 final  Map<String, dynamic> _config;
/// メタデータに書かれた設定の定義。`{ キー: { type, label, default } }`。
@override@JsonKey() Map<String, dynamic> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}

/// 利用者が設定した値。`Plugin:config` にはこれを混ぜたものが渡る。
 final  Map<String, dynamic> _configData;
/// 利用者が設定した値。`Plugin:config` にはこれを混ぜたものが渡る。
@override@JsonKey() Map<String, dynamic> get configData {
  if (_configData is EqualUnmodifiableMapView) return _configData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_configData);
}

@override@JsonKey() final  bool active;

/// Create a copy of AiScriptPlugin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiScriptPluginCopyWith<_AiScriptPlugin> get copyWith => __$AiScriptPluginCopyWithImpl<_AiScriptPlugin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiScriptPluginToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiScriptPlugin&&(identical(other.installId, installId) || other.installId == installId)&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.author, author) || other.author == author)&&(identical(other.src, src) || other.src == src)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&const DeepCollectionEquality().equals(other._config, _config)&&const DeepCollectionEquality().equals(other._configData, _configData)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,installId,name,version,author,src,description,const DeepCollectionEquality().hash(_permissions),const DeepCollectionEquality().hash(_config),const DeepCollectionEquality().hash(_configData),active);

@override
String toString() {
  return 'AiScriptPlugin(installId: $installId, name: $name, version: $version, author: $author, src: $src, description: $description, permissions: $permissions, config: $config, configData: $configData, active: $active)';
}


}

/// @nodoc
abstract mixin class _$AiScriptPluginCopyWith<$Res> implements $AiScriptPluginCopyWith<$Res> {
  factory _$AiScriptPluginCopyWith(_AiScriptPlugin value, $Res Function(_AiScriptPlugin) _then) = __$AiScriptPluginCopyWithImpl;
@override @useResult
$Res call({
 String installId, String name, String version, String author, String src, String? description, List<String> permissions, Map<String, dynamic> config, Map<String, dynamic> configData, bool active
});




}
/// @nodoc
class __$AiScriptPluginCopyWithImpl<$Res>
    implements _$AiScriptPluginCopyWith<$Res> {
  __$AiScriptPluginCopyWithImpl(this._self, this._then);

  final _AiScriptPlugin _self;
  final $Res Function(_AiScriptPlugin) _then;

/// Create a copy of AiScriptPlugin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? installId = null,Object? name = null,Object? version = null,Object? author = null,Object? src = null,Object? description = freezed,Object? permissions = null,Object? config = null,Object? configData = null,Object? active = null,}) {
  return _then(_AiScriptPlugin(
installId: null == installId ? _self.installId : installId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,configData: null == configData ? _self._configData : configData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AiScriptPluginMeta {

 String get name; String get version; String get author; String? get description; List<String> get permissions; Map<String, dynamic> get config;
/// Create a copy of AiScriptPluginMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiScriptPluginMetaCopyWith<AiScriptPluginMeta> get copyWith => _$AiScriptPluginMetaCopyWithImpl<AiScriptPluginMeta>(this as AiScriptPluginMeta, _$identity);

  /// Serializes this AiScriptPluginMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiScriptPluginMeta&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&const DeepCollectionEquality().equals(other.config, config));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version,author,description,const DeepCollectionEquality().hash(permissions),const DeepCollectionEquality().hash(config));

@override
String toString() {
  return 'AiScriptPluginMeta(name: $name, version: $version, author: $author, description: $description, permissions: $permissions, config: $config)';
}


}

/// @nodoc
abstract mixin class $AiScriptPluginMetaCopyWith<$Res>  {
  factory $AiScriptPluginMetaCopyWith(AiScriptPluginMeta value, $Res Function(AiScriptPluginMeta) _then) = _$AiScriptPluginMetaCopyWithImpl;
@useResult
$Res call({
 String name, String version, String author, String? description, List<String> permissions, Map<String, dynamic> config
});




}
/// @nodoc
class _$AiScriptPluginMetaCopyWithImpl<$Res>
    implements $AiScriptPluginMetaCopyWith<$Res> {
  _$AiScriptPluginMetaCopyWithImpl(this._self, this._then);

  final AiScriptPluginMeta _self;
  final $Res Function(AiScriptPluginMeta) _then;

/// Create a copy of AiScriptPluginMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? version = null,Object? author = null,Object? description = freezed,Object? permissions = null,Object? config = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiScriptPluginMeta].
extension AiScriptPluginMetaPatterns on AiScriptPluginMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiScriptPluginMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiScriptPluginMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiScriptPluginMeta value)  $default,){
final _that = this;
switch (_that) {
case _AiScriptPluginMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiScriptPluginMeta value)?  $default,){
final _that = this;
switch (_that) {
case _AiScriptPluginMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String version,  String author,  String? description,  List<String> permissions,  Map<String, dynamic> config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiScriptPluginMeta() when $default != null:
return $default(_that.name,_that.version,_that.author,_that.description,_that.permissions,_that.config);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String version,  String author,  String? description,  List<String> permissions,  Map<String, dynamic> config)  $default,) {final _that = this;
switch (_that) {
case _AiScriptPluginMeta():
return $default(_that.name,_that.version,_that.author,_that.description,_that.permissions,_that.config);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String version,  String author,  String? description,  List<String> permissions,  Map<String, dynamic> config)?  $default,) {final _that = this;
switch (_that) {
case _AiScriptPluginMeta() when $default != null:
return $default(_that.name,_that.version,_that.author,_that.description,_that.permissions,_that.config);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiScriptPluginMeta implements AiScriptPluginMeta {
  const _AiScriptPluginMeta({required this.name, required this.version, required this.author, this.description, final  List<String> permissions = const <String>[], final  Map<String, dynamic> config = const <String, dynamic>{}}): _permissions = permissions,_config = config;
  factory _AiScriptPluginMeta.fromJson(Map<String, dynamic> json) => _$AiScriptPluginMetaFromJson(json);

@override final  String name;
@override final  String version;
@override final  String author;
@override final  String? description;
 final  List<String> _permissions;
@override@JsonKey() List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

 final  Map<String, dynamic> _config;
@override@JsonKey() Map<String, dynamic> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}


/// Create a copy of AiScriptPluginMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiScriptPluginMetaCopyWith<_AiScriptPluginMeta> get copyWith => __$AiScriptPluginMetaCopyWithImpl<_AiScriptPluginMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiScriptPluginMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiScriptPluginMeta&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&const DeepCollectionEquality().equals(other._config, _config));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version,author,description,const DeepCollectionEquality().hash(_permissions),const DeepCollectionEquality().hash(_config));

@override
String toString() {
  return 'AiScriptPluginMeta(name: $name, version: $version, author: $author, description: $description, permissions: $permissions, config: $config)';
}


}

/// @nodoc
abstract mixin class _$AiScriptPluginMetaCopyWith<$Res> implements $AiScriptPluginMetaCopyWith<$Res> {
  factory _$AiScriptPluginMetaCopyWith(_AiScriptPluginMeta value, $Res Function(_AiScriptPluginMeta) _then) = __$AiScriptPluginMetaCopyWithImpl;
@override @useResult
$Res call({
 String name, String version, String author, String? description, List<String> permissions, Map<String, dynamic> config
});




}
/// @nodoc
class __$AiScriptPluginMetaCopyWithImpl<$Res>
    implements _$AiScriptPluginMetaCopyWith<$Res> {
  __$AiScriptPluginMetaCopyWithImpl(this._self, this._then);

  final _AiScriptPluginMeta _self;
  final $Res Function(_AiScriptPluginMeta) _then;

/// Create a copy of AiScriptPluginMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? version = null,Object? author = null,Object? description = freezed,Object? permissions = null,Object? config = null,}) {
  return _then(_AiScriptPluginMeta(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
