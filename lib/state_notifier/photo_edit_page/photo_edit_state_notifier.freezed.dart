// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_edit_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotoEdit {
  bool get clipMode;
  bool get colorFilterMode;
  List<ColorFilterPreview> get colorFilterPreviewImages;
  List<String> get adaptivePresets;
  bool get isInitialized;
  Uint8List? get initialImage;
  Uint8List? get editedImage;
  Offset get cropOffset;
  Size get cropSize;
  Size get defaultSize;
  Size get actualSize;
  int get angle;
  List<EditedEmojiData> get emojis;
  int? get selectedEmojiIndex;

  /// Create a copy of PhotoEdit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PhotoEditCopyWith<PhotoEdit> get copyWith =>
      _$PhotoEditCopyWithImpl<PhotoEdit>(this as PhotoEdit, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PhotoEdit &&
            (identical(other.clipMode, clipMode) ||
                other.clipMode == clipMode) &&
            (identical(other.colorFilterMode, colorFilterMode) ||
                other.colorFilterMode == colorFilterMode) &&
            const DeepCollectionEquality().equals(
                other.colorFilterPreviewImages, colorFilterPreviewImages) &&
            const DeepCollectionEquality()
                .equals(other.adaptivePresets, adaptivePresets) &&
            (identical(other.isInitialized, isInitialized) ||
                other.isInitialized == isInitialized) &&
            const DeepCollectionEquality()
                .equals(other.initialImage, initialImage) &&
            const DeepCollectionEquality()
                .equals(other.editedImage, editedImage) &&
            (identical(other.cropOffset, cropOffset) ||
                other.cropOffset == cropOffset) &&
            (identical(other.cropSize, cropSize) ||
                other.cropSize == cropSize) &&
            (identical(other.defaultSize, defaultSize) ||
                other.defaultSize == defaultSize) &&
            (identical(other.actualSize, actualSize) ||
                other.actualSize == actualSize) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            const DeepCollectionEquality().equals(other.emojis, emojis) &&
            (identical(other.selectedEmojiIndex, selectedEmojiIndex) ||
                other.selectedEmojiIndex == selectedEmojiIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      clipMode,
      colorFilterMode,
      const DeepCollectionEquality().hash(colorFilterPreviewImages),
      const DeepCollectionEquality().hash(adaptivePresets),
      isInitialized,
      const DeepCollectionEquality().hash(initialImage),
      const DeepCollectionEquality().hash(editedImage),
      cropOffset,
      cropSize,
      defaultSize,
      actualSize,
      angle,
      const DeepCollectionEquality().hash(emojis),
      selectedEmojiIndex);

  @override
  String toString() {
    return 'PhotoEdit(clipMode: $clipMode, colorFilterMode: $colorFilterMode, colorFilterPreviewImages: $colorFilterPreviewImages, adaptivePresets: $adaptivePresets, isInitialized: $isInitialized, initialImage: $initialImage, editedImage: $editedImage, cropOffset: $cropOffset, cropSize: $cropSize, defaultSize: $defaultSize, actualSize: $actualSize, angle: $angle, emojis: $emojis, selectedEmojiIndex: $selectedEmojiIndex)';
  }
}

/// @nodoc
abstract mixin class $PhotoEditCopyWith<$Res> {
  factory $PhotoEditCopyWith(PhotoEdit value, $Res Function(PhotoEdit) _then) =
      _$PhotoEditCopyWithImpl;
  @useResult
  $Res call(
      {bool clipMode,
      bool colorFilterMode,
      List<ColorFilterPreview> colorFilterPreviewImages,
      List<String> adaptivePresets,
      bool isInitialized,
      Uint8List? initialImage,
      Uint8List? editedImage,
      Offset cropOffset,
      Size cropSize,
      Size defaultSize,
      Size actualSize,
      int angle,
      List<EditedEmojiData> emojis,
      int? selectedEmojiIndex});
}

/// @nodoc
class _$PhotoEditCopyWithImpl<$Res> implements $PhotoEditCopyWith<$Res> {
  _$PhotoEditCopyWithImpl(this._self, this._then);

  final PhotoEdit _self;
  final $Res Function(PhotoEdit) _then;

  /// Create a copy of PhotoEdit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clipMode = null,
    Object? colorFilterMode = null,
    Object? colorFilterPreviewImages = null,
    Object? adaptivePresets = null,
    Object? isInitialized = null,
    Object? initialImage = freezed,
    Object? editedImage = freezed,
    Object? cropOffset = null,
    Object? cropSize = null,
    Object? defaultSize = null,
    Object? actualSize = null,
    Object? angle = null,
    Object? emojis = null,
    Object? selectedEmojiIndex = freezed,
  }) {
    return _then(_self.copyWith(
      clipMode: null == clipMode
          ? _self.clipMode
          : clipMode // ignore: cast_nullable_to_non_nullable
              as bool,
      colorFilterMode: null == colorFilterMode
          ? _self.colorFilterMode
          : colorFilterMode // ignore: cast_nullable_to_non_nullable
              as bool,
      colorFilterPreviewImages: null == colorFilterPreviewImages
          ? _self.colorFilterPreviewImages
          : colorFilterPreviewImages // ignore: cast_nullable_to_non_nullable
              as List<ColorFilterPreview>,
      adaptivePresets: null == adaptivePresets
          ? _self.adaptivePresets
          : adaptivePresets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isInitialized: null == isInitialized
          ? _self.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      initialImage: freezed == initialImage
          ? _self.initialImage
          : initialImage // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      editedImage: freezed == editedImage
          ? _self.editedImage
          : editedImage // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      cropOffset: null == cropOffset
          ? _self.cropOffset
          : cropOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      cropSize: null == cropSize
          ? _self.cropSize
          : cropSize // ignore: cast_nullable_to_non_nullable
              as Size,
      defaultSize: null == defaultSize
          ? _self.defaultSize
          : defaultSize // ignore: cast_nullable_to_non_nullable
              as Size,
      actualSize: null == actualSize
          ? _self.actualSize
          : actualSize // ignore: cast_nullable_to_non_nullable
              as Size,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as int,
      emojis: null == emojis
          ? _self.emojis
          : emojis // ignore: cast_nullable_to_non_nullable
              as List<EditedEmojiData>,
      selectedEmojiIndex: freezed == selectedEmojiIndex
          ? _self.selectedEmojiIndex
          : selectedEmojiIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _PhotoEdit implements PhotoEdit {
  const _PhotoEdit(
      {this.clipMode = false,
      this.colorFilterMode = false,
      final List<ColorFilterPreview> colorFilterPreviewImages = const [],
      final List<String> adaptivePresets = const [],
      this.isInitialized = false,
      this.initialImage,
      this.editedImage,
      this.cropOffset = const Offset(0, 0),
      this.cropSize = Size.zero,
      this.defaultSize = Size.zero,
      this.actualSize = Size.zero,
      this.angle = 0,
      final List<EditedEmojiData> emojis = const [],
      this.selectedEmojiIndex})
      : _colorFilterPreviewImages = colorFilterPreviewImages,
        _adaptivePresets = adaptivePresets,
        _emojis = emojis;

  @override
  @JsonKey()
  final bool clipMode;
  @override
  @JsonKey()
  final bool colorFilterMode;
  final List<ColorFilterPreview> _colorFilterPreviewImages;
  @override
  @JsonKey()
  List<ColorFilterPreview> get colorFilterPreviewImages {
    if (_colorFilterPreviewImages is EqualUnmodifiableListView)
      return _colorFilterPreviewImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colorFilterPreviewImages);
  }

  final List<String> _adaptivePresets;
  @override
  @JsonKey()
  List<String> get adaptivePresets {
    if (_adaptivePresets is EqualUnmodifiableListView) return _adaptivePresets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adaptivePresets);
  }

  @override
  @JsonKey()
  final bool isInitialized;
  @override
  final Uint8List? initialImage;
  @override
  final Uint8List? editedImage;
  @override
  @JsonKey()
  final Offset cropOffset;
  @override
  @JsonKey()
  final Size cropSize;
  @override
  @JsonKey()
  final Size defaultSize;
  @override
  @JsonKey()
  final Size actualSize;
  @override
  @JsonKey()
  final int angle;
  final List<EditedEmojiData> _emojis;
  @override
  @JsonKey()
  List<EditedEmojiData> get emojis {
    if (_emojis is EqualUnmodifiableListView) return _emojis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emojis);
  }

  @override
  final int? selectedEmojiIndex;

  /// Create a copy of PhotoEdit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PhotoEditCopyWith<_PhotoEdit> get copyWith =>
      __$PhotoEditCopyWithImpl<_PhotoEdit>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PhotoEdit &&
            (identical(other.clipMode, clipMode) ||
                other.clipMode == clipMode) &&
            (identical(other.colorFilterMode, colorFilterMode) ||
                other.colorFilterMode == colorFilterMode) &&
            const DeepCollectionEquality().equals(
                other._colorFilterPreviewImages, _colorFilterPreviewImages) &&
            const DeepCollectionEquality()
                .equals(other._adaptivePresets, _adaptivePresets) &&
            (identical(other.isInitialized, isInitialized) ||
                other.isInitialized == isInitialized) &&
            const DeepCollectionEquality()
                .equals(other.initialImage, initialImage) &&
            const DeepCollectionEquality()
                .equals(other.editedImage, editedImage) &&
            (identical(other.cropOffset, cropOffset) ||
                other.cropOffset == cropOffset) &&
            (identical(other.cropSize, cropSize) ||
                other.cropSize == cropSize) &&
            (identical(other.defaultSize, defaultSize) ||
                other.defaultSize == defaultSize) &&
            (identical(other.actualSize, actualSize) ||
                other.actualSize == actualSize) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            const DeepCollectionEquality().equals(other._emojis, _emojis) &&
            (identical(other.selectedEmojiIndex, selectedEmojiIndex) ||
                other.selectedEmojiIndex == selectedEmojiIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      clipMode,
      colorFilterMode,
      const DeepCollectionEquality().hash(_colorFilterPreviewImages),
      const DeepCollectionEquality().hash(_adaptivePresets),
      isInitialized,
      const DeepCollectionEquality().hash(initialImage),
      const DeepCollectionEquality().hash(editedImage),
      cropOffset,
      cropSize,
      defaultSize,
      actualSize,
      angle,
      const DeepCollectionEquality().hash(_emojis),
      selectedEmojiIndex);

  @override
  String toString() {
    return 'PhotoEdit(clipMode: $clipMode, colorFilterMode: $colorFilterMode, colorFilterPreviewImages: $colorFilterPreviewImages, adaptivePresets: $adaptivePresets, isInitialized: $isInitialized, initialImage: $initialImage, editedImage: $editedImage, cropOffset: $cropOffset, cropSize: $cropSize, defaultSize: $defaultSize, actualSize: $actualSize, angle: $angle, emojis: $emojis, selectedEmojiIndex: $selectedEmojiIndex)';
  }
}

/// @nodoc
abstract mixin class _$PhotoEditCopyWith<$Res>
    implements $PhotoEditCopyWith<$Res> {
  factory _$PhotoEditCopyWith(
          _PhotoEdit value, $Res Function(_PhotoEdit) _then) =
      __$PhotoEditCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool clipMode,
      bool colorFilterMode,
      List<ColorFilterPreview> colorFilterPreviewImages,
      List<String> adaptivePresets,
      bool isInitialized,
      Uint8List? initialImage,
      Uint8List? editedImage,
      Offset cropOffset,
      Size cropSize,
      Size defaultSize,
      Size actualSize,
      int angle,
      List<EditedEmojiData> emojis,
      int? selectedEmojiIndex});
}

/// @nodoc
class __$PhotoEditCopyWithImpl<$Res> implements _$PhotoEditCopyWith<$Res> {
  __$PhotoEditCopyWithImpl(this._self, this._then);

  final _PhotoEdit _self;
  final $Res Function(_PhotoEdit) _then;

  /// Create a copy of PhotoEdit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? clipMode = null,
    Object? colorFilterMode = null,
    Object? colorFilterPreviewImages = null,
    Object? adaptivePresets = null,
    Object? isInitialized = null,
    Object? initialImage = freezed,
    Object? editedImage = freezed,
    Object? cropOffset = null,
    Object? cropSize = null,
    Object? defaultSize = null,
    Object? actualSize = null,
    Object? angle = null,
    Object? emojis = null,
    Object? selectedEmojiIndex = freezed,
  }) {
    return _then(_PhotoEdit(
      clipMode: null == clipMode
          ? _self.clipMode
          : clipMode // ignore: cast_nullable_to_non_nullable
              as bool,
      colorFilterMode: null == colorFilterMode
          ? _self.colorFilterMode
          : colorFilterMode // ignore: cast_nullable_to_non_nullable
              as bool,
      colorFilterPreviewImages: null == colorFilterPreviewImages
          ? _self._colorFilterPreviewImages
          : colorFilterPreviewImages // ignore: cast_nullable_to_non_nullable
              as List<ColorFilterPreview>,
      adaptivePresets: null == adaptivePresets
          ? _self._adaptivePresets
          : adaptivePresets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isInitialized: null == isInitialized
          ? _self.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      initialImage: freezed == initialImage
          ? _self.initialImage
          : initialImage // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      editedImage: freezed == editedImage
          ? _self.editedImage
          : editedImage // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      cropOffset: null == cropOffset
          ? _self.cropOffset
          : cropOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      cropSize: null == cropSize
          ? _self.cropSize
          : cropSize // ignore: cast_nullable_to_non_nullable
              as Size,
      defaultSize: null == defaultSize
          ? _self.defaultSize
          : defaultSize // ignore: cast_nullable_to_non_nullable
              as Size,
      actualSize: null == actualSize
          ? _self.actualSize
          : actualSize // ignore: cast_nullable_to_non_nullable
              as Size,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as int,
      emojis: null == emojis
          ? _self._emojis
          : emojis // ignore: cast_nullable_to_non_nullable
              as List<EditedEmojiData>,
      selectedEmojiIndex: freezed == selectedEmojiIndex
          ? _self.selectedEmojiIndex
          : selectedEmojiIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$ColorFilterPreview {
  String get name;
  Uint8List? get image;

  /// Create a copy of ColorFilterPreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ColorFilterPreviewCopyWith<ColorFilterPreview> get copyWith =>
      _$ColorFilterPreviewCopyWithImpl<ColorFilterPreview>(
          this as ColorFilterPreview, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ColorFilterPreview &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.image, image));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(image));

  @override
  String toString() {
    return 'ColorFilterPreview(name: $name, image: $image)';
  }
}

/// @nodoc
abstract mixin class $ColorFilterPreviewCopyWith<$Res> {
  factory $ColorFilterPreviewCopyWith(
          ColorFilterPreview value, $Res Function(ColorFilterPreview) _then) =
      _$ColorFilterPreviewCopyWithImpl;
  @useResult
  $Res call({String name, Uint8List? image});
}

/// @nodoc
class _$ColorFilterPreviewCopyWithImpl<$Res>
    implements $ColorFilterPreviewCopyWith<$Res> {
  _$ColorFilterPreviewCopyWithImpl(this._self, this._then);

  final ColorFilterPreview _self;
  final $Res Function(ColorFilterPreview) _then;

  /// Create a copy of ColorFilterPreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? image = freezed,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
    ));
  }
}

/// @nodoc

class _ColorFilterPreview implements ColorFilterPreview {
  const _ColorFilterPreview({required this.name, this.image});

  @override
  final String name;
  @override
  final Uint8List? image;

  /// Create a copy of ColorFilterPreview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ColorFilterPreviewCopyWith<_ColorFilterPreview> get copyWith =>
      __$ColorFilterPreviewCopyWithImpl<_ColorFilterPreview>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ColorFilterPreview &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.image, image));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(image));

  @override
  String toString() {
    return 'ColorFilterPreview(name: $name, image: $image)';
  }
}

/// @nodoc
abstract mixin class _$ColorFilterPreviewCopyWith<$Res>
    implements $ColorFilterPreviewCopyWith<$Res> {
  factory _$ColorFilterPreviewCopyWith(
          _ColorFilterPreview value, $Res Function(_ColorFilterPreview) _then) =
      __$ColorFilterPreviewCopyWithImpl;
  @override
  @useResult
  $Res call({String name, Uint8List? image});
}

/// @nodoc
class __$ColorFilterPreviewCopyWithImpl<$Res>
    implements _$ColorFilterPreviewCopyWith<$Res> {
  __$ColorFilterPreviewCopyWithImpl(this._self, this._then);

  final _ColorFilterPreview _self;
  final $Res Function(_ColorFilterPreview) _then;

  /// Create a copy of ColorFilterPreview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? image = freezed,
  }) {
    return _then(_ColorFilterPreview(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
    ));
  }
}

/// @nodoc
mixin _$EditedEmojiData {
  MisskeyEmojiData get emoji;
  double get scale;
  Offset get position;
  double get angle;

  /// Create a copy of EditedEmojiData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EditedEmojiDataCopyWith<EditedEmojiData> get copyWith =>
      _$EditedEmojiDataCopyWithImpl<EditedEmojiData>(
          this as EditedEmojiData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EditedEmojiData &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.angle, angle) || other.angle == angle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, emoji, scale, position, angle);

  @override
  String toString() {
    return 'EditedEmojiData(emoji: $emoji, scale: $scale, position: $position, angle: $angle)';
  }
}

/// @nodoc
abstract mixin class $EditedEmojiDataCopyWith<$Res> {
  factory $EditedEmojiDataCopyWith(
          EditedEmojiData value, $Res Function(EditedEmojiData) _then) =
      _$EditedEmojiDataCopyWithImpl;
  @useResult
  $Res call(
      {MisskeyEmojiData emoji, double scale, Offset position, double angle});
}

/// @nodoc
class _$EditedEmojiDataCopyWithImpl<$Res>
    implements $EditedEmojiDataCopyWith<$Res> {
  _$EditedEmojiDataCopyWithImpl(this._self, this._then);

  final EditedEmojiData _self;
  final $Res Function(EditedEmojiData) _then;

  /// Create a copy of EditedEmojiData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emoji = null,
    Object? scale = null,
    Object? position = null,
    Object? angle = null,
  }) {
    return _then(_self.copyWith(
      emoji: null == emoji
          ? _self.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as MisskeyEmojiData,
      scale: null == scale
          ? _self.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _EditedEmojiData implements EditedEmojiData {
  const _EditedEmojiData(
      {required this.emoji,
      required this.scale,
      required this.position,
      required this.angle});

  @override
  final MisskeyEmojiData emoji;
  @override
  final double scale;
  @override
  final Offset position;
  @override
  final double angle;

  /// Create a copy of EditedEmojiData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EditedEmojiDataCopyWith<_EditedEmojiData> get copyWith =>
      __$EditedEmojiDataCopyWithImpl<_EditedEmojiData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EditedEmojiData &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.angle, angle) || other.angle == angle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, emoji, scale, position, angle);

  @override
  String toString() {
    return 'EditedEmojiData(emoji: $emoji, scale: $scale, position: $position, angle: $angle)';
  }
}

/// @nodoc
abstract mixin class _$EditedEmojiDataCopyWith<$Res>
    implements $EditedEmojiDataCopyWith<$Res> {
  factory _$EditedEmojiDataCopyWith(
          _EditedEmojiData value, $Res Function(_EditedEmojiData) _then) =
      __$EditedEmojiDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MisskeyEmojiData emoji, double scale, Offset position, double angle});
}

/// @nodoc
class __$EditedEmojiDataCopyWithImpl<$Res>
    implements _$EditedEmojiDataCopyWith<$Res> {
  __$EditedEmojiDataCopyWithImpl(this._self, this._then);

  final _EditedEmojiData _self;
  final $Res Function(_EditedEmojiData) _then;

  /// Create a copy of EditedEmojiData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? emoji = null,
    Object? scale = null,
    Object? position = null,
    Object? angle = null,
  }) {
    return _then(_EditedEmojiData(
      emoji: null == emoji
          ? _self.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as MisskeyEmojiData,
      scale: null == scale
          ? _self.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
