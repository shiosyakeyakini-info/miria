// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DialogsState implements DiagnosticableTreeMixin {

 List<DialogData> get dialogs;
/// Create a copy of DialogsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogsStateCopyWith<DialogsState> get copyWith => _$DialogsStateCopyWithImpl<DialogsState>(this as DialogsState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DialogsState'))
    ..add(DiagnosticsProperty('dialogs', dialogs));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogsState&&const DeepCollectionEquality().equals(other.dialogs, dialogs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dialogs));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DialogsState(dialogs: $dialogs)';
}


}

/// @nodoc
abstract mixin class $DialogsStateCopyWith<$Res>  {
  factory $DialogsStateCopyWith(DialogsState value, $Res Function(DialogsState) _then) = _$DialogsStateCopyWithImpl;
@useResult
$Res call({
 List<DialogData> dialogs
});




}
/// @nodoc
class _$DialogsStateCopyWithImpl<$Res>
    implements $DialogsStateCopyWith<$Res> {
  _$DialogsStateCopyWithImpl(this._self, this._then);

  final DialogsState _self;
  final $Res Function(DialogsState) _then;

/// Create a copy of DialogsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dialogs = null,}) {
  return _then(_self.copyWith(
dialogs: null == dialogs ? _self.dialogs : dialogs // ignore: cast_nullable_to_non_nullable
as List<DialogData>,
  ));
}

}


/// Adds pattern-matching-related methods to [DialogsState].
extension DialogsStatePatterns on DialogsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogsState value)  $default,){
final _that = this;
switch (_that) {
case _DialogsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogsState value)?  $default,){
final _that = this;
switch (_that) {
case _DialogsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DialogData> dialogs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialogsState() when $default != null:
return $default(_that.dialogs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DialogData> dialogs)  $default,) {final _that = this;
switch (_that) {
case _DialogsState():
return $default(_that.dialogs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DialogData> dialogs)?  $default,) {final _that = this;
switch (_that) {
case _DialogsState() when $default != null:
return $default(_that.dialogs);case _:
  return null;

}
}

}

/// @nodoc


class _DialogsState with DiagnosticableTreeMixin implements DialogsState {
   _DialogsState({final  List<DialogData> dialogs = const []}): _dialogs = dialogs;
  

 final  List<DialogData> _dialogs;
@override@JsonKey() List<DialogData> get dialogs {
  if (_dialogs is EqualUnmodifiableListView) return _dialogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dialogs);
}


/// Create a copy of DialogsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogsStateCopyWith<_DialogsState> get copyWith => __$DialogsStateCopyWithImpl<_DialogsState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DialogsState'))
    ..add(DiagnosticsProperty('dialogs', dialogs));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogsState&&const DeepCollectionEquality().equals(other._dialogs, _dialogs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dialogs));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DialogsState(dialogs: $dialogs)';
}


}

/// @nodoc
abstract mixin class _$DialogsStateCopyWith<$Res> implements $DialogsStateCopyWith<$Res> {
  factory _$DialogsStateCopyWith(_DialogsState value, $Res Function(_DialogsState) _then) = __$DialogsStateCopyWithImpl;
@override @useResult
$Res call({
 List<DialogData> dialogs
});




}
/// @nodoc
class __$DialogsStateCopyWithImpl<$Res>
    implements _$DialogsStateCopyWith<$Res> {
  __$DialogsStateCopyWithImpl(this._self, this._then);

  final _DialogsState _self;
  final $Res Function(_DialogsState) _then;

/// Create a copy of DialogsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dialogs = null,}) {
  return _then(_DialogsState(
dialogs: null == dialogs ? _self._dialogs : dialogs // ignore: cast_nullable_to_non_nullable
as List<DialogData>,
  ));
}


}

/// @nodoc
mixin _$DialogData implements DiagnosticableTreeMixin {

 String Function(BuildContext context) get message; List<String> Function(BuildContext context) get actions; Completer<int> get completer;@Assert("!isMFM || isMFM && accountContext != null", "account context must not be null when isMFM is true") AccountContext? get accountContext; bool get isMFM;
/// Create a copy of DialogData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogDataCopyWith<DialogData> get copyWith => _$DialogDataCopyWithImpl<DialogData>(this as DialogData, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DialogData'))
    ..add(DiagnosticsProperty('message', message))..add(DiagnosticsProperty('actions', actions))..add(DiagnosticsProperty('completer', completer))..add(DiagnosticsProperty('accountContext', accountContext))..add(DiagnosticsProperty('isMFM', isMFM));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogData&&(identical(other.message, message) || other.message == message)&&(identical(other.actions, actions) || other.actions == actions)&&(identical(other.completer, completer) || other.completer == completer)&&(identical(other.accountContext, accountContext) || other.accountContext == accountContext)&&(identical(other.isMFM, isMFM) || other.isMFM == isMFM));
}


@override
int get hashCode => Object.hash(runtimeType,message,actions,completer,accountContext,isMFM);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DialogData(message: $message, actions: $actions, completer: $completer, accountContext: $accountContext, isMFM: $isMFM)';
}


}

/// @nodoc
abstract mixin class $DialogDataCopyWith<$Res>  {
  factory $DialogDataCopyWith(DialogData value, $Res Function(DialogData) _then) = _$DialogDataCopyWithImpl;
@useResult
$Res call({
 String Function(BuildContext context) message, List<String> Function(BuildContext context) actions, Completer<int> completer,@Assert("!isMFM || isMFM && accountContext != null", "account context must not be null when isMFM is true") AccountContext? accountContext, bool isMFM
});


$AccountContextCopyWith<$Res>? get accountContext;

}
/// @nodoc
class _$DialogDataCopyWithImpl<$Res>
    implements $DialogDataCopyWith<$Res> {
  _$DialogDataCopyWithImpl(this._self, this._then);

  final DialogData _self;
  final $Res Function(DialogData) _then;

/// Create a copy of DialogData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? actions = null,Object? completer = null,Object? accountContext = freezed,Object? isMFM = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String Function(BuildContext context),actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<String> Function(BuildContext context),completer: null == completer ? _self.completer : completer // ignore: cast_nullable_to_non_nullable
as Completer<int>,accountContext: freezed == accountContext ? _self.accountContext : accountContext // ignore: cast_nullable_to_non_nullable
as AccountContext?,isMFM: null == isMFM ? _self.isMFM : isMFM // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DialogData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountContextCopyWith<$Res>? get accountContext {
    if (_self.accountContext == null) {
    return null;
  }

  return $AccountContextCopyWith<$Res>(_self.accountContext!, (value) {
    return _then(_self.copyWith(accountContext: value));
  });
}
}


/// Adds pattern-matching-related methods to [DialogData].
extension DialogDataPatterns on DialogData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogData value)  $default,){
final _that = this;
switch (_that) {
case _DialogData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogData value)?  $default,){
final _that = this;
switch (_that) {
case _DialogData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String Function(BuildContext context) message,  List<String> Function(BuildContext context) actions,  Completer<int> completer, @Assert("!isMFM || isMFM && accountContext != null", "account context must not be null when isMFM is true")  AccountContext? accountContext,  bool isMFM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialogData() when $default != null:
return $default(_that.message,_that.actions,_that.completer,_that.accountContext,_that.isMFM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String Function(BuildContext context) message,  List<String> Function(BuildContext context) actions,  Completer<int> completer, @Assert("!isMFM || isMFM && accountContext != null", "account context must not be null when isMFM is true")  AccountContext? accountContext,  bool isMFM)  $default,) {final _that = this;
switch (_that) {
case _DialogData():
return $default(_that.message,_that.actions,_that.completer,_that.accountContext,_that.isMFM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String Function(BuildContext context) message,  List<String> Function(BuildContext context) actions,  Completer<int> completer, @Assert("!isMFM || isMFM && accountContext != null", "account context must not be null when isMFM is true")  AccountContext? accountContext,  bool isMFM)?  $default,) {final _that = this;
switch (_that) {
case _DialogData() when $default != null:
return $default(_that.message,_that.actions,_that.completer,_that.accountContext,_that.isMFM);case _:
  return null;

}
}

}

/// @nodoc


class _DialogData with DiagnosticableTreeMixin implements DialogData {
   _DialogData({required this.message, required this.actions, required this.completer, @Assert("!isMFM || isMFM && accountContext != null", "account context must not be null when isMFM is true") this.accountContext, this.isMFM = false});
  

@override final  String Function(BuildContext context) message;
@override final  List<String> Function(BuildContext context) actions;
@override final  Completer<int> completer;
@override@Assert("!isMFM || isMFM && accountContext != null", "account context must not be null when isMFM is true") final  AccountContext? accountContext;
@override@JsonKey() final  bool isMFM;

/// Create a copy of DialogData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogDataCopyWith<_DialogData> get copyWith => __$DialogDataCopyWithImpl<_DialogData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DialogData'))
    ..add(DiagnosticsProperty('message', message))..add(DiagnosticsProperty('actions', actions))..add(DiagnosticsProperty('completer', completer))..add(DiagnosticsProperty('accountContext', accountContext))..add(DiagnosticsProperty('isMFM', isMFM));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogData&&(identical(other.message, message) || other.message == message)&&(identical(other.actions, actions) || other.actions == actions)&&(identical(other.completer, completer) || other.completer == completer)&&(identical(other.accountContext, accountContext) || other.accountContext == accountContext)&&(identical(other.isMFM, isMFM) || other.isMFM == isMFM));
}


@override
int get hashCode => Object.hash(runtimeType,message,actions,completer,accountContext,isMFM);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DialogData(message: $message, actions: $actions, completer: $completer, accountContext: $accountContext, isMFM: $isMFM)';
}


}

/// @nodoc
abstract mixin class _$DialogDataCopyWith<$Res> implements $DialogDataCopyWith<$Res> {
  factory _$DialogDataCopyWith(_DialogData value, $Res Function(_DialogData) _then) = __$DialogDataCopyWithImpl;
@override @useResult
$Res call({
 String Function(BuildContext context) message, List<String> Function(BuildContext context) actions, Completer<int> completer,@Assert("!isMFM || isMFM && accountContext != null", "account context must not be null when isMFM is true") AccountContext? accountContext, bool isMFM
});


@override $AccountContextCopyWith<$Res>? get accountContext;

}
/// @nodoc
class __$DialogDataCopyWithImpl<$Res>
    implements _$DialogDataCopyWith<$Res> {
  __$DialogDataCopyWithImpl(this._self, this._then);

  final _DialogData _self;
  final $Res Function(_DialogData) _then;

/// Create a copy of DialogData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? actions = null,Object? completer = null,Object? accountContext = freezed,Object? isMFM = null,}) {
  return _then(_DialogData(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String Function(BuildContext context),actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<String> Function(BuildContext context),completer: null == completer ? _self.completer : completer // ignore: cast_nullable_to_non_nullable
as Completer<int>,accountContext: freezed == accountContext ? _self.accountContext : accountContext // ignore: cast_nullable_to_non_nullable
as AccountContext?,isMFM: null == isMFM ? _self.isMFM : isMFM // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DialogData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountContextCopyWith<$Res>? get accountContext {
    if (_self.accountContext == null) {
    return null;
  }

  return $AccountContextCopyWith<$Res>(_self.accountContext!, (value) {
    return _then(_self.copyWith(accountContext: value));
  });
}
}

// dart format on
