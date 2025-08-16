// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiSettings {

 bool get isReactionSuggestionEnabled; bool get isTranslationEnabled; bool get isModelDownloaded; String get modelPath; double get temperature; int get maxTokens;
/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSettingsCopyWith<AiSettings> get copyWith => _$AiSettingsCopyWithImpl<AiSettings>(this as AiSettings, _$identity);

  /// Serializes this AiSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSettings&&(identical(other.isReactionSuggestionEnabled, isReactionSuggestionEnabled) || other.isReactionSuggestionEnabled == isReactionSuggestionEnabled)&&(identical(other.isTranslationEnabled, isTranslationEnabled) || other.isTranslationEnabled == isTranslationEnabled)&&(identical(other.isModelDownloaded, isModelDownloaded) || other.isModelDownloaded == isModelDownloaded)&&(identical(other.modelPath, modelPath) || other.modelPath == modelPath)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isReactionSuggestionEnabled,isTranslationEnabled,isModelDownloaded,modelPath,temperature,maxTokens);

@override
String toString() {
  return 'AiSettings(isReactionSuggestionEnabled: $isReactionSuggestionEnabled, isTranslationEnabled: $isTranslationEnabled, isModelDownloaded: $isModelDownloaded, modelPath: $modelPath, temperature: $temperature, maxTokens: $maxTokens)';
}


}

/// @nodoc
abstract mixin class $AiSettingsCopyWith<$Res>  {
  factory $AiSettingsCopyWith(AiSettings value, $Res Function(AiSettings) _then) = _$AiSettingsCopyWithImpl;
@useResult
$Res call({
 bool isReactionSuggestionEnabled, bool isTranslationEnabled, bool isModelDownloaded, String modelPath, double temperature, int maxTokens
});




}
/// @nodoc
class _$AiSettingsCopyWithImpl<$Res>
    implements $AiSettingsCopyWith<$Res> {
  _$AiSettingsCopyWithImpl(this._self, this._then);

  final AiSettings _self;
  final $Res Function(AiSettings) _then;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isReactionSuggestionEnabled = null,Object? isTranslationEnabled = null,Object? isModelDownloaded = null,Object? modelPath = null,Object? temperature = null,Object? maxTokens = null,}) {
  return _then(_self.copyWith(
isReactionSuggestionEnabled: null == isReactionSuggestionEnabled ? _self.isReactionSuggestionEnabled : isReactionSuggestionEnabled // ignore: cast_nullable_to_non_nullable
as bool,isTranslationEnabled: null == isTranslationEnabled ? _self.isTranslationEnabled : isTranslationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isModelDownloaded: null == isModelDownloaded ? _self.isModelDownloaded : isModelDownloaded // ignore: cast_nullable_to_non_nullable
as bool,modelPath: null == modelPath ? _self.modelPath : modelPath // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AiSettings implements AiSettings {
  const _AiSettings({this.isReactionSuggestionEnabled = false, this.isTranslationEnabled = false, this.isModelDownloaded = false, this.modelPath = "", this.temperature = 0.8, this.maxTokens = 100});
  factory _AiSettings.fromJson(Map<String, dynamic> json) => _$AiSettingsFromJson(json);

@override@JsonKey() final  bool isReactionSuggestionEnabled;
@override@JsonKey() final  bool isTranslationEnabled;
@override@JsonKey() final  bool isModelDownloaded;
@override@JsonKey() final  String modelPath;
@override@JsonKey() final  double temperature;
@override@JsonKey() final  int maxTokens;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSettingsCopyWith<_AiSettings> get copyWith => __$AiSettingsCopyWithImpl<_AiSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSettings&&(identical(other.isReactionSuggestionEnabled, isReactionSuggestionEnabled) || other.isReactionSuggestionEnabled == isReactionSuggestionEnabled)&&(identical(other.isTranslationEnabled, isTranslationEnabled) || other.isTranslationEnabled == isTranslationEnabled)&&(identical(other.isModelDownloaded, isModelDownloaded) || other.isModelDownloaded == isModelDownloaded)&&(identical(other.modelPath, modelPath) || other.modelPath == modelPath)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isReactionSuggestionEnabled,isTranslationEnabled,isModelDownloaded,modelPath,temperature,maxTokens);

@override
String toString() {
  return 'AiSettings(isReactionSuggestionEnabled: $isReactionSuggestionEnabled, isTranslationEnabled: $isTranslationEnabled, isModelDownloaded: $isModelDownloaded, modelPath: $modelPath, temperature: $temperature, maxTokens: $maxTokens)';
}


}

/// @nodoc
abstract mixin class _$AiSettingsCopyWith<$Res> implements $AiSettingsCopyWith<$Res> {
  factory _$AiSettingsCopyWith(_AiSettings value, $Res Function(_AiSettings) _then) = __$AiSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool isReactionSuggestionEnabled, bool isTranslationEnabled, bool isModelDownloaded, String modelPath, double temperature, int maxTokens
});




}
/// @nodoc
class __$AiSettingsCopyWithImpl<$Res>
    implements _$AiSettingsCopyWith<$Res> {
  __$AiSettingsCopyWithImpl(this._self, this._then);

  final _AiSettings _self;
  final $Res Function(_AiSettings) _then;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isReactionSuggestionEnabled = null,Object? isTranslationEnabled = null,Object? isModelDownloaded = null,Object? modelPath = null,Object? temperature = null,Object? maxTokens = null,}) {
  return _then(_AiSettings(
isReactionSuggestionEnabled: null == isReactionSuggestionEnabled ? _self.isReactionSuggestionEnabled : isReactionSuggestionEnabled // ignore: cast_nullable_to_non_nullable
as bool,isTranslationEnabled: null == isTranslationEnabled ? _self.isTranslationEnabled : isTranslationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isModelDownloaded: null == isModelDownloaded ? _self.isModelDownloaded : isModelDownloaded // ignore: cast_nullable_to_non_nullable
as bool,modelPath: null == modelPath ? _self.modelPath : modelPath // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AiInferenceRequest {

 String get text; AiFeatureType get featureType; String get context; double get temperature; int get maxTokens;
/// Create a copy of AiInferenceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiInferenceRequestCopyWith<AiInferenceRequest> get copyWith => _$AiInferenceRequestCopyWithImpl<AiInferenceRequest>(this as AiInferenceRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiInferenceRequest&&(identical(other.text, text) || other.text == text)&&(identical(other.featureType, featureType) || other.featureType == featureType)&&(identical(other.context, context) || other.context == context)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens));
}


@override
int get hashCode => Object.hash(runtimeType,text,featureType,context,temperature,maxTokens);

@override
String toString() {
  return 'AiInferenceRequest(text: $text, featureType: $featureType, context: $context, temperature: $temperature, maxTokens: $maxTokens)';
}


}

/// @nodoc
abstract mixin class $AiInferenceRequestCopyWith<$Res>  {
  factory $AiInferenceRequestCopyWith(AiInferenceRequest value, $Res Function(AiInferenceRequest) _then) = _$AiInferenceRequestCopyWithImpl;
@useResult
$Res call({
 String text, AiFeatureType featureType, String context, double temperature, int maxTokens
});




}
/// @nodoc
class _$AiInferenceRequestCopyWithImpl<$Res>
    implements $AiInferenceRequestCopyWith<$Res> {
  _$AiInferenceRequestCopyWithImpl(this._self, this._then);

  final AiInferenceRequest _self;
  final $Res Function(AiInferenceRequest) _then;

/// Create a copy of AiInferenceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? featureType = null,Object? context = null,Object? temperature = null,Object? maxTokens = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,featureType: null == featureType ? _self.featureType : featureType // ignore: cast_nullable_to_non_nullable
as AiFeatureType,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _AiInferenceRequest implements AiInferenceRequest {
  const _AiInferenceRequest({required this.text, required this.featureType, this.context = "", this.temperature = 0.8, this.maxTokens = 100});
  

@override final  String text;
@override final  AiFeatureType featureType;
@override@JsonKey() final  String context;
@override@JsonKey() final  double temperature;
@override@JsonKey() final  int maxTokens;

/// Create a copy of AiInferenceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiInferenceRequestCopyWith<_AiInferenceRequest> get copyWith => __$AiInferenceRequestCopyWithImpl<_AiInferenceRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiInferenceRequest&&(identical(other.text, text) || other.text == text)&&(identical(other.featureType, featureType) || other.featureType == featureType)&&(identical(other.context, context) || other.context == context)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens));
}


@override
int get hashCode => Object.hash(runtimeType,text,featureType,context,temperature,maxTokens);

@override
String toString() {
  return 'AiInferenceRequest(text: $text, featureType: $featureType, context: $context, temperature: $temperature, maxTokens: $maxTokens)';
}


}

/// @nodoc
abstract mixin class _$AiInferenceRequestCopyWith<$Res> implements $AiInferenceRequestCopyWith<$Res> {
  factory _$AiInferenceRequestCopyWith(_AiInferenceRequest value, $Res Function(_AiInferenceRequest) _then) = __$AiInferenceRequestCopyWithImpl;
@override @useResult
$Res call({
 String text, AiFeatureType featureType, String context, double temperature, int maxTokens
});




}
/// @nodoc
class __$AiInferenceRequestCopyWithImpl<$Res>
    implements _$AiInferenceRequestCopyWith<$Res> {
  __$AiInferenceRequestCopyWithImpl(this._self, this._then);

  final _AiInferenceRequest _self;
  final $Res Function(_AiInferenceRequest) _then;

/// Create a copy of AiInferenceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? featureType = null,Object? context = null,Object? temperature = null,Object? maxTokens = null,}) {
  return _then(_AiInferenceRequest(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,featureType: null == featureType ? _self.featureType : featureType // ignore: cast_nullable_to_non_nullable
as AiFeatureType,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AiInferenceResult {

 String get text; bool get isSuccess; String? get error; int get processingTimeMs;
/// Create a copy of AiInferenceResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiInferenceResultCopyWith<AiInferenceResult> get copyWith => _$AiInferenceResultCopyWithImpl<AiInferenceResult>(this as AiInferenceResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiInferenceResult&&(identical(other.text, text) || other.text == text)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.error, error) || other.error == error)&&(identical(other.processingTimeMs, processingTimeMs) || other.processingTimeMs == processingTimeMs));
}


@override
int get hashCode => Object.hash(runtimeType,text,isSuccess,error,processingTimeMs);

@override
String toString() {
  return 'AiInferenceResult(text: $text, isSuccess: $isSuccess, error: $error, processingTimeMs: $processingTimeMs)';
}


}

/// @nodoc
abstract mixin class $AiInferenceResultCopyWith<$Res>  {
  factory $AiInferenceResultCopyWith(AiInferenceResult value, $Res Function(AiInferenceResult) _then) = _$AiInferenceResultCopyWithImpl;
@useResult
$Res call({
 String text, bool isSuccess, String? error, int processingTimeMs
});




}
/// @nodoc
class _$AiInferenceResultCopyWithImpl<$Res>
    implements $AiInferenceResultCopyWith<$Res> {
  _$AiInferenceResultCopyWithImpl(this._self, this._then);

  final AiInferenceResult _self;
  final $Res Function(AiInferenceResult) _then;

/// Create a copy of AiInferenceResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? isSuccess = null,Object? error = freezed,Object? processingTimeMs = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,processingTimeMs: null == processingTimeMs ? _self.processingTimeMs : processingTimeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _AiInferenceResult implements AiInferenceResult {
  const _AiInferenceResult({required this.text, required this.isSuccess, this.error, this.processingTimeMs = 0});
  

@override final  String text;
@override final  bool isSuccess;
@override final  String? error;
@override@JsonKey() final  int processingTimeMs;

/// Create a copy of AiInferenceResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiInferenceResultCopyWith<_AiInferenceResult> get copyWith => __$AiInferenceResultCopyWithImpl<_AiInferenceResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiInferenceResult&&(identical(other.text, text) || other.text == text)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.error, error) || other.error == error)&&(identical(other.processingTimeMs, processingTimeMs) || other.processingTimeMs == processingTimeMs));
}


@override
int get hashCode => Object.hash(runtimeType,text,isSuccess,error,processingTimeMs);

@override
String toString() {
  return 'AiInferenceResult(text: $text, isSuccess: $isSuccess, error: $error, processingTimeMs: $processingTimeMs)';
}


}

/// @nodoc
abstract mixin class _$AiInferenceResultCopyWith<$Res> implements $AiInferenceResultCopyWith<$Res> {
  factory _$AiInferenceResultCopyWith(_AiInferenceResult value, $Res Function(_AiInferenceResult) _then) = __$AiInferenceResultCopyWithImpl;
@override @useResult
$Res call({
 String text, bool isSuccess, String? error, int processingTimeMs
});




}
/// @nodoc
class __$AiInferenceResultCopyWithImpl<$Res>
    implements _$AiInferenceResultCopyWith<$Res> {
  __$AiInferenceResultCopyWithImpl(this._self, this._then);

  final _AiInferenceResult _self;
  final $Res Function(_AiInferenceResult) _then;

/// Create a copy of AiInferenceResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? isSuccess = null,Object? error = freezed,Object? processingTimeMs = null,}) {
  return _then(_AiInferenceResult(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,processingTimeMs: null == processingTimeMs ? _self.processingTimeMs : processingTimeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
