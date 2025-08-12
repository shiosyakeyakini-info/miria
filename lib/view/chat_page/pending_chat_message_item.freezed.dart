// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 String get tempId; String get text; String? get fileId; DateTime get createdAt;
/// Create a copy of PendingChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingChatMessageCopyWith<PendingChatMessage> get copyWith => _$PendingChatMessageCopyWithImpl<PendingChatMessage>(this as PendingChatMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingChatMessage&&(identical(other.tempId, tempId) || other.tempId == tempId)&&(identical(other.text, text) || other.text == text)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,tempId,text,fileId,createdAt);

@override
String toString() {
  return 'PendingChatMessage(tempId: $tempId, text: $text, fileId: $fileId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PendingChatMessageCopyWith<$Res>  {
  factory $PendingChatMessageCopyWith(PendingChatMessage value, $Res Function(PendingChatMessage) _then) = _$PendingChatMessageCopyWithImpl;
@useResult
$Res call({
 String tempId, String text, String? fileId, DateTime createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? tempId = null,Object? text = null,Object? fileId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
tempId: null == tempId ? _self.tempId : tempId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc


class _PendingChatMessage implements PendingChatMessage {
  const _PendingChatMessage({required this.tempId, required this.text, this.fileId, required this.createdAt});
  

@override final  String tempId;
@override final  String text;
@override final  String? fileId;
@override final  DateTime createdAt;

/// Create a copy of PendingChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingChatMessageCopyWith<_PendingChatMessage> get copyWith => __$PendingChatMessageCopyWithImpl<_PendingChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingChatMessage&&(identical(other.tempId, tempId) || other.tempId == tempId)&&(identical(other.text, text) || other.text == text)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,tempId,text,fileId,createdAt);

@override
String toString() {
  return 'PendingChatMessage(tempId: $tempId, text: $text, fileId: $fileId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PendingChatMessageCopyWith<$Res> implements $PendingChatMessageCopyWith<$Res> {
  factory _$PendingChatMessageCopyWith(_PendingChatMessage value, $Res Function(_PendingChatMessage) _then) = __$PendingChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String tempId, String text, String? fileId, DateTime createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? tempId = null,Object? text = null,Object? fileId = freezed,Object? createdAt = null,}) {
  return _then(_PendingChatMessage(
tempId: null == tempId ? _self.tempId : tempId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
