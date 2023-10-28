// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drive_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DrivePageState {
  List<DriveFolder> get breadcrumbs => throw _privateConstructorUsedError;
  List<DriveFile> get selectedFiles => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DrivePageStateCopyWith<DrivePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrivePageStateCopyWith<$Res> {
  factory $DrivePageStateCopyWith(
          DrivePageState value, $Res Function(DrivePageState) then) =
      _$DrivePageStateCopyWithImpl<$Res, DrivePageState>;
  @useResult
  $Res call({List<DriveFolder> breadcrumbs, List<DriveFile> selectedFiles});
}

/// @nodoc
class _$DrivePageStateCopyWithImpl<$Res, $Val extends DrivePageState>
    implements $DrivePageStateCopyWith<$Res> {
  _$DrivePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breadcrumbs = null,
    Object? selectedFiles = null,
  }) {
    return _then(_value.copyWith(
      breadcrumbs: null == breadcrumbs
          ? _value.breadcrumbs
          : breadcrumbs // ignore: cast_nullable_to_non_nullable
              as List<DriveFolder>,
      selectedFiles: null == selectedFiles
          ? _value.selectedFiles
          : selectedFiles // ignore: cast_nullable_to_non_nullable
              as List<DriveFile>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DrivePageStateImplCopyWith<$Res>
    implements $DrivePageStateCopyWith<$Res> {
  factory _$$DrivePageStateImplCopyWith(_$DrivePageStateImpl value,
          $Res Function(_$DrivePageStateImpl) then) =
      __$$DrivePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DriveFolder> breadcrumbs, List<DriveFile> selectedFiles});
}

/// @nodoc
class __$$DrivePageStateImplCopyWithImpl<$Res>
    extends _$DrivePageStateCopyWithImpl<$Res, _$DrivePageStateImpl>
    implements _$$DrivePageStateImplCopyWith<$Res> {
  __$$DrivePageStateImplCopyWithImpl(
      _$DrivePageStateImpl _value, $Res Function(_$DrivePageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breadcrumbs = null,
    Object? selectedFiles = null,
  }) {
    return _then(_$DrivePageStateImpl(
      breadcrumbs: null == breadcrumbs
          ? _value._breadcrumbs
          : breadcrumbs // ignore: cast_nullable_to_non_nullable
              as List<DriveFolder>,
      selectedFiles: null == selectedFiles
          ? _value._selectedFiles
          : selectedFiles // ignore: cast_nullable_to_non_nullable
              as List<DriveFile>,
    ));
  }
}

/// @nodoc

class _$DrivePageStateImpl implements _DrivePageState {
  const _$DrivePageStateImpl(
      {final List<DriveFolder> breadcrumbs = const [],
      final List<DriveFile> selectedFiles = const []})
      : _breadcrumbs = breadcrumbs,
        _selectedFiles = selectedFiles;

  final List<DriveFolder> _breadcrumbs;
  @override
  @JsonKey()
  List<DriveFolder> get breadcrumbs {
    if (_breadcrumbs is EqualUnmodifiableListView) return _breadcrumbs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breadcrumbs);
  }

  final List<DriveFile> _selectedFiles;
  @override
  @JsonKey()
  List<DriveFile> get selectedFiles {
    if (_selectedFiles is EqualUnmodifiableListView) return _selectedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedFiles);
  }

  @override
  String toString() {
    return 'DrivePageState(breadcrumbs: $breadcrumbs, selectedFiles: $selectedFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrivePageStateImpl &&
            const DeepCollectionEquality()
                .equals(other._breadcrumbs, _breadcrumbs) &&
            const DeepCollectionEquality()
                .equals(other._selectedFiles, _selectedFiles));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_breadcrumbs),
      const DeepCollectionEquality().hash(_selectedFiles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DrivePageStateImplCopyWith<_$DrivePageStateImpl> get copyWith =>
      __$$DrivePageStateImplCopyWithImpl<_$DrivePageStateImpl>(
          this, _$identity);
}

abstract class _DrivePageState implements DrivePageState {
  const factory _DrivePageState(
      {final List<DriveFolder> breadcrumbs,
      final List<DriveFile> selectedFiles}) = _$DrivePageStateImpl;

  @override
  List<DriveFolder> get breadcrumbs;
  @override
  List<DriveFile> get selectedFiles;
  @override
  @JsonKey(ignore: true)
  _$$DrivePageStateImplCopyWith<_$DrivePageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
