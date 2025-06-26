// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServerPresets _$ServerPresetsFromJson(Map<String, dynamic> json) {
  return _ServerPresets.fromJson(json);
}

/// @nodoc
mixin _$ServerPresets {
  List<String> get limitedApiServers => throw _privateConstructorUsedError;
  List<TimelinePreset> get particularTimelinePresets =>
      throw _privateConstructorUsedError;

  /// Serializes this ServerPresets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServerPresets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServerPresetsCopyWith<ServerPresets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerPresetsCopyWith<$Res> {
  factory $ServerPresetsCopyWith(
          ServerPresets value, $Res Function(ServerPresets) then) =
      _$ServerPresetsCopyWithImpl<$Res, ServerPresets>;
  @useResult
  $Res call(
      {List<String> limitedApiServers,
      List<TimelinePreset> particularTimelinePresets});
}

/// @nodoc
class _$ServerPresetsCopyWithImpl<$Res, $Val extends ServerPresets>
    implements $ServerPresetsCopyWith<$Res> {
  _$ServerPresetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServerPresets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limitedApiServers = null,
    Object? particularTimelinePresets = null,
  }) {
    return _then(_value.copyWith(
      limitedApiServers: null == limitedApiServers
          ? _value.limitedApiServers
          : limitedApiServers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      particularTimelinePresets: null == particularTimelinePresets
          ? _value.particularTimelinePresets
          : particularTimelinePresets // ignore: cast_nullable_to_non_nullable
              as List<TimelinePreset>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerPresetsImplCopyWith<$Res>
    implements $ServerPresetsCopyWith<$Res> {
  factory _$$ServerPresetsImplCopyWith(
          _$ServerPresetsImpl value, $Res Function(_$ServerPresetsImpl) then) =
      __$$ServerPresetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> limitedApiServers,
      List<TimelinePreset> particularTimelinePresets});
}

/// @nodoc
class __$$ServerPresetsImplCopyWithImpl<$Res>
    extends _$ServerPresetsCopyWithImpl<$Res, _$ServerPresetsImpl>
    implements _$$ServerPresetsImplCopyWith<$Res> {
  __$$ServerPresetsImplCopyWithImpl(
      _$ServerPresetsImpl _value, $Res Function(_$ServerPresetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServerPresets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limitedApiServers = null,
    Object? particularTimelinePresets = null,
  }) {
    return _then(_$ServerPresetsImpl(
      limitedApiServers: null == limitedApiServers
          ? _value._limitedApiServers
          : limitedApiServers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      particularTimelinePresets: null == particularTimelinePresets
          ? _value._particularTimelinePresets
          : particularTimelinePresets // ignore: cast_nullable_to_non_nullable
              as List<TimelinePreset>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServerPresetsImpl implements _ServerPresets {
  const _$ServerPresetsImpl(
      {final List<String> limitedApiServers = const [],
      final List<TimelinePreset> particularTimelinePresets = const []})
      : _limitedApiServers = limitedApiServers,
        _particularTimelinePresets = particularTimelinePresets;

  factory _$ServerPresetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServerPresetsImplFromJson(json);

  final List<String> _limitedApiServers;
  @override
  @JsonKey()
  List<String> get limitedApiServers {
    if (_limitedApiServers is EqualUnmodifiableListView)
      return _limitedApiServers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_limitedApiServers);
  }

  final List<TimelinePreset> _particularTimelinePresets;
  @override
  @JsonKey()
  List<TimelinePreset> get particularTimelinePresets {
    if (_particularTimelinePresets is EqualUnmodifiableListView)
      return _particularTimelinePresets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_particularTimelinePresets);
  }

  @override
  String toString() {
    return 'ServerPresets(limitedApiServers: $limitedApiServers, particularTimelinePresets: $particularTimelinePresets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerPresetsImpl &&
            const DeepCollectionEquality()
                .equals(other._limitedApiServers, _limitedApiServers) &&
            const DeepCollectionEquality().equals(
                other._particularTimelinePresets, _particularTimelinePresets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_limitedApiServers),
      const DeepCollectionEquality().hash(_particularTimelinePresets));

  /// Create a copy of ServerPresets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerPresetsImplCopyWith<_$ServerPresetsImpl> get copyWith =>
      __$$ServerPresetsImplCopyWithImpl<_$ServerPresetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServerPresetsImplToJson(
      this,
    );
  }
}

abstract class _ServerPresets implements ServerPresets {
  const factory _ServerPresets(
          {final List<String> limitedApiServers,
          final List<TimelinePreset> particularTimelinePresets}) =
      _$ServerPresetsImpl;

  factory _ServerPresets.fromJson(Map<String, dynamic> json) =
      _$ServerPresetsImpl.fromJson;

  @override
  List<String> get limitedApiServers;
  @override
  List<TimelinePreset> get particularTimelinePresets;

  /// Create a copy of ServerPresets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerPresetsImplCopyWith<_$ServerPresetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimelinePreset _$TimelinePresetFromJson(Map<String, dynamic> json) {
  return _TimelinePreset.fromJson(json);
}

/// @nodoc
mixin _$TimelinePreset {
  String get host => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get endpoint => throw _privateConstructorUsedError;
  String get websocketChannelName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;

  /// Serializes this TimelinePreset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimelinePreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelinePresetCopyWith<TimelinePreset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelinePresetCopyWith<$Res> {
  factory $TimelinePresetCopyWith(
          TimelinePreset value, $Res Function(TimelinePreset) then) =
      _$TimelinePresetCopyWithImpl<$Res, TimelinePreset>;
  @useResult
  $Res call(
      {String host,
      String name,
      String endpoint,
      String websocketChannelName,
      @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)
      Map<String, dynamic> parameters});
}

/// @nodoc
class _$TimelinePresetCopyWithImpl<$Res, $Val extends TimelinePreset>
    implements $TimelinePresetCopyWith<$Res> {
  _$TimelinePresetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelinePreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? name = null,
    Object? endpoint = null,
    Object? websocketChannelName = null,
    Object? parameters = null,
  }) {
    return _then(_value.copyWith(
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      endpoint: null == endpoint
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String,
      websocketChannelName: null == websocketChannelName
          ? _value.websocketChannelName
          : websocketChannelName // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelinePresetImplCopyWith<$Res>
    implements $TimelinePresetCopyWith<$Res> {
  factory _$$TimelinePresetImplCopyWith(_$TimelinePresetImpl value,
          $Res Function(_$TimelinePresetImpl) then) =
      __$$TimelinePresetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String host,
      String name,
      String endpoint,
      String websocketChannelName,
      @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)
      Map<String, dynamic> parameters});
}

/// @nodoc
class __$$TimelinePresetImplCopyWithImpl<$Res>
    extends _$TimelinePresetCopyWithImpl<$Res, _$TimelinePresetImpl>
    implements _$$TimelinePresetImplCopyWith<$Res> {
  __$$TimelinePresetImplCopyWithImpl(
      _$TimelinePresetImpl _value, $Res Function(_$TimelinePresetImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimelinePreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? name = null,
    Object? endpoint = null,
    Object? websocketChannelName = null,
    Object? parameters = null,
  }) {
    return _then(_$TimelinePresetImpl(
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      endpoint: null == endpoint
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String,
      websocketChannelName: null == websocketChannelName
          ? _value.websocketChannelName
          : websocketChannelName // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelinePresetImpl implements _TimelinePreset {
  const _$TimelinePresetImpl(
      {required this.host,
      required this.name,
      required this.endpoint,
      required this.websocketChannelName,
      @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)
      final Map<String, dynamic> parameters = const <String, dynamic>{}})
      : _parameters = parameters;

  factory _$TimelinePresetImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelinePresetImplFromJson(json);

  @override
  final String host;
  @override
  final String name;
  @override
  final String endpoint;
  @override
  final String websocketChannelName;
  final Map<String, dynamic> _parameters;
  @override
  @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  @override
  String toString() {
    return 'TimelinePreset(host: $host, name: $name, endpoint: $endpoint, websocketChannelName: $websocketChannelName, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelinePresetImpl &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.endpoint, endpoint) ||
                other.endpoint == endpoint) &&
            (identical(other.websocketChannelName, websocketChannelName) ||
                other.websocketChannelName == websocketChannelName) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, host, name, endpoint,
      websocketChannelName, const DeepCollectionEquality().hash(_parameters));

  /// Create a copy of TimelinePreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelinePresetImplCopyWith<_$TimelinePresetImpl> get copyWith =>
      __$$TimelinePresetImplCopyWithImpl<_$TimelinePresetImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelinePresetImplToJson(
      this,
    );
  }
}

abstract class _TimelinePreset implements TimelinePreset {
  const factory _TimelinePreset(
      {required final String host,
      required final String name,
      required final String endpoint,
      required final String websocketChannelName,
      @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)
      final Map<String, dynamic> parameters}) = _$TimelinePresetImpl;

  factory _TimelinePreset.fromJson(Map<String, dynamic> json) =
      _$TimelinePresetImpl.fromJson;

  @override
  String get host;
  @override
  String get name;
  @override
  String get endpoint;
  @override
  String get websocketChannelName;
  @override
  @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)
  Map<String, dynamic> get parameters;

  /// Create a copy of TimelinePreset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelinePresetImplCopyWith<_$TimelinePresetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
