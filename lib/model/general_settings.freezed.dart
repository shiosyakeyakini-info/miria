// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'general_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneralSettings {
  String get lightColorThemeId;
  String get darkColorThemeId;
  ThemeColorSystem get themeColorSystem;

  /// NSFW設定を継承する
  NSFWInherit get nsfwInherit;

  /// ノートのカスタム絵文字直接タップでのリアクションを有効にする
  bool get enableDirectReaction;

  /// TLの自動更新を有効にする
  AutomaticPush get automaticPush;

  /// 動きのあるMFMを有効にする
  bool get enableAnimatedMFM;

  /// 長いノートを省略する
  bool get enableLongTextElipsed;

  /// リアクション済みノートを短くする
  bool get enableFavoritedRenoteElipsed;

  /// タブの位置
  TabPosition get tabPosition;

  /// 文字の大きさの倍率
  double get textScaleFactor;

  /// 使用するUnicodeの絵文字種別
  EmojiType get emojiType;

  /// デフォルトのフォント名
  String get defaultFontName;

  /// `$[font.serif のフォント名
  String get serifFontName;

  /// `$[font.monospace およびコードブロックのフォント名
  String get monospaceFontName;

  /// `$[font.cursive のフォント名
  String get cursiveFontName;

  /// `$[font.fantasy のフォント名
  String get fantasyFontName;

  /// 言語設定
  Languages get languages;

  /// デッキモード
  bool get isDeckMode;

  /// Create a copy of GeneralSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GeneralSettingsCopyWith<GeneralSettings> get copyWith =>
      _$GeneralSettingsCopyWithImpl<GeneralSettings>(
          this as GeneralSettings, _$identity);

  /// Serializes this GeneralSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GeneralSettings &&
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
                other.languages == languages) &&
            (identical(other.isDeckMode, isDeckMode) ||
                other.isDeckMode == isDeckMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
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
        languages,
        isDeckMode
      ]);

  @override
  String toString() {
    return 'GeneralSettings(lightColorThemeId: $lightColorThemeId, darkColorThemeId: $darkColorThemeId, themeColorSystem: $themeColorSystem, nsfwInherit: $nsfwInherit, enableDirectReaction: $enableDirectReaction, automaticPush: $automaticPush, enableAnimatedMFM: $enableAnimatedMFM, enableLongTextElipsed: $enableLongTextElipsed, enableFavoritedRenoteElipsed: $enableFavoritedRenoteElipsed, tabPosition: $tabPosition, textScaleFactor: $textScaleFactor, emojiType: $emojiType, defaultFontName: $defaultFontName, serifFontName: $serifFontName, monospaceFontName: $monospaceFontName, cursiveFontName: $cursiveFontName, fantasyFontName: $fantasyFontName, languages: $languages, isDeckMode: $isDeckMode)';
  }
}

/// @nodoc
abstract mixin class $GeneralSettingsCopyWith<$Res> {
  factory $GeneralSettingsCopyWith(
          GeneralSettings value, $Res Function(GeneralSettings) _then) =
      _$GeneralSettingsCopyWithImpl;
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
      Languages languages,
      bool isDeckMode});
}

/// @nodoc
class _$GeneralSettingsCopyWithImpl<$Res>
    implements $GeneralSettingsCopyWith<$Res> {
  _$GeneralSettingsCopyWithImpl(this._self, this._then);

  final GeneralSettings _self;
  final $Res Function(GeneralSettings) _then;

  /// Create a copy of GeneralSettings
  /// with the given fields replaced by the non-null parameter values.
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
    Object? isDeckMode = null,
  }) {
    return _then(_self.copyWith(
      lightColorThemeId: null == lightColorThemeId
          ? _self.lightColorThemeId
          : lightColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      darkColorThemeId: null == darkColorThemeId
          ? _self.darkColorThemeId
          : darkColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      themeColorSystem: null == themeColorSystem
          ? _self.themeColorSystem
          : themeColorSystem // ignore: cast_nullable_to_non_nullable
              as ThemeColorSystem,
      nsfwInherit: null == nsfwInherit
          ? _self.nsfwInherit
          : nsfwInherit // ignore: cast_nullable_to_non_nullable
              as NSFWInherit,
      enableDirectReaction: null == enableDirectReaction
          ? _self.enableDirectReaction
          : enableDirectReaction // ignore: cast_nullable_to_non_nullable
              as bool,
      automaticPush: null == automaticPush
          ? _self.automaticPush
          : automaticPush // ignore: cast_nullable_to_non_nullable
              as AutomaticPush,
      enableAnimatedMFM: null == enableAnimatedMFM
          ? _self.enableAnimatedMFM
          : enableAnimatedMFM // ignore: cast_nullable_to_non_nullable
              as bool,
      enableLongTextElipsed: null == enableLongTextElipsed
          ? _self.enableLongTextElipsed
          : enableLongTextElipsed // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFavoritedRenoteElipsed: null == enableFavoritedRenoteElipsed
          ? _self.enableFavoritedRenoteElipsed
          : enableFavoritedRenoteElipsed // ignore: cast_nullable_to_non_nullable
              as bool,
      tabPosition: null == tabPosition
          ? _self.tabPosition
          : tabPosition // ignore: cast_nullable_to_non_nullable
              as TabPosition,
      textScaleFactor: null == textScaleFactor
          ? _self.textScaleFactor
          : textScaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      emojiType: null == emojiType
          ? _self.emojiType
          : emojiType // ignore: cast_nullable_to_non_nullable
              as EmojiType,
      defaultFontName: null == defaultFontName
          ? _self.defaultFontName
          : defaultFontName // ignore: cast_nullable_to_non_nullable
              as String,
      serifFontName: null == serifFontName
          ? _self.serifFontName
          : serifFontName // ignore: cast_nullable_to_non_nullable
              as String,
      monospaceFontName: null == monospaceFontName
          ? _self.monospaceFontName
          : monospaceFontName // ignore: cast_nullable_to_non_nullable
              as String,
      cursiveFontName: null == cursiveFontName
          ? _self.cursiveFontName
          : cursiveFontName // ignore: cast_nullable_to_non_nullable
              as String,
      fantasyFontName: null == fantasyFontName
          ? _self.fantasyFontName
          : fantasyFontName // ignore: cast_nullable_to_non_nullable
              as String,
      languages: null == languages
          ? _self.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as Languages,
      isDeckMode: null == isDeckMode
          ? _self.isDeckMode
          : isDeckMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GeneralSettings implements GeneralSettings {
  const _GeneralSettings(
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
      this.languages = Languages.jaJP,
      this.isDeckMode = false});
  factory _GeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneralSettingsFromJson(json);

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

  /// デッキモード
  @override
  @JsonKey()
  final bool isDeckMode;

  /// Create a copy of GeneralSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GeneralSettingsCopyWith<_GeneralSettings> get copyWith =>
      __$GeneralSettingsCopyWithImpl<_GeneralSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GeneralSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GeneralSettings &&
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
                other.languages == languages) &&
            (identical(other.isDeckMode, isDeckMode) ||
                other.isDeckMode == isDeckMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
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
        languages,
        isDeckMode
      ]);

  @override
  String toString() {
    return 'GeneralSettings(lightColorThemeId: $lightColorThemeId, darkColorThemeId: $darkColorThemeId, themeColorSystem: $themeColorSystem, nsfwInherit: $nsfwInherit, enableDirectReaction: $enableDirectReaction, automaticPush: $automaticPush, enableAnimatedMFM: $enableAnimatedMFM, enableLongTextElipsed: $enableLongTextElipsed, enableFavoritedRenoteElipsed: $enableFavoritedRenoteElipsed, tabPosition: $tabPosition, textScaleFactor: $textScaleFactor, emojiType: $emojiType, defaultFontName: $defaultFontName, serifFontName: $serifFontName, monospaceFontName: $monospaceFontName, cursiveFontName: $cursiveFontName, fantasyFontName: $fantasyFontName, languages: $languages, isDeckMode: $isDeckMode)';
  }
}

/// @nodoc
abstract mixin class _$GeneralSettingsCopyWith<$Res>
    implements $GeneralSettingsCopyWith<$Res> {
  factory _$GeneralSettingsCopyWith(
          _GeneralSettings value, $Res Function(_GeneralSettings) _then) =
      __$GeneralSettingsCopyWithImpl;
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
      Languages languages,
      bool isDeckMode});
}

/// @nodoc
class __$GeneralSettingsCopyWithImpl<$Res>
    implements _$GeneralSettingsCopyWith<$Res> {
  __$GeneralSettingsCopyWithImpl(this._self, this._then);

  final _GeneralSettings _self;
  final $Res Function(_GeneralSettings) _then;

  /// Create a copy of GeneralSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    Object? isDeckMode = null,
  }) {
    return _then(_GeneralSettings(
      lightColorThemeId: null == lightColorThemeId
          ? _self.lightColorThemeId
          : lightColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      darkColorThemeId: null == darkColorThemeId
          ? _self.darkColorThemeId
          : darkColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      themeColorSystem: null == themeColorSystem
          ? _self.themeColorSystem
          : themeColorSystem // ignore: cast_nullable_to_non_nullable
              as ThemeColorSystem,
      nsfwInherit: null == nsfwInherit
          ? _self.nsfwInherit
          : nsfwInherit // ignore: cast_nullable_to_non_nullable
              as NSFWInherit,
      enableDirectReaction: null == enableDirectReaction
          ? _self.enableDirectReaction
          : enableDirectReaction // ignore: cast_nullable_to_non_nullable
              as bool,
      automaticPush: null == automaticPush
          ? _self.automaticPush
          : automaticPush // ignore: cast_nullable_to_non_nullable
              as AutomaticPush,
      enableAnimatedMFM: null == enableAnimatedMFM
          ? _self.enableAnimatedMFM
          : enableAnimatedMFM // ignore: cast_nullable_to_non_nullable
              as bool,
      enableLongTextElipsed: null == enableLongTextElipsed
          ? _self.enableLongTextElipsed
          : enableLongTextElipsed // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFavoritedRenoteElipsed: null == enableFavoritedRenoteElipsed
          ? _self.enableFavoritedRenoteElipsed
          : enableFavoritedRenoteElipsed // ignore: cast_nullable_to_non_nullable
              as bool,
      tabPosition: null == tabPosition
          ? _self.tabPosition
          : tabPosition // ignore: cast_nullable_to_non_nullable
              as TabPosition,
      textScaleFactor: null == textScaleFactor
          ? _self.textScaleFactor
          : textScaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      emojiType: null == emojiType
          ? _self.emojiType
          : emojiType // ignore: cast_nullable_to_non_nullable
              as EmojiType,
      defaultFontName: null == defaultFontName
          ? _self.defaultFontName
          : defaultFontName // ignore: cast_nullable_to_non_nullable
              as String,
      serifFontName: null == serifFontName
          ? _self.serifFontName
          : serifFontName // ignore: cast_nullable_to_non_nullable
              as String,
      monospaceFontName: null == monospaceFontName
          ? _self.monospaceFontName
          : monospaceFontName // ignore: cast_nullable_to_non_nullable
              as String,
      cursiveFontName: null == cursiveFontName
          ? _self.cursiveFontName
          : cursiveFontName // ignore: cast_nullable_to_non_nullable
              as String,
      fantasyFontName: null == fantasyFontName
          ? _self.fantasyFontName
          : fantasyFontName // ignore: cast_nullable_to_non_nullable
              as String,
      languages: null == languages
          ? _self.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as Languages,
      isDeckMode: null == isDeckMode
          ? _self.isDeckMode
          : isDeckMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
