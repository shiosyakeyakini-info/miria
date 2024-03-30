// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'general_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GeneralSettings _$GeneralSettingsFromJson(Map<String, dynamic> json) {
  return _GeneralSettings.fromJson(json);
}

/// @nodoc
mixin _$GeneralSettings {
  String get lightColorThemeId => throw _privateConstructorUsedError;
  String get darkColorThemeId => throw _privateConstructorUsedError;
  ThemeColorSystem get themeColorSystem => throw _privateConstructorUsedError;

  /// NSFW設定を継承する
  NSFWInherit get nsfwInherit => throw _privateConstructorUsedError;

  /// ノートのカスタム絵文字直接タップでのリアクションを有効にする
  bool get enableDirectReaction => throw _privateConstructorUsedError;

  /// TLの自動更新を有効にする
  AutomaticPush get automaticPush => throw _privateConstructorUsedError;

  /// 動きのあるMFMを有効にする
  bool get enableAnimatedMFM => throw _privateConstructorUsedError;

  /// 長いノートを省略する
  bool get enableLongTextElipsed => throw _privateConstructorUsedError;

  /// リアクション済みノートを短くする
  bool get enableFavoritedRenoteElipsed => throw _privateConstructorUsedError;

  /// タブの位置
  TabPosition get tabPosition => throw _privateConstructorUsedError;

  /// 文字の大きさの倍率
  double get textScaleFactor => throw _privateConstructorUsedError;

  /// 使用するUnicodeの絵文字種別
  EmojiType get emojiType => throw _privateConstructorUsedError;

  /// デフォルトのフォント名
  String get defaultFontName => throw _privateConstructorUsedError;

  /// `$[font.serif のフォント名
  String get serifFontName => throw _privateConstructorUsedError;

  /// `$[font.monospace およびコードブロックのフォント名
  String get monospaceFontName => throw _privateConstructorUsedError;

  /// `$[font.cursive のフォント名
  String get cursiveFontName => throw _privateConstructorUsedError;

  /// `$[font.fantasy のフォント名
  String get fantasyFontName => throw _privateConstructorUsedError;

  /// 言語設定
  Languages get languages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeneralSettingsCopyWith<GeneralSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneralSettingsCopyWith<$Res> {
  factory $GeneralSettingsCopyWith(
          GeneralSettings value, $Res Function(GeneralSettings) then) =
      _$GeneralSettingsCopyWithImpl<$Res, GeneralSettings>;
  @useResult
  $Res call(
      {String lightColorThemeId,
      String darkColorThemeId,
      ThemeColorSystem themeColorSystem,
      NSFWInherit nsfwInherit,
      bool enableDirectReaction,
      AutomaticPush automaticPush,
      bool enableAnimatedMFM,
      bool enableLongTextElipsed,
      bool enableFavoritedRenoteElipsed,
      TabPosition tabPosition,
      double textScaleFactor,
      EmojiType emojiType,
      String defaultFontName,
      String serifFontName,
      String monospaceFontName,
      String cursiveFontName,
      String fantasyFontName,
      Languages languages});
}

/// @nodoc
class _$GeneralSettingsCopyWithImpl<$Res, $Val extends GeneralSettings>
    implements $GeneralSettingsCopyWith<$Res> {
  _$GeneralSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lightColorThemeId = null,
    Object? darkColorThemeId = null,
    Object? themeColorSystem = null,
    Object? nsfwInherit = null,
    Object? enableDirectReaction = null,
    Object? automaticPush = null,
    Object? enableAnimatedMFM = null,
    Object? enableLongTextElipsed = null,
    Object? enableFavoritedRenoteElipsed = null,
    Object? tabPosition = null,
    Object? textScaleFactor = null,
    Object? emojiType = null,
    Object? defaultFontName = null,
    Object? serifFontName = null,
    Object? monospaceFontName = null,
    Object? cursiveFontName = null,
    Object? fantasyFontName = null,
    Object? languages = null,
  }) {
    return _then(_value.copyWith(
      lightColorThemeId: null == lightColorThemeId
          ? _value.lightColorThemeId
          : lightColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      darkColorThemeId: null == darkColorThemeId
          ? _value.darkColorThemeId
          : darkColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      themeColorSystem: null == themeColorSystem
          ? _value.themeColorSystem
          : themeColorSystem // ignore: cast_nullable_to_non_nullable
              as ThemeColorSystem,
      nsfwInherit: null == nsfwInherit
          ? _value.nsfwInherit
          : nsfwInherit // ignore: cast_nullable_to_non_nullable
              as NSFWInherit,
      enableDirectReaction: null == enableDirectReaction
          ? _value.enableDirectReaction
          : enableDirectReaction // ignore: cast_nullable_to_non_nullable
              as bool,
      automaticPush: null == automaticPush
          ? _value.automaticPush
          : automaticPush // ignore: cast_nullable_to_non_nullable
              as AutomaticPush,
      enableAnimatedMFM: null == enableAnimatedMFM
          ? _value.enableAnimatedMFM
          : enableAnimatedMFM // ignore: cast_nullable_to_non_nullable
              as bool,
      enableLongTextElipsed: null == enableLongTextElipsed
          ? _value.enableLongTextElipsed
          : enableLongTextElipsed // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFavoritedRenoteElipsed: null == enableFavoritedRenoteElipsed
          ? _value.enableFavoritedRenoteElipsed
          : enableFavoritedRenoteElipsed // ignore: cast_nullable_to_non_nullable
              as bool,
      tabPosition: null == tabPosition
          ? _value.tabPosition
          : tabPosition // ignore: cast_nullable_to_non_nullable
              as TabPosition,
      textScaleFactor: null == textScaleFactor
          ? _value.textScaleFactor
          : textScaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      emojiType: null == emojiType
          ? _value.emojiType
          : emojiType // ignore: cast_nullable_to_non_nullable
              as EmojiType,
      defaultFontName: null == defaultFontName
          ? _value.defaultFontName
          : defaultFontName // ignore: cast_nullable_to_non_nullable
              as String,
      serifFontName: null == serifFontName
          ? _value.serifFontName
          : serifFontName // ignore: cast_nullable_to_non_nullable
              as String,
      monospaceFontName: null == monospaceFontName
          ? _value.monospaceFontName
          : monospaceFontName // ignore: cast_nullable_to_non_nullable
              as String,
      cursiveFontName: null == cursiveFontName
          ? _value.cursiveFontName
          : cursiveFontName // ignore: cast_nullable_to_non_nullable
              as String,
      fantasyFontName: null == fantasyFontName
          ? _value.fantasyFontName
          : fantasyFontName // ignore: cast_nullable_to_non_nullable
              as String,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as Languages,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeneralSettingsImplCopyWith<$Res>
    implements $GeneralSettingsCopyWith<$Res> {
  factory _$$GeneralSettingsImplCopyWith(_$GeneralSettingsImpl value,
          $Res Function(_$GeneralSettingsImpl) then) =
      __$$GeneralSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String lightColorThemeId,
      String darkColorThemeId,
      ThemeColorSystem themeColorSystem,
      NSFWInherit nsfwInherit,
      bool enableDirectReaction,
      AutomaticPush automaticPush,
      bool enableAnimatedMFM,
      bool enableLongTextElipsed,
      bool enableFavoritedRenoteElipsed,
      TabPosition tabPosition,
      double textScaleFactor,
      EmojiType emojiType,
      String defaultFontName,
      String serifFontName,
      String monospaceFontName,
      String cursiveFontName,
      String fantasyFontName,
      Languages languages});
}

/// @nodoc
class __$$GeneralSettingsImplCopyWithImpl<$Res>
    extends _$GeneralSettingsCopyWithImpl<$Res, _$GeneralSettingsImpl>
    implements _$$GeneralSettingsImplCopyWith<$Res> {
  __$$GeneralSettingsImplCopyWithImpl(
      _$GeneralSettingsImpl _value, $Res Function(_$GeneralSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lightColorThemeId = null,
    Object? darkColorThemeId = null,
    Object? themeColorSystem = null,
    Object? nsfwInherit = null,
    Object? enableDirectReaction = null,
    Object? automaticPush = null,
    Object? enableAnimatedMFM = null,
    Object? enableLongTextElipsed = null,
    Object? enableFavoritedRenoteElipsed = null,
    Object? tabPosition = null,
    Object? textScaleFactor = null,
    Object? emojiType = null,
    Object? defaultFontName = null,
    Object? serifFontName = null,
    Object? monospaceFontName = null,
    Object? cursiveFontName = null,
    Object? fantasyFontName = null,
    Object? languages = null,
  }) {
    return _then(_$GeneralSettingsImpl(
      lightColorThemeId: null == lightColorThemeId
          ? _value.lightColorThemeId
          : lightColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      darkColorThemeId: null == darkColorThemeId
          ? _value.darkColorThemeId
          : darkColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      themeColorSystem: null == themeColorSystem
          ? _value.themeColorSystem
          : themeColorSystem // ignore: cast_nullable_to_non_nullable
              as ThemeColorSystem,
      nsfwInherit: null == nsfwInherit
          ? _value.nsfwInherit
          : nsfwInherit // ignore: cast_nullable_to_non_nullable
              as NSFWInherit,
      enableDirectReaction: null == enableDirectReaction
          ? _value.enableDirectReaction
          : enableDirectReaction // ignore: cast_nullable_to_non_nullable
              as bool,
      automaticPush: null == automaticPush
          ? _value.automaticPush
          : automaticPush // ignore: cast_nullable_to_non_nullable
              as AutomaticPush,
      enableAnimatedMFM: null == enableAnimatedMFM
          ? _value.enableAnimatedMFM
          : enableAnimatedMFM // ignore: cast_nullable_to_non_nullable
              as bool,
      enableLongTextElipsed: null == enableLongTextElipsed
          ? _value.enableLongTextElipsed
          : enableLongTextElipsed // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFavoritedRenoteElipsed: null == enableFavoritedRenoteElipsed
          ? _value.enableFavoritedRenoteElipsed
          : enableFavoritedRenoteElipsed // ignore: cast_nullable_to_non_nullable
              as bool,
      tabPosition: null == tabPosition
          ? _value.tabPosition
          : tabPosition // ignore: cast_nullable_to_non_nullable
              as TabPosition,
      textScaleFactor: null == textScaleFactor
          ? _value.textScaleFactor
          : textScaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      emojiType: null == emojiType
          ? _value.emojiType
          : emojiType // ignore: cast_nullable_to_non_nullable
              as EmojiType,
      defaultFontName: null == defaultFontName
          ? _value.defaultFontName
          : defaultFontName // ignore: cast_nullable_to_non_nullable
              as String,
      serifFontName: null == serifFontName
          ? _value.serifFontName
          : serifFontName // ignore: cast_nullable_to_non_nullable
              as String,
      monospaceFontName: null == monospaceFontName
          ? _value.monospaceFontName
          : monospaceFontName // ignore: cast_nullable_to_non_nullable
              as String,
      cursiveFontName: null == cursiveFontName
          ? _value.cursiveFontName
          : cursiveFontName // ignore: cast_nullable_to_non_nullable
              as String,
      fantasyFontName: null == fantasyFontName
          ? _value.fantasyFontName
          : fantasyFontName // ignore: cast_nullable_to_non_nullable
              as String,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as Languages,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneralSettingsImpl implements _GeneralSettings {
  const _$GeneralSettingsImpl(
      {this.lightColorThemeId = "",
      this.darkColorThemeId = "",
      this.themeColorSystem = ThemeColorSystem.system,
      this.nsfwInherit = NSFWInherit.inherit,
      this.enableDirectReaction = false,
      this.automaticPush = AutomaticPush.none,
      this.enableAnimatedMFM = true,
      this.enableLongTextElipsed = false,
      this.enableFavoritedRenoteElipsed = true,
      this.tabPosition = TabPosition.top,
      this.textScaleFactor = 1.0,
      this.emojiType = EmojiType.twemoji,
      this.defaultFontName = "",
      this.serifFontName = "",
      this.monospaceFontName = "",
      this.cursiveFontName = "",
      this.fantasyFontName = "",
      this.languages = Languages.jaJP});

  factory _$GeneralSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneralSettingsImplFromJson(json);

  @override
  @JsonKey()
  final String lightColorThemeId;
  @override
  @JsonKey()
  final String darkColorThemeId;
  @override
  @JsonKey()
  final ThemeColorSystem themeColorSystem;

  /// NSFW設定を継承する
  @override
  @JsonKey()
  final NSFWInherit nsfwInherit;

  /// ノートのカスタム絵文字直接タップでのリアクションを有効にする
  @override
  @JsonKey()
  final bool enableDirectReaction;

  /// TLの自動更新を有効にする
  @override
  @JsonKey()
  final AutomaticPush automaticPush;

  /// 動きのあるMFMを有効にする
  @override
  @JsonKey()
  final bool enableAnimatedMFM;

  /// 長いノートを省略する
  @override
  @JsonKey()
  final bool enableLongTextElipsed;

  /// リアクション済みノートを短くする
  @override
  @JsonKey()
  final bool enableFavoritedRenoteElipsed;

  /// タブの位置
  @override
  @JsonKey()
  final TabPosition tabPosition;

  /// 文字の大きさの倍率
  @override
  @JsonKey()
  final double textScaleFactor;

  /// 使用するUnicodeの絵文字種別
  @override
  @JsonKey()
  final EmojiType emojiType;

  /// デフォルトのフォント名
  @override
  @JsonKey()
  final String defaultFontName;

  /// `$[font.serif のフォント名
  @override
  @JsonKey()
  final String serifFontName;

  /// `$[font.monospace およびコードブロックのフォント名
  @override
  @JsonKey()
  final String monospaceFontName;

  /// `$[font.cursive のフォント名
  @override
  @JsonKey()
  final String cursiveFontName;

  /// `$[font.fantasy のフォント名
  @override
  @JsonKey()
  final String fantasyFontName;

  /// 言語設定
  @override
  @JsonKey()
  final Languages languages;

  @override
  String toString() {
    return 'GeneralSettings(lightColorThemeId: $lightColorThemeId, darkColorThemeId: $darkColorThemeId, themeColorSystem: $themeColorSystem, nsfwInherit: $nsfwInherit, enableDirectReaction: $enableDirectReaction, automaticPush: $automaticPush, enableAnimatedMFM: $enableAnimatedMFM, enableLongTextElipsed: $enableLongTextElipsed, enableFavoritedRenoteElipsed: $enableFavoritedRenoteElipsed, tabPosition: $tabPosition, textScaleFactor: $textScaleFactor, emojiType: $emojiType, defaultFontName: $defaultFontName, serifFontName: $serifFontName, monospaceFontName: $monospaceFontName, cursiveFontName: $cursiveFontName, fantasyFontName: $fantasyFontName, languages: $languages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneralSettingsImpl &&
            (identical(other.lightColorThemeId, lightColorThemeId) ||
                other.lightColorThemeId == lightColorThemeId) &&
            (identical(other.darkColorThemeId, darkColorThemeId) ||
                other.darkColorThemeId == darkColorThemeId) &&
            (identical(other.themeColorSystem, themeColorSystem) ||
                other.themeColorSystem == themeColorSystem) &&
            (identical(other.nsfwInherit, nsfwInherit) ||
                other.nsfwInherit == nsfwInherit) &&
            (identical(other.enableDirectReaction, enableDirectReaction) ||
                other.enableDirectReaction == enableDirectReaction) &&
            (identical(other.automaticPush, automaticPush) ||
                other.automaticPush == automaticPush) &&
            (identical(other.enableAnimatedMFM, enableAnimatedMFM) ||
                other.enableAnimatedMFM == enableAnimatedMFM) &&
            (identical(other.enableLongTextElipsed, enableLongTextElipsed) ||
                other.enableLongTextElipsed == enableLongTextElipsed) &&
            (identical(other.enableFavoritedRenoteElipsed,
                    enableFavoritedRenoteElipsed) ||
                other.enableFavoritedRenoteElipsed ==
                    enableFavoritedRenoteElipsed) &&
            (identical(other.tabPosition, tabPosition) ||
                other.tabPosition == tabPosition) &&
            (identical(other.textScaleFactor, textScaleFactor) ||
                other.textScaleFactor == textScaleFactor) &&
            (identical(other.emojiType, emojiType) ||
                other.emojiType == emojiType) &&
            (identical(other.defaultFontName, defaultFontName) ||
                other.defaultFontName == defaultFontName) &&
            (identical(other.serifFontName, serifFontName) ||
                other.serifFontName == serifFontName) &&
            (identical(other.monospaceFontName, monospaceFontName) ||
                other.monospaceFontName == monospaceFontName) &&
            (identical(other.cursiveFontName, cursiveFontName) ||
                other.cursiveFontName == cursiveFontName) &&
            (identical(other.fantasyFontName, fantasyFontName) ||
                other.fantasyFontName == fantasyFontName) &&
            (identical(other.languages, languages) ||
                other.languages == languages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lightColorThemeId,
      darkColorThemeId,
      themeColorSystem,
      nsfwInherit,
      enableDirectReaction,
      automaticPush,
      enableAnimatedMFM,
      enableLongTextElipsed,
      enableFavoritedRenoteElipsed,
      tabPosition,
      textScaleFactor,
      emojiType,
      defaultFontName,
      serifFontName,
      monospaceFontName,
      cursiveFontName,
      fantasyFontName,
      languages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneralSettingsImplCopyWith<_$GeneralSettingsImpl> get copyWith =>
      __$$GeneralSettingsImplCopyWithImpl<_$GeneralSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneralSettingsImplToJson(
      this,
    );
  }
}

abstract class _GeneralSettings implements GeneralSettings {
  const factory _GeneralSettings(
      {final String lightColorThemeId,
      final String darkColorThemeId,
      final ThemeColorSystem themeColorSystem,
      final NSFWInherit nsfwInherit,
      final bool enableDirectReaction,
      final AutomaticPush automaticPush,
      final bool enableAnimatedMFM,
      final bool enableLongTextElipsed,
      final bool enableFavoritedRenoteElipsed,
      final TabPosition tabPosition,
      final double textScaleFactor,
      final EmojiType emojiType,
      final String defaultFontName,
      final String serifFontName,
      final String monospaceFontName,
      final String cursiveFontName,
      final String fantasyFontName,
      final Languages languages}) = _$GeneralSettingsImpl;

  factory _GeneralSettings.fromJson(Map<String, dynamic> json) =
      _$GeneralSettingsImpl.fromJson;

  @override
  String get lightColorThemeId;
  @override
  String get darkColorThemeId;
  @override
  ThemeColorSystem get themeColorSystem;
  @override

  /// NSFW設定を継承する
  NSFWInherit get nsfwInherit;
  @override

  /// ノートのカスタム絵文字直接タップでのリアクションを有効にする
  bool get enableDirectReaction;
  @override

  /// TLの自動更新を有効にする
  AutomaticPush get automaticPush;
  @override

  /// 動きのあるMFMを有効にする
  bool get enableAnimatedMFM;
  @override

  /// 長いノートを省略する
  bool get enableLongTextElipsed;
  @override

  /// リアクション済みノートを短くする
  bool get enableFavoritedRenoteElipsed;
  @override

  /// タブの位置
  TabPosition get tabPosition;
  @override

  /// 文字の大きさの倍率
  double get textScaleFactor;
  @override

  /// 使用するUnicodeの絵文字種別
  EmojiType get emojiType;
  @override

  /// デフォルトのフォント名
  String get defaultFontName;
  @override

  /// `$[font.serif のフォント名
  String get serifFontName;
  @override

  /// `$[font.monospace およびコードブロックのフォント名
  String get monospaceFontName;
  @override

  /// `$[font.cursive のフォント名
  String get cursiveFontName;
  @override

  /// `$[font.fantasy のフォント名
  String get fantasyFontName;
  @override

  /// 言語設定
  Languages get languages;
  @override
  @JsonKey(ignore: true)
  _$$GeneralSettingsImplCopyWith<_$GeneralSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
