// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DialogsState {
  List<DialogData> get dialogs => throw _privateConstructorUsedError;

  /// Create a copy of DialogsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DialogsStateCopyWith<DialogsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DialogsStateCopyWith<$Res> {
  factory $DialogsStateCopyWith(
          DialogsState value, $Res Function(DialogsState) then) =
      _$DialogsStateCopyWithImpl<$Res, DialogsState>;
  @useResult
  $Res call({List<DialogData> dialogs});
}

/// @nodoc
class _$DialogsStateCopyWithImpl<$Res, $Val extends DialogsState>
    implements $DialogsStateCopyWith<$Res> {
  _$DialogsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DialogsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dialogs = null,
  }) {
    return _then(_value.copyWith(
      dialogs: null == dialogs
          ? _value.dialogs
          : dialogs // ignore: cast_nullable_to_non_nullable
              as List<DialogData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DialogsStateImplCopyWith<$Res>
    implements $DialogsStateCopyWith<$Res> {
  factory _$$DialogsStateImplCopyWith(
          _$DialogsStateImpl value, $Res Function(_$DialogsStateImpl) then) =
      __$$DialogsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DialogData> dialogs});
}

/// @nodoc
class __$$DialogsStateImplCopyWithImpl<$Res>
    extends _$DialogsStateCopyWithImpl<$Res, _$DialogsStateImpl>
    implements _$$DialogsStateImplCopyWith<$Res> {
  __$$DialogsStateImplCopyWithImpl(
      _$DialogsStateImpl _value, $Res Function(_$DialogsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DialogsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dialogs = null,
  }) {
    return _then(_$DialogsStateImpl(
      dialogs: null == dialogs
          ? _value._dialogs
          : dialogs // ignore: cast_nullable_to_non_nullable
              as List<DialogData>,
    ));
  }
}

/// @nodoc

class _$DialogsStateImpl with DiagnosticableTreeMixin implements _DialogsState {
  _$DialogsStateImpl({final List<DialogData> dialogs = const []})
      : _dialogs = dialogs;

  final List<DialogData> _dialogs;
  @override
  @JsonKey()
  List<DialogData> get dialogs {
    if (_dialogs is EqualUnmodifiableListView) return _dialogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dialogs);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DialogsState(dialogs: $dialogs)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DialogsState'))
      ..add(DiagnosticsProperty('dialogs', dialogs));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DialogsStateImpl &&
            const DeepCollectionEquality().equals(other._dialogs, _dialogs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_dialogs));

  /// Create a copy of DialogsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DialogsStateImplCopyWith<_$DialogsStateImpl> get copyWith =>
      __$$DialogsStateImplCopyWithImpl<_$DialogsStateImpl>(this, _$identity);
}

abstract class _DialogsState implements DialogsState {
  factory _DialogsState({final List<DialogData> dialogs}) = _$DialogsStateImpl;

  @override
  List<DialogData> get dialogs;

  /// Create a copy of DialogsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DialogsStateImplCopyWith<_$DialogsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DialogData {
  String Function(BuildContext) get message =>
      throw _privateConstructorUsedError;
  List<String> Function(BuildContext) get actions =>
      throw _privateConstructorUsedError;
  Completer<int> get completer => throw _privateConstructorUsedError;
  @Assert("!isMFM || isMFM && accountContext != null",
      "account context must not be null when isMFM is true")
  AccountContext? get accountContext => throw _privateConstructorUsedError;
  bool get isMFM => throw _privateConstructorUsedError;

  /// Create a copy of DialogData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DialogDataCopyWith<DialogData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DialogDataCopyWith<$Res> {
  factory $DialogDataCopyWith(
          DialogData value, $Res Function(DialogData) then) =
      _$DialogDataCopyWithImpl<$Res, DialogData>;
  @useResult
  $Res call(
      {String Function(BuildContext) message,
      List<String> Function(BuildContext) actions,
      Completer<int> completer,
      @Assert("!isMFM || isMFM && accountContext != null",
          "account context must not be null when isMFM is true")
      AccountContext? accountContext,
      bool isMFM});

  $AccountContextCopyWith<$Res>? get accountContext;
}

/// @nodoc
class _$DialogDataCopyWithImpl<$Res, $Val extends DialogData>
    implements $DialogDataCopyWith<$Res> {
  _$DialogDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DialogData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? actions = null,
    Object? completer = null,
    Object? accountContext = freezed,
    Object? isMFM = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String Function(BuildContext),
      actions: null == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<String> Function(BuildContext),
      completer: null == completer
          ? _value.completer
          : completer // ignore: cast_nullable_to_non_nullable
              as Completer<int>,
      accountContext: freezed == accountContext
          ? _value.accountContext
          : accountContext // ignore: cast_nullable_to_non_nullable
              as AccountContext?,
      isMFM: null == isMFM
          ? _value.isMFM
          : isMFM // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of DialogData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountContextCopyWith<$Res>? get accountContext {
    if (_value.accountContext == null) {
      return null;
    }

    return $AccountContextCopyWith<$Res>(_value.accountContext!, (value) {
      return _then(_value.copyWith(accountContext: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DialogDataImplCopyWith<$Res>
    implements $DialogDataCopyWith<$Res> {
  factory _$$DialogDataImplCopyWith(
          _$DialogDataImpl value, $Res Function(_$DialogDataImpl) then) =
      __$$DialogDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String Function(BuildContext) message,
      List<String> Function(BuildContext) actions,
      Completer<int> completer,
      @Assert("!isMFM || isMFM && accountContext != null",
          "account context must not be null when isMFM is true")
      AccountContext? accountContext,
      bool isMFM});

  @override
  $AccountContextCopyWith<$Res>? get accountContext;
}

/// @nodoc
class __$$DialogDataImplCopyWithImpl<$Res>
    extends _$DialogDataCopyWithImpl<$Res, _$DialogDataImpl>
    implements _$$DialogDataImplCopyWith<$Res> {
  __$$DialogDataImplCopyWithImpl(
      _$DialogDataImpl _value, $Res Function(_$DialogDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of DialogData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? actions = null,
    Object? completer = null,
    Object? accountContext = freezed,
    Object? isMFM = null,
  }) {
    return _then(_$DialogDataImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String Function(BuildContext),
      actions: null == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<String> Function(BuildContext),
      completer: null == completer
          ? _value.completer
          : completer // ignore: cast_nullable_to_non_nullable
              as Completer<int>,
      accountContext: freezed == accountContext
          ? _value.accountContext
          : accountContext // ignore: cast_nullable_to_non_nullable
              as AccountContext?,
      isMFM: null == isMFM
          ? _value.isMFM
          : isMFM // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DialogDataImpl with DiagnosticableTreeMixin implements _DialogData {
  _$DialogDataImpl(
      {required this.message,
      required this.actions,
      required this.completer,
      @Assert("!isMFM || isMFM && accountContext != null",
          "account context must not be null when isMFM is true")
      this.accountContext,
      this.isMFM = false});

  @override
  final String Function(BuildContext) message;
  @override
  final List<String> Function(BuildContext) actions;
  @override
  final Completer<int> completer;
  @override
  @Assert("!isMFM || isMFM && accountContext != null",
      "account context must not be null when isMFM is true")
  final AccountContext? accountContext;
  @override
  @JsonKey()
  final bool isMFM;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DialogData(message: $message, actions: $actions, completer: $completer, accountContext: $accountContext, isMFM: $isMFM)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DialogData'))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('actions', actions))
      ..add(DiagnosticsProperty('completer', completer))
      ..add(DiagnosticsProperty('accountContext', accountContext))
      ..add(DiagnosticsProperty('isMFM', isMFM));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DialogDataImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.actions, actions) || other.actions == actions) &&
            (identical(other.completer, completer) ||
                other.completer == completer) &&
            (identical(other.accountContext, accountContext) ||
                other.accountContext == accountContext) &&
            (identical(other.isMFM, isMFM) || other.isMFM == isMFM));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, actions, completer, accountContext, isMFM);

  /// Create a copy of DialogData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DialogDataImplCopyWith<_$DialogDataImpl> get copyWith =>
      __$$DialogDataImplCopyWithImpl<_$DialogDataImpl>(this, _$identity);
}

abstract class _DialogData implements DialogData {
  factory _DialogData(
      {required final String Function(BuildContext) message,
      required final List<String> Function(BuildContext) actions,
      required final Completer<int> completer,
      @Assert("!isMFM || isMFM && accountContext != null",
          "account context must not be null when isMFM is true")
      final AccountContext? accountContext,
      final bool isMFM}) = _$DialogDataImpl;

  @override
  String Function(BuildContext) get message;
  @override
  List<String> Function(BuildContext) get actions;
  @override
  Completer<int> get completer;
  @override
  @Assert("!isMFM || isMFM && accountContext != null",
      "account context must not be null when isMFM is true")
  AccountContext? get accountContext;
  @override
  bool get isMFM;

  /// Create a copy of DialogData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DialogDataImplCopyWith<_$DialogDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
