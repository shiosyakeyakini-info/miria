// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_extension_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShareExtensionData {

 List<String> get text; List<SharedFiles> get files;
/// Create a copy of ShareExtensionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareExtensionDataCopyWith<ShareExtensionData> get copyWith => _$ShareExtensionDataCopyWithImpl<ShareExtensionData>(this as ShareExtensionData, _$identity);

  /// Serializes this ShareExtensionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareExtensionData&&const DeepCollectionEquality().equals(other.text, text)&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(text),const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'ShareExtensionData(text: $text, files: $files)';
}


}

/// @nodoc
abstract mixin class $ShareExtensionDataCopyWith<$Res>  {
  factory $ShareExtensionDataCopyWith(ShareExtensionData value, $Res Function(ShareExtensionData) _then) = _$ShareExtensionDataCopyWithImpl;
@useResult
$Res call({
 List<String> text, List<SharedFiles> files
});




}
/// @nodoc
class _$ShareExtensionDataCopyWithImpl<$Res>
    implements $ShareExtensionDataCopyWith<$Res> {
  _$ShareExtensionDataCopyWithImpl(this._self, this._then);

  final ShareExtensionData _self;
  final $Res Function(ShareExtensionData) _then;

/// Create a copy of ShareExtensionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? files = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as List<String>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<SharedFiles>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShareExtensionData].
extension ShareExtensionDataPatterns on ShareExtensionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShareExtensionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShareExtensionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShareExtensionData value)  $default,){
final _that = this;
switch (_that) {
case _ShareExtensionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShareExtensionData value)?  $default,){
final _that = this;
switch (_that) {
case _ShareExtensionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> text,  List<SharedFiles> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShareExtensionData() when $default != null:
return $default(_that.text,_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> text,  List<SharedFiles> files)  $default,) {final _that = this;
switch (_that) {
case _ShareExtensionData():
return $default(_that.text,_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> text,  List<SharedFiles> files)?  $default,) {final _that = this;
switch (_that) {
case _ShareExtensionData() when $default != null:
return $default(_that.text,_that.files);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShareExtensionData implements ShareExtensionData {
   _ShareExtensionData({required final  List<String> text, required final  List<SharedFiles> files}): _text = text,_files = files;
  factory _ShareExtensionData.fromJson(Map<String, dynamic> json) => _$ShareExtensionDataFromJson(json);

 final  List<String> _text;
@override List<String> get text {
  if (_text is EqualUnmodifiableListView) return _text;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_text);
}

 final  List<SharedFiles> _files;
@override List<SharedFiles> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of ShareExtensionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareExtensionDataCopyWith<_ShareExtensionData> get copyWith => __$ShareExtensionDataCopyWithImpl<_ShareExtensionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShareExtensionDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareExtensionData&&const DeepCollectionEquality().equals(other._text, _text)&&const DeepCollectionEquality().equals(other._files, _files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_text),const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'ShareExtensionData(text: $text, files: $files)';
}


}

/// @nodoc
abstract mixin class _$ShareExtensionDataCopyWith<$Res> implements $ShareExtensionDataCopyWith<$Res> {
  factory _$ShareExtensionDataCopyWith(_ShareExtensionData value, $Res Function(_ShareExtensionData) _then) = __$ShareExtensionDataCopyWithImpl;
@override @useResult
$Res call({
 List<String> text, List<SharedFiles> files
});




}
/// @nodoc
class __$ShareExtensionDataCopyWithImpl<$Res>
    implements _$ShareExtensionDataCopyWith<$Res> {
  __$ShareExtensionDataCopyWithImpl(this._self, this._then);

  final _ShareExtensionData _self;
  final $Res Function(_ShareExtensionData) _then;

/// Create a copy of ShareExtensionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? files = null,}) {
  return _then(_ShareExtensionData(
text: null == text ? _self._text : text // ignore: cast_nullable_to_non_nullable
as List<String>,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<SharedFiles>,
  ));
}


}


/// @nodoc
mixin _$SharedFiles {

 String get path; int get type;
/// Create a copy of SharedFiles
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedFilesCopyWith<SharedFiles> get copyWith => _$SharedFilesCopyWithImpl<SharedFiles>(this as SharedFiles, _$identity);

  /// Serializes this SharedFiles to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedFiles&&(identical(other.path, path) || other.path == path)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,type);

@override
String toString() {
  return 'SharedFiles(path: $path, type: $type)';
}


}

/// @nodoc
abstract mixin class $SharedFilesCopyWith<$Res>  {
  factory $SharedFilesCopyWith(SharedFiles value, $Res Function(SharedFiles) _then) = _$SharedFilesCopyWithImpl;
@useResult
$Res call({
 String path, int type
});




}
/// @nodoc
class _$SharedFilesCopyWithImpl<$Res>
    implements $SharedFilesCopyWith<$Res> {
  _$SharedFilesCopyWithImpl(this._self, this._then);

  final SharedFiles _self;
  final $Res Function(SharedFiles) _then;

/// Create a copy of SharedFiles
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? type = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedFiles].
extension SharedFilesPatterns on SharedFiles {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedFiles value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedFiles() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedFiles value)  $default,){
final _that = this;
switch (_that) {
case _SharedFiles():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedFiles value)?  $default,){
final _that = this;
switch (_that) {
case _SharedFiles() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  int type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedFiles() when $default != null:
return $default(_that.path,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  int type)  $default,) {final _that = this;
switch (_that) {
case _SharedFiles():
return $default(_that.path,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  int type)?  $default,) {final _that = this;
switch (_that) {
case _SharedFiles() when $default != null:
return $default(_that.path,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedFiles implements SharedFiles {
   _SharedFiles({required this.path, required this.type});
  factory _SharedFiles.fromJson(Map<String, dynamic> json) => _$SharedFilesFromJson(json);

@override final  String path;
@override final  int type;

/// Create a copy of SharedFiles
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedFilesCopyWith<_SharedFiles> get copyWith => __$SharedFilesCopyWithImpl<_SharedFiles>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedFilesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedFiles&&(identical(other.path, path) || other.path == path)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,type);

@override
String toString() {
  return 'SharedFiles(path: $path, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SharedFilesCopyWith<$Res> implements $SharedFilesCopyWith<$Res> {
  factory _$SharedFilesCopyWith(_SharedFiles value, $Res Function(_SharedFiles) _then) = __$SharedFilesCopyWithImpl;
@override @useResult
$Res call({
 String path, int type
});




}
/// @nodoc
class __$SharedFilesCopyWithImpl<$Res>
    implements _$SharedFilesCopyWith<$Res> {
  __$SharedFilesCopyWithImpl(this._self, this._then);

  final _SharedFiles _self;
  final $Res Function(_SharedFiles) _then;

/// Create a copy of SharedFiles
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? type = null,}) {
  return _then(_SharedFiles(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
