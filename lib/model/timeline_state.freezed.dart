// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TimelineState {
  /// ストリーミングで受け取ったノート. 最後尾が最新
  List<Note> get newerNotes => throw _privateConstructorUsedError;

  /// API呼び出しで取得したノート. 先頭が最新
  List<Note> get olderNotes => throw _privateConstructorUsedError;

  /// 最初の読み込み中かどうか
  bool get isLoading => throw _privateConstructorUsedError;

  /// 追加のノートを取得中かどうか
  bool get isDownDirectionLoading => throw _privateConstructorUsedError;

  /// すべてのノートを取得したかどうか
  bool get isLastLoaded => throw _privateConstructorUsedError;

  /// 初期化中のエラー
  (Object, StackTrace)? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimelineStateCopyWith<TimelineState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineStateCopyWith<$Res> {
  factory $TimelineStateCopyWith(
          TimelineState value, $Res Function(TimelineState) then) =
      _$TimelineStateCopyWithImpl<$Res, TimelineState>;
  @useResult
  $Res call(
      {List<Note> newerNotes,
      List<Note> olderNotes,
      bool isLoading,
      bool isDownDirectionLoading,
      bool isLastLoaded,
      (Object, StackTrace)? error});
}

/// @nodoc
class _$TimelineStateCopyWithImpl<$Res, $Val extends TimelineState>
    implements $TimelineStateCopyWith<$Res> {
  _$TimelineStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newerNotes = null,
    Object? olderNotes = null,
    Object? isLoading = null,
    Object? isDownDirectionLoading = null,
    Object? isLastLoaded = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      newerNotes: null == newerNotes
          ? _value.newerNotes
          : newerNotes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      olderNotes: null == olderNotes
          ? _value.olderNotes
          : olderNotes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDownDirectionLoading: null == isDownDirectionLoading
          ? _value.isDownDirectionLoading
          : isDownDirectionLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLastLoaded: null == isLastLoaded
          ? _value.isLastLoaded
          : isLastLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as (Object, StackTrace)?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelineStateImplCopyWith<$Res>
    implements $TimelineStateCopyWith<$Res> {
  factory _$$TimelineStateImplCopyWith(
          _$TimelineStateImpl value, $Res Function(_$TimelineStateImpl) then) =
      __$$TimelineStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Note> newerNotes,
      List<Note> olderNotes,
      bool isLoading,
      bool isDownDirectionLoading,
      bool isLastLoaded,
      (Object, StackTrace)? error});
}

/// @nodoc
class __$$TimelineStateImplCopyWithImpl<$Res>
    extends _$TimelineStateCopyWithImpl<$Res, _$TimelineStateImpl>
    implements _$$TimelineStateImplCopyWith<$Res> {
  __$$TimelineStateImplCopyWithImpl(
      _$TimelineStateImpl _value, $Res Function(_$TimelineStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newerNotes = null,
    Object? olderNotes = null,
    Object? isLoading = null,
    Object? isDownDirectionLoading = null,
    Object? isLastLoaded = null,
    Object? error = freezed,
  }) {
    return _then(_$TimelineStateImpl(
      newerNotes: null == newerNotes
          ? _value._newerNotes
          : newerNotes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      olderNotes: null == olderNotes
          ? _value._olderNotes
          : olderNotes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDownDirectionLoading: null == isDownDirectionLoading
          ? _value.isDownDirectionLoading
          : isDownDirectionLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLastLoaded: null == isLastLoaded
          ? _value.isLastLoaded
          : isLastLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as (Object, StackTrace)?,
    ));
  }
}

/// @nodoc

class _$TimelineStateImpl extends _TimelineState {
  const _$TimelineStateImpl(
      {final List<Note> newerNotes = const <Note>[],
      final List<Note> olderNotes = const <Note>[],
      this.isLoading = false,
      this.isDownDirectionLoading = false,
      this.isLastLoaded = false,
      this.error})
      : _newerNotes = newerNotes,
        _olderNotes = olderNotes,
        super._();

  /// ストリーミングで受け取ったノート. 最後尾が最新
  final List<Note> _newerNotes;

  /// ストリーミングで受け取ったノート. 最後尾が最新
  @override
  @JsonKey()
  List<Note> get newerNotes {
    if (_newerNotes is EqualUnmodifiableListView) return _newerNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newerNotes);
  }

  /// API呼び出しで取得したノート. 先頭が最新
  final List<Note> _olderNotes;

  /// API呼び出しで取得したノート. 先頭が最新
  @override
  @JsonKey()
  List<Note> get olderNotes {
    if (_olderNotes is EqualUnmodifiableListView) return _olderNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_olderNotes);
  }

  /// 最初の読み込み中かどうか
  @override
  @JsonKey()
  final bool isLoading;

  /// 追加のノートを取得中かどうか
  @override
  @JsonKey()
  final bool isDownDirectionLoading;

  /// すべてのノートを取得したかどうか
  @override
  @JsonKey()
  final bool isLastLoaded;

  /// 初期化中のエラー
  @override
  final (Object, StackTrace)? error;

  @override
  String toString() {
    return 'TimelineState(newerNotes: $newerNotes, olderNotes: $olderNotes, isLoading: $isLoading, isDownDirectionLoading: $isDownDirectionLoading, isLastLoaded: $isLastLoaded, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineStateImpl &&
            const DeepCollectionEquality()
                .equals(other._newerNotes, _newerNotes) &&
            const DeepCollectionEquality()
                .equals(other._olderNotes, _olderNotes) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isDownDirectionLoading, isDownDirectionLoading) ||
                other.isDownDirectionLoading == isDownDirectionLoading) &&
            (identical(other.isLastLoaded, isLastLoaded) ||
                other.isLastLoaded == isLastLoaded) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_newerNotes),
      const DeepCollectionEquality().hash(_olderNotes),
      isLoading,
      isDownDirectionLoading,
      isLastLoaded,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineStateImplCopyWith<_$TimelineStateImpl> get copyWith =>
      __$$TimelineStateImplCopyWithImpl<_$TimelineStateImpl>(this, _$identity);
}

abstract class _TimelineState extends TimelineState {
  const factory _TimelineState(
      {final List<Note> newerNotes,
      final List<Note> olderNotes,
      final bool isLoading,
      final bool isDownDirectionLoading,
      final bool isLastLoaded,
      final (Object, StackTrace)? error}) = _$TimelineStateImpl;
  const _TimelineState._() : super._();

  @override

  /// ストリーミングで受け取ったノート. 最後尾が最新
  List<Note> get newerNotes;
  @override

  /// API呼び出しで取得したノート. 先頭が最新
  List<Note> get olderNotes;
  @override

  /// 最初の読み込み中かどうか
  bool get isLoading;
  @override

  /// 追加のノートを取得中かどうか
  bool get isDownDirectionLoading;
  @override

  /// すべてのノートを取得したかどうか
  bool get isLastLoaded;
  @override

  /// 初期化中のエラー
  (Object, StackTrace)? get error;
  @override
  @JsonKey(ignore: true)
  _$$TimelineStateImplCopyWith<_$TimelineStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
