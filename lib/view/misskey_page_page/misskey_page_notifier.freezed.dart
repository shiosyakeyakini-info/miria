// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_page_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MisskeyPageNotifierState {
  Page get page => throw _privateConstructorUsedError;
  AsyncValue<void>? get likeOr => throw _privateConstructorUsedError;

  /// Create a copy of MisskeyPageNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MisskeyPageNotifierStateCopyWith<MisskeyPageNotifierState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MisskeyPageNotifierStateCopyWith<$Res> {
  factory $MisskeyPageNotifierStateCopyWith(MisskeyPageNotifierState value,
          $Res Function(MisskeyPageNotifierState) then) =
      _$MisskeyPageNotifierStateCopyWithImpl<$Res, MisskeyPageNotifierState>;
  @useResult
  $Res call({Page page, AsyncValue<void>? likeOr});

  $PageCopyWith<$Res> get page;
}

/// @nodoc
class _$MisskeyPageNotifierStateCopyWithImpl<$Res,
        $Val extends MisskeyPageNotifierState>
    implements $MisskeyPageNotifierStateCopyWith<$Res> {
  _$MisskeyPageNotifierStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MisskeyPageNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? likeOr = freezed,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as Page,
      likeOr: freezed == likeOr
          ? _value.likeOr
          : likeOr // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
    ) as $Val);
  }

  /// Create a copy of MisskeyPageNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PageCopyWith<$Res> get page {
    return $PageCopyWith<$Res>(_value.page, (value) {
      return _then(_value.copyWith(page: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MisskeyPageNotifierStateImplCopyWith<$Res>
    implements $MisskeyPageNotifierStateCopyWith<$Res> {
  factory _$$MisskeyPageNotifierStateImplCopyWith(
          _$MisskeyPageNotifierStateImpl value,
          $Res Function(_$MisskeyPageNotifierStateImpl) then) =
      __$$MisskeyPageNotifierStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Page page, AsyncValue<void>? likeOr});

  @override
  $PageCopyWith<$Res> get page;
}

/// @nodoc
class __$$MisskeyPageNotifierStateImplCopyWithImpl<$Res>
    extends _$MisskeyPageNotifierStateCopyWithImpl<$Res,
        _$MisskeyPageNotifierStateImpl>
    implements _$$MisskeyPageNotifierStateImplCopyWith<$Res> {
  __$$MisskeyPageNotifierStateImplCopyWithImpl(
      _$MisskeyPageNotifierStateImpl _value,
      $Res Function(_$MisskeyPageNotifierStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MisskeyPageNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? likeOr = freezed,
  }) {
    return _then(_$MisskeyPageNotifierStateImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as Page,
      likeOr: freezed == likeOr
          ? _value.likeOr
          : likeOr // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
    ));
  }
}

/// @nodoc

class _$MisskeyPageNotifierStateImpl implements _MisskeyPageNotifierState {
  const _$MisskeyPageNotifierStateImpl({required this.page, this.likeOr});

  @override
  final Page page;
  @override
  final AsyncValue<void>? likeOr;

  @override
  String toString() {
    return 'MisskeyPageNotifierState(page: $page, likeOr: $likeOr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MisskeyPageNotifierStateImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.likeOr, likeOr) || other.likeOr == likeOr));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, likeOr);

  /// Create a copy of MisskeyPageNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MisskeyPageNotifierStateImplCopyWith<_$MisskeyPageNotifierStateImpl>
      get copyWith => __$$MisskeyPageNotifierStateImplCopyWithImpl<
          _$MisskeyPageNotifierStateImpl>(this, _$identity);
}

abstract class _MisskeyPageNotifierState implements MisskeyPageNotifierState {
  const factory _MisskeyPageNotifierState(
      {required final Page page,
      final AsyncValue<void>? likeOr}) = _$MisskeyPageNotifierStateImpl;

  @override
  Page get page;
  @override
  AsyncValue<void>? get likeOr;

  /// Create a copy of MisskeyPageNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MisskeyPageNotifierStateImplCopyWith<_$MisskeyPageNotifierStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
