// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileState {

 String get name; String get description; String get location; DateTime? get birthday; List<UserField> get fields; String get followedMessage; String? get avatarDriveId; ({Uint8List data, String name})? get avatarFile; Uri? get currentAvatarUrl; Uri? get selectedDriveFileUrl; bool get isLoading; bool get isSubmitting;
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileStateCopyWith<EditProfileState> get copyWith => _$EditProfileStateCopyWithImpl<EditProfileState>(this as EditProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.followedMessage, followedMessage) || other.followedMessage == followedMessage)&&(identical(other.avatarDriveId, avatarDriveId) || other.avatarDriveId == avatarDriveId)&&(identical(other.avatarFile, avatarFile) || other.avatarFile == avatarFile)&&(identical(other.currentAvatarUrl, currentAvatarUrl) || other.currentAvatarUrl == currentAvatarUrl)&&(identical(other.selectedDriveFileUrl, selectedDriveFileUrl) || other.selectedDriveFileUrl == selectedDriveFileUrl)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,location,birthday,const DeepCollectionEquality().hash(fields),followedMessage,avatarDriveId,avatarFile,currentAvatarUrl,selectedDriveFileUrl,isLoading,isSubmitting);

@override
String toString() {
  return 'EditProfileState(name: $name, description: $description, location: $location, birthday: $birthday, fields: $fields, followedMessage: $followedMessage, avatarDriveId: $avatarDriveId, avatarFile: $avatarFile, currentAvatarUrl: $currentAvatarUrl, selectedDriveFileUrl: $selectedDriveFileUrl, isLoading: $isLoading, isSubmitting: $isSubmitting)';
}


}

/// @nodoc
abstract mixin class $EditProfileStateCopyWith<$Res>  {
  factory $EditProfileStateCopyWith(EditProfileState value, $Res Function(EditProfileState) _then) = _$EditProfileStateCopyWithImpl;
@useResult
$Res call({
 String name, String description, String location, DateTime? birthday, List<UserField> fields, String followedMessage, String? avatarDriveId, ({Uint8List data, String name})? avatarFile, Uri? currentAvatarUrl, Uri? selectedDriveFileUrl, bool isLoading, bool isSubmitting
});




}
/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._self, this._then);

  final EditProfileState _self;
  final $Res Function(EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? location = null,Object? birthday = freezed,Object? fields = null,Object? followedMessage = null,Object? avatarDriveId = freezed,Object? avatarFile = freezed,Object? currentAvatarUrl = freezed,Object? selectedDriveFileUrl = freezed,Object? isLoading = null,Object? isSubmitting = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<UserField>,followedMessage: null == followedMessage ? _self.followedMessage : followedMessage // ignore: cast_nullable_to_non_nullable
as String,avatarDriveId: freezed == avatarDriveId ? _self.avatarDriveId : avatarDriveId // ignore: cast_nullable_to_non_nullable
as String?,avatarFile: freezed == avatarFile ? _self.avatarFile : avatarFile // ignore: cast_nullable_to_non_nullable
as ({Uint8List data, String name})?,currentAvatarUrl: freezed == currentAvatarUrl ? _self.currentAvatarUrl : currentAvatarUrl // ignore: cast_nullable_to_non_nullable
as Uri?,selectedDriveFileUrl: freezed == selectedDriveFileUrl ? _self.selectedDriveFileUrl : selectedDriveFileUrl // ignore: cast_nullable_to_non_nullable
as Uri?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _EditProfileState implements EditProfileState {
  const _EditProfileState({this.name = "", this.description = "", this.location = "", this.birthday, final  List<UserField> fields = const [], this.followedMessage = "", this.avatarDriveId, this.avatarFile, this.currentAvatarUrl, this.selectedDriveFileUrl, this.isLoading = false, this.isSubmitting = false}): _fields = fields;
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String location;
@override final  DateTime? birthday;
 final  List<UserField> _fields;
@override@JsonKey() List<UserField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

@override@JsonKey() final  String followedMessage;
@override final  String? avatarDriveId;
@override final  ({Uint8List data, String name})? avatarFile;
@override final  Uri? currentAvatarUrl;
@override final  Uri? selectedDriveFileUrl;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileStateCopyWith<_EditProfileState> get copyWith => __$EditProfileStateCopyWithImpl<_EditProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileState&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.followedMessage, followedMessage) || other.followedMessage == followedMessage)&&(identical(other.avatarDriveId, avatarDriveId) || other.avatarDriveId == avatarDriveId)&&(identical(other.avatarFile, avatarFile) || other.avatarFile == avatarFile)&&(identical(other.currentAvatarUrl, currentAvatarUrl) || other.currentAvatarUrl == currentAvatarUrl)&&(identical(other.selectedDriveFileUrl, selectedDriveFileUrl) || other.selectedDriveFileUrl == selectedDriveFileUrl)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,location,birthday,const DeepCollectionEquality().hash(_fields),followedMessage,avatarDriveId,avatarFile,currentAvatarUrl,selectedDriveFileUrl,isLoading,isSubmitting);

@override
String toString() {
  return 'EditProfileState(name: $name, description: $description, location: $location, birthday: $birthday, fields: $fields, followedMessage: $followedMessage, avatarDriveId: $avatarDriveId, avatarFile: $avatarFile, currentAvatarUrl: $currentAvatarUrl, selectedDriveFileUrl: $selectedDriveFileUrl, isLoading: $isLoading, isSubmitting: $isSubmitting)';
}


}

/// @nodoc
abstract mixin class _$EditProfileStateCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileStateCopyWith(_EditProfileState value, $Res Function(_EditProfileState) _then) = __$EditProfileStateCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, String location, DateTime? birthday, List<UserField> fields, String followedMessage, String? avatarDriveId, ({Uint8List data, String name})? avatarFile, Uri? currentAvatarUrl, Uri? selectedDriveFileUrl, bool isLoading, bool isSubmitting
});




}
/// @nodoc
class __$EditProfileStateCopyWithImpl<$Res>
    implements _$EditProfileStateCopyWith<$Res> {
  __$EditProfileStateCopyWithImpl(this._self, this._then);

  final _EditProfileState _self;
  final $Res Function(_EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? location = null,Object? birthday = freezed,Object? fields = null,Object? followedMessage = null,Object? avatarDriveId = freezed,Object? avatarFile = freezed,Object? currentAvatarUrl = freezed,Object? selectedDriveFileUrl = freezed,Object? isLoading = null,Object? isSubmitting = null,}) {
  return _then(_EditProfileState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<UserField>,followedMessage: null == followedMessage ? _self.followedMessage : followedMessage // ignore: cast_nullable_to_non_nullable
as String,avatarDriveId: freezed == avatarDriveId ? _self.avatarDriveId : avatarDriveId // ignore: cast_nullable_to_non_nullable
as String?,avatarFile: freezed == avatarFile ? _self.avatarFile : avatarFile // ignore: cast_nullable_to_non_nullable
as ({Uint8List data, String name})?,currentAvatarUrl: freezed == currentAvatarUrl ? _self.currentAvatarUrl : currentAvatarUrl // ignore: cast_nullable_to_non_nullable
as Uri?,selectedDriveFileUrl: freezed == selectedDriveFileUrl ? _self.selectedDriveFileUrl : selectedDriveFileUrl // ignore: cast_nullable_to_non_nullable
as Uri?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
