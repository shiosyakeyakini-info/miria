// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_chat_message_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PendingChatMessage {

 String get tempId; String get text; DateTime get createdAt; String? get fileId;
/// Create a copy of PendingChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingChatMessageCopyWith<PendingChatMessage> get copyWith => _$PendingChatMessageCopyWithImpl<PendingChatMessage>(this as PendingChatMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingChatMessage&&(identical(other.tempId, tempId) || other.tempId == tempId)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fileId, fileId) || other.fileId == fileId));
}


@override
int get hashCode => Object.hash(runtimeType,tempId,text,createdAt,fileId);

@override
String toString() {
  return 'PendingChatMessage(tempId: $tempId, text: $text, createdAt: $createdAt, fileId: $fileId)';
}


}

/// @nodoc
abstract mixin class $PendingChatMessageCopyWith<$Res>  {
  factory $PendingChatMessageCopyWith(PendingChatMessage value, $Res Function(PendingChatMessage) _then) = _$PendingChatMessageCopyWithImpl;
@useResult
$Res call({
 String tempId, String text, DateTime createdAt, String? fileId
});




}
/// @nodoc
class _$PendingChatMessageCopyWithImpl<$Res>
    implements $PendingChatMessageCopyWith<$Res> {
  _$PendingChatMessageCopyWithImpl(this._self, this._then);

  final PendingChatMessage _self;
  final $Res Function(PendingChatMessage) _then;

/// Create a copy of PendingChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tempId = null,Object? text = null,Object? createdAt = null,Object? fileId = freezed,}) {
  return _then(_self.copyWith(
tempId: null == tempId ? _self.tempId : tempId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingChatMessage].
extension PendingChatMessagePatterns on PendingChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _PendingChatMessage():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _PendingChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tempId,  String text,  DateTime createdAt,  String? fileId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingChatMessage() when $default != null:
return $default(_that.tempId,_that.text,_that.createdAt,_that.fileId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tempId,  String text,  DateTime createdAt,  String? fileId)  $default,) {final _that = this;
switch (_that) {
case _PendingChatMessage():
return $default(_that.tempId,_that.text,_that.createdAt,_that.fileId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tempId,  String text,  DateTime createdAt,  String? fileId)?  $default,) {final _that = this;
switch (_that) {
case _PendingChatMessage() when $default != null:
return $default(_that.tempId,_that.text,_that.createdAt,_that.fileId);case _:
  return null;

}
}

}

/// @nodoc


class _PendingChatMessage implements PendingChatMessage {
  const _PendingChatMessage({required this.tempId, required this.text, required this.createdAt, this.fileId});
  

@override final  String tempId;
@override final  String text;
@override final  DateTime createdAt;
@override final  String? fileId;

/// Create a copy of PendingChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingChatMessageCopyWith<_PendingChatMessage> get copyWith => __$PendingChatMessageCopyWithImpl<_PendingChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingChatMessage&&(identical(other.tempId, tempId) || other.tempId == tempId)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fileId, fileId) || other.fileId == fileId));
}


@override
int get hashCode => Object.hash(runtimeType,tempId,text,createdAt,fileId);

@override
String toString() {
  return 'PendingChatMessage(tempId: $tempId, text: $text, createdAt: $createdAt, fileId: $fileId)';
}


}

/// @nodoc
abstract mixin class _$PendingChatMessageCopyWith<$Res> implements $PendingChatMessageCopyWith<$Res> {
  factory _$PendingChatMessageCopyWith(_PendingChatMessage value, $Res Function(_PendingChatMessage) _then) = __$PendingChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String tempId, String text, DateTime createdAt, String? fileId
});




}
/// @nodoc
class __$PendingChatMessageCopyWithImpl<$Res>
    implements _$PendingChatMessageCopyWith<$Res> {
  __$PendingChatMessageCopyWithImpl(this._self, this._then);

  final _PendingChatMessage _self;
  final $Res Function(_PendingChatMessage) _then;

/// Create a copy of PendingChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tempId = null,Object? text = null,Object? createdAt = null,Object? fileId = freezed,}) {
  return _then(_PendingChatMessage(
tempId: null == tempId ? _self.tempId : tempId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
