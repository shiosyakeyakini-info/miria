// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aiscript_plugin_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiScriptPluginState {

 List<AiScriptPlugin> get plugins; List<PluginAction> get noteActions; List<PluginAction> get userActions; List<PluginPostFormAction> get postFormActions; List<PluginInterruptor> get noteViewInterruptors; List<PluginInterruptor> get notePostInterruptors; List<PluginInterruptor> get pageViewInterruptors;/// プラグインごとの `<:` 出力とエラー。設定画面で見る。
 Map<String, List<String>> get logs;
/// Create a copy of AiScriptPluginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiScriptPluginStateCopyWith<AiScriptPluginState> get copyWith => _$AiScriptPluginStateCopyWithImpl<AiScriptPluginState>(this as AiScriptPluginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiScriptPluginState&&const DeepCollectionEquality().equals(other.plugins, plugins)&&const DeepCollectionEquality().equals(other.noteActions, noteActions)&&const DeepCollectionEquality().equals(other.userActions, userActions)&&const DeepCollectionEquality().equals(other.postFormActions, postFormActions)&&const DeepCollectionEquality().equals(other.noteViewInterruptors, noteViewInterruptors)&&const DeepCollectionEquality().equals(other.notePostInterruptors, notePostInterruptors)&&const DeepCollectionEquality().equals(other.pageViewInterruptors, pageViewInterruptors)&&const DeepCollectionEquality().equals(other.logs, logs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(plugins),const DeepCollectionEquality().hash(noteActions),const DeepCollectionEquality().hash(userActions),const DeepCollectionEquality().hash(postFormActions),const DeepCollectionEquality().hash(noteViewInterruptors),const DeepCollectionEquality().hash(notePostInterruptors),const DeepCollectionEquality().hash(pageViewInterruptors),const DeepCollectionEquality().hash(logs));

@override
String toString() {
  return 'AiScriptPluginState(plugins: $plugins, noteActions: $noteActions, userActions: $userActions, postFormActions: $postFormActions, noteViewInterruptors: $noteViewInterruptors, notePostInterruptors: $notePostInterruptors, pageViewInterruptors: $pageViewInterruptors, logs: $logs)';
}


}

/// @nodoc
abstract mixin class $AiScriptPluginStateCopyWith<$Res>  {
  factory $AiScriptPluginStateCopyWith(AiScriptPluginState value, $Res Function(AiScriptPluginState) _then) = _$AiScriptPluginStateCopyWithImpl;
@useResult
$Res call({
 List<AiScriptPlugin> plugins, List<PluginAction> noteActions, List<PluginAction> userActions, List<PluginPostFormAction> postFormActions, List<PluginInterruptor> noteViewInterruptors, List<PluginInterruptor> notePostInterruptors, List<PluginInterruptor> pageViewInterruptors, Map<String, List<String>> logs
});




}
/// @nodoc
class _$AiScriptPluginStateCopyWithImpl<$Res>
    implements $AiScriptPluginStateCopyWith<$Res> {
  _$AiScriptPluginStateCopyWithImpl(this._self, this._then);

  final AiScriptPluginState _self;
  final $Res Function(AiScriptPluginState) _then;

/// Create a copy of AiScriptPluginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plugins = null,Object? noteActions = null,Object? userActions = null,Object? postFormActions = null,Object? noteViewInterruptors = null,Object? notePostInterruptors = null,Object? pageViewInterruptors = null,Object? logs = null,}) {
  return _then(_self.copyWith(
plugins: null == plugins ? _self.plugins : plugins // ignore: cast_nullable_to_non_nullable
as List<AiScriptPlugin>,noteActions: null == noteActions ? _self.noteActions : noteActions // ignore: cast_nullable_to_non_nullable
as List<PluginAction>,userActions: null == userActions ? _self.userActions : userActions // ignore: cast_nullable_to_non_nullable
as List<PluginAction>,postFormActions: null == postFormActions ? _self.postFormActions : postFormActions // ignore: cast_nullable_to_non_nullable
as List<PluginPostFormAction>,noteViewInterruptors: null == noteViewInterruptors ? _self.noteViewInterruptors : noteViewInterruptors // ignore: cast_nullable_to_non_nullable
as List<PluginInterruptor>,notePostInterruptors: null == notePostInterruptors ? _self.notePostInterruptors : notePostInterruptors // ignore: cast_nullable_to_non_nullable
as List<PluginInterruptor>,pageViewInterruptors: null == pageViewInterruptors ? _self.pageViewInterruptors : pageViewInterruptors // ignore: cast_nullable_to_non_nullable
as List<PluginInterruptor>,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiScriptPluginState].
extension AiScriptPluginStatePatterns on AiScriptPluginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiScriptPluginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiScriptPluginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiScriptPluginState value)  $default,){
final _that = this;
switch (_that) {
case _AiScriptPluginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiScriptPluginState value)?  $default,){
final _that = this;
switch (_that) {
case _AiScriptPluginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AiScriptPlugin> plugins,  List<PluginAction> noteActions,  List<PluginAction> userActions,  List<PluginPostFormAction> postFormActions,  List<PluginInterruptor> noteViewInterruptors,  List<PluginInterruptor> notePostInterruptors,  List<PluginInterruptor> pageViewInterruptors,  Map<String, List<String>> logs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiScriptPluginState() when $default != null:
return $default(_that.plugins,_that.noteActions,_that.userActions,_that.postFormActions,_that.noteViewInterruptors,_that.notePostInterruptors,_that.pageViewInterruptors,_that.logs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AiScriptPlugin> plugins,  List<PluginAction> noteActions,  List<PluginAction> userActions,  List<PluginPostFormAction> postFormActions,  List<PluginInterruptor> noteViewInterruptors,  List<PluginInterruptor> notePostInterruptors,  List<PluginInterruptor> pageViewInterruptors,  Map<String, List<String>> logs)  $default,) {final _that = this;
switch (_that) {
case _AiScriptPluginState():
return $default(_that.plugins,_that.noteActions,_that.userActions,_that.postFormActions,_that.noteViewInterruptors,_that.notePostInterruptors,_that.pageViewInterruptors,_that.logs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AiScriptPlugin> plugins,  List<PluginAction> noteActions,  List<PluginAction> userActions,  List<PluginPostFormAction> postFormActions,  List<PluginInterruptor> noteViewInterruptors,  List<PluginInterruptor> notePostInterruptors,  List<PluginInterruptor> pageViewInterruptors,  Map<String, List<String>> logs)?  $default,) {final _that = this;
switch (_that) {
case _AiScriptPluginState() when $default != null:
return $default(_that.plugins,_that.noteActions,_that.userActions,_that.postFormActions,_that.noteViewInterruptors,_that.notePostInterruptors,_that.pageViewInterruptors,_that.logs);case _:
  return null;

}
}

}

/// @nodoc


class _AiScriptPluginState implements AiScriptPluginState {
  const _AiScriptPluginState({final  List<AiScriptPlugin> plugins = const <AiScriptPlugin>[], final  List<PluginAction> noteActions = const <PluginAction>[], final  List<PluginAction> userActions = const <PluginAction>[], final  List<PluginPostFormAction> postFormActions = const <PluginPostFormAction>[], final  List<PluginInterruptor> noteViewInterruptors = const <PluginInterruptor>[], final  List<PluginInterruptor> notePostInterruptors = const <PluginInterruptor>[], final  List<PluginInterruptor> pageViewInterruptors = const <PluginInterruptor>[], final  Map<String, List<String>> logs = const <String, List<String>>{}}): _plugins = plugins,_noteActions = noteActions,_userActions = userActions,_postFormActions = postFormActions,_noteViewInterruptors = noteViewInterruptors,_notePostInterruptors = notePostInterruptors,_pageViewInterruptors = pageViewInterruptors,_logs = logs;
  

 final  List<AiScriptPlugin> _plugins;
@override@JsonKey() List<AiScriptPlugin> get plugins {
  if (_plugins is EqualUnmodifiableListView) return _plugins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plugins);
}

 final  List<PluginAction> _noteActions;
@override@JsonKey() List<PluginAction> get noteActions {
  if (_noteActions is EqualUnmodifiableListView) return _noteActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noteActions);
}

 final  List<PluginAction> _userActions;
@override@JsonKey() List<PluginAction> get userActions {
  if (_userActions is EqualUnmodifiableListView) return _userActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userActions);
}

 final  List<PluginPostFormAction> _postFormActions;
@override@JsonKey() List<PluginPostFormAction> get postFormActions {
  if (_postFormActions is EqualUnmodifiableListView) return _postFormActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postFormActions);
}

 final  List<PluginInterruptor> _noteViewInterruptors;
@override@JsonKey() List<PluginInterruptor> get noteViewInterruptors {
  if (_noteViewInterruptors is EqualUnmodifiableListView) return _noteViewInterruptors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noteViewInterruptors);
}

 final  List<PluginInterruptor> _notePostInterruptors;
@override@JsonKey() List<PluginInterruptor> get notePostInterruptors {
  if (_notePostInterruptors is EqualUnmodifiableListView) return _notePostInterruptors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notePostInterruptors);
}

 final  List<PluginInterruptor> _pageViewInterruptors;
@override@JsonKey() List<PluginInterruptor> get pageViewInterruptors {
  if (_pageViewInterruptors is EqualUnmodifiableListView) return _pageViewInterruptors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pageViewInterruptors);
}

/// プラグインごとの `<:` 出力とエラー。設定画面で見る。
 final  Map<String, List<String>> _logs;
/// プラグインごとの `<:` 出力とエラー。設定画面で見る。
@override@JsonKey() Map<String, List<String>> get logs {
  if (_logs is EqualUnmodifiableMapView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_logs);
}


/// Create a copy of AiScriptPluginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiScriptPluginStateCopyWith<_AiScriptPluginState> get copyWith => __$AiScriptPluginStateCopyWithImpl<_AiScriptPluginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiScriptPluginState&&const DeepCollectionEquality().equals(other._plugins, _plugins)&&const DeepCollectionEquality().equals(other._noteActions, _noteActions)&&const DeepCollectionEquality().equals(other._userActions, _userActions)&&const DeepCollectionEquality().equals(other._postFormActions, _postFormActions)&&const DeepCollectionEquality().equals(other._noteViewInterruptors, _noteViewInterruptors)&&const DeepCollectionEquality().equals(other._notePostInterruptors, _notePostInterruptors)&&const DeepCollectionEquality().equals(other._pageViewInterruptors, _pageViewInterruptors)&&const DeepCollectionEquality().equals(other._logs, _logs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_plugins),const DeepCollectionEquality().hash(_noteActions),const DeepCollectionEquality().hash(_userActions),const DeepCollectionEquality().hash(_postFormActions),const DeepCollectionEquality().hash(_noteViewInterruptors),const DeepCollectionEquality().hash(_notePostInterruptors),const DeepCollectionEquality().hash(_pageViewInterruptors),const DeepCollectionEquality().hash(_logs));

@override
String toString() {
  return 'AiScriptPluginState(plugins: $plugins, noteActions: $noteActions, userActions: $userActions, postFormActions: $postFormActions, noteViewInterruptors: $noteViewInterruptors, notePostInterruptors: $notePostInterruptors, pageViewInterruptors: $pageViewInterruptors, logs: $logs)';
}


}

/// @nodoc
abstract mixin class _$AiScriptPluginStateCopyWith<$Res> implements $AiScriptPluginStateCopyWith<$Res> {
  factory _$AiScriptPluginStateCopyWith(_AiScriptPluginState value, $Res Function(_AiScriptPluginState) _then) = __$AiScriptPluginStateCopyWithImpl;
@override @useResult
$Res call({
 List<AiScriptPlugin> plugins, List<PluginAction> noteActions, List<PluginAction> userActions, List<PluginPostFormAction> postFormActions, List<PluginInterruptor> noteViewInterruptors, List<PluginInterruptor> notePostInterruptors, List<PluginInterruptor> pageViewInterruptors, Map<String, List<String>> logs
});




}
/// @nodoc
class __$AiScriptPluginStateCopyWithImpl<$Res>
    implements _$AiScriptPluginStateCopyWith<$Res> {
  __$AiScriptPluginStateCopyWithImpl(this._self, this._then);

  final _AiScriptPluginState _self;
  final $Res Function(_AiScriptPluginState) _then;

/// Create a copy of AiScriptPluginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plugins = null,Object? noteActions = null,Object? userActions = null,Object? postFormActions = null,Object? noteViewInterruptors = null,Object? notePostInterruptors = null,Object? pageViewInterruptors = null,Object? logs = null,}) {
  return _then(_AiScriptPluginState(
plugins: null == plugins ? _self._plugins : plugins // ignore: cast_nullable_to_non_nullable
as List<AiScriptPlugin>,noteActions: null == noteActions ? _self._noteActions : noteActions // ignore: cast_nullable_to_non_nullable
as List<PluginAction>,userActions: null == userActions ? _self._userActions : userActions // ignore: cast_nullable_to_non_nullable
as List<PluginAction>,postFormActions: null == postFormActions ? _self._postFormActions : postFormActions // ignore: cast_nullable_to_non_nullable
as List<PluginPostFormAction>,noteViewInterruptors: null == noteViewInterruptors ? _self._noteViewInterruptors : noteViewInterruptors // ignore: cast_nullable_to_non_nullable
as List<PluginInterruptor>,notePostInterruptors: null == notePostInterruptors ? _self._notePostInterruptors : notePostInterruptors // ignore: cast_nullable_to_non_nullable
as List<PluginInterruptor>,pageViewInterruptors: null == pageViewInterruptors ? _self._pageViewInterruptors : pageViewInterruptors // ignore: cast_nullable_to_non_nullable
as List<PluginInterruptor>,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}


}

// dart format on
