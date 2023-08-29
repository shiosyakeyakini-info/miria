// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TimelinePageState {
  PageController get pageController => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  bool get isErrorExpanded => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimelinePageStateCopyWith<TimelinePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelinePageStateCopyWith<$Res> {
  factory $TimelinePageStateCopyWith(
          TimelinePageState value, $Res Function(TimelinePageState) then) =
      _$TimelinePageStateCopyWithImpl<$Res, TimelinePageState>;
  @useResult
  $Res call({PageController pageController, int index, bool isErrorExpanded});
}

/// @nodoc
class _$TimelinePageStateCopyWithImpl<$Res, $Val extends TimelinePageState>
    implements $TimelinePageStateCopyWith<$Res> {
  _$TimelinePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageController = null,
    Object? index = null,
    Object? isErrorExpanded = null,
  }) {
    return _then(_value.copyWith(
      pageController: null == pageController
          ? _value.pageController
          : pageController // ignore: cast_nullable_to_non_nullable
              as PageController,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      isErrorExpanded: null == isErrorExpanded
          ? _value.isErrorExpanded
          : isErrorExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelinePageStateImplCopyWith<$Res>
    implements $TimelinePageStateCopyWith<$Res> {
  factory _$$TimelinePageStateImplCopyWith(_$TimelinePageStateImpl value,
          $Res Function(_$TimelinePageStateImpl) then) =
      __$$TimelinePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PageController pageController, int index, bool isErrorExpanded});
}

/// @nodoc
class __$$TimelinePageStateImplCopyWithImpl<$Res>
    extends _$TimelinePageStateCopyWithImpl<$Res, _$TimelinePageStateImpl>
    implements _$$TimelinePageStateImplCopyWith<$Res> {
  __$$TimelinePageStateImplCopyWithImpl(_$TimelinePageStateImpl _value,
      $Res Function(_$TimelinePageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageController = null,
    Object? index = null,
    Object? isErrorExpanded = null,
  }) {
    return _then(_$TimelinePageStateImpl(
      pageController: null == pageController
          ? _value.pageController
          : pageController // ignore: cast_nullable_to_non_nullable
              as PageController,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      isErrorExpanded: null == isErrorExpanded
          ? _value.isErrorExpanded
          : isErrorExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TimelinePageStateImpl extends _TimelinePageState {
  const _$TimelinePageStateImpl(
      {required this.pageController,
      required this.index,
      this.isErrorExpanded = false})
      : super._();

  @override
  final PageController pageController;
  @override
  final int index;
  @override
  @JsonKey()
  final bool isErrorExpanded;

  @override
  String toString() {
    return 'TimelinePageState(pageController: $pageController, index: $index, isErrorExpanded: $isErrorExpanded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelinePageStateImpl &&
            (identical(other.pageController, pageController) ||
                other.pageController == pageController) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.isErrorExpanded, isErrorExpanded) ||
                other.isErrorExpanded == isErrorExpanded));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pageController, index, isErrorExpanded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelinePageStateImplCopyWith<_$TimelinePageStateImpl> get copyWith =>
      __$$TimelinePageStateImplCopyWithImpl<_$TimelinePageStateImpl>(
          this, _$identity);
}

abstract class _TimelinePageState extends TimelinePageState {
  const factory _TimelinePageState(
      {required final PageController pageController,
      required final int index,
      final bool isErrorExpanded}) = _$TimelinePageStateImpl;
  const _TimelinePageState._() : super._();

  @override
  PageController get pageController;
  @override
  int get index;
  @override
  bool get isErrorExpanded;
  @override
  @JsonKey(ignore: true)
  _$$TimelinePageStateImplCopyWith<_$TimelinePageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
