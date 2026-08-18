// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 String get lightColorThemeId; String get darkColorThemeId; ThemeColorSystem get themeColorSystem;/// NSFW設定を継承する
 NSFWInherit get nsfwInherit;/// ノートのカスタム絵文字直接タップでのリアクションを有効にする
 bool get enableDirectReaction;/// TLの自動更新を有効にする
 AutomaticPush get automaticPush;/// 動きのあるMFMを有効にする
 bool get enableAnimatedMFM;/// 長いノートを省略する
 bool get enableLongTextElipsed;/// リアクション済みノートを短くする
 bool get enableFavoritedRenoteElipsed;/// タブの位置
 TabPosition get tabPosition;/// 文字の大きさの倍率
 double get textScaleFactor;/// バブルゲームのBGMの音量
 double get bubbleGameBgmVolume;/// バブルゲームの効果音の音量
 double get bubbleGameSfxVolume;/// 使用するUnicodeの絵文字種別
 EmojiType get emojiType;/// デフォルトのフォント名
 String get defaultFontName;/// `$[font.serif のフォント名
 String get serifFontName;/// `$[font.monospace およびコードブロックのフォント名
 String get monospaceFontName;/// `$[font.cursive のフォント名
 String get cursiveFontName;/// `$[font.fantasy のフォント名
 String get fantasyFontName;/// 言語設定
 Languages get languages;/// デッキモード
 bool get isDeckMode;/// ライトモードでの公開範囲ごとのノート背景色
@ColorConverter() Color? get lightNoteBackgroundPublic;@ColorConverter() Color? get lightNoteBackgroundHome;@ColorConverter() Color? get lightNoteBackgroundFollowers;@ColorConverter() Color? get lightNoteBackgroundDirect;/// ダークモードでの公開範囲ごとのノート背景色
@ColorConverter() Color? get darkNoteBackgroundPublic;@ColorConverter() Color? get darkNoteBackgroundHome;@ColorConverter() Color? get darkNoteBackgroundFollowers;@ColorConverter() Color? get darkNoteBackgroundDirect;
/// Create a copy of GeneralSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneralSettingsCopyWith<GeneralSettings> get copyWith => _$GeneralSettingsCopyWithImpl<GeneralSettings>(this as GeneralSettings, _$identity);

  /// Serializes this GeneralSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneralSettings&&(identical(other.lightColorThemeId, lightColorThemeId) || other.lightColorThemeId == lightColorThemeId)&&(identical(other.darkColorThemeId, darkColorThemeId) || other.darkColorThemeId == darkColorThemeId)&&(identical(other.themeColorSystem, themeColorSystem) || other.themeColorSystem == themeColorSystem)&&(identical(other.nsfwInherit, nsfwInherit) || other.nsfwInherit == nsfwInherit)&&(identical(other.enableDirectReaction, enableDirectReaction) || other.enableDirectReaction == enableDirectReaction)&&(identical(other.automaticPush, automaticPush) || other.automaticPush == automaticPush)&&(identical(other.enableAnimatedMFM, enableAnimatedMFM) || other.enableAnimatedMFM == enableAnimatedMFM)&&(identical(other.enableLongTextElipsed, enableLongTextElipsed) || other.enableLongTextElipsed == enableLongTextElipsed)&&(identical(other.enableFavoritedRenoteElipsed, enableFavoritedRenoteElipsed) || other.enableFavoritedRenoteElipsed == enableFavoritedRenoteElipsed)&&(identical(other.tabPosition, tabPosition) || other.tabPosition == tabPosition)&&(identical(other.textScaleFactor, textScaleFactor) || other.textScaleFactor == textScaleFactor)&&(identical(other.bubbleGameBgmVolume, bubbleGameBgmVolume) || other.bubbleGameBgmVolume == bubbleGameBgmVolume)&&(identical(other.bubbleGameSfxVolume, bubbleGameSfxVolume) || other.bubbleGameSfxVolume == bubbleGameSfxVolume)&&(identical(other.emojiType, emojiType) || other.emojiType == emojiType)&&(identical(other.defaultFontName, defaultFontName) || other.defaultFontName == defaultFontName)&&(identical(other.serifFontName, serifFontName) || other.serifFontName == serifFontName)&&(identical(other.monospaceFontName, monospaceFontName) || other.monospaceFontName == monospaceFontName)&&(identical(other.cursiveFontName, cursiveFontName) || other.cursiveFontName == cursiveFontName)&&(identical(other.fantasyFontName, fantasyFontName) || other.fantasyFontName == fantasyFontName)&&(identical(other.languages, languages) || other.languages == languages)&&(identical(other.isDeckMode, isDeckMode) || other.isDeckMode == isDeckMode)&&(identical(other.lightNoteBackgroundPublic, lightNoteBackgroundPublic) || other.lightNoteBackgroundPublic == lightNoteBackgroundPublic)&&(identical(other.lightNoteBackgroundHome, lightNoteBackgroundHome) || other.lightNoteBackgroundHome == lightNoteBackgroundHome)&&(identical(other.lightNoteBackgroundFollowers, lightNoteBackgroundFollowers) || other.lightNoteBackgroundFollowers == lightNoteBackgroundFollowers)&&(identical(other.lightNoteBackgroundDirect, lightNoteBackgroundDirect) || other.lightNoteBackgroundDirect == lightNoteBackgroundDirect)&&(identical(other.darkNoteBackgroundPublic, darkNoteBackgroundPublic) || other.darkNoteBackgroundPublic == darkNoteBackgroundPublic)&&(identical(other.darkNoteBackgroundHome, darkNoteBackgroundHome) || other.darkNoteBackgroundHome == darkNoteBackgroundHome)&&(identical(other.darkNoteBackgroundFollowers, darkNoteBackgroundFollowers) || other.darkNoteBackgroundFollowers == darkNoteBackgroundFollowers)&&(identical(other.darkNoteBackgroundDirect, darkNoteBackgroundDirect) || other.darkNoteBackgroundDirect == darkNoteBackgroundDirect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,lightColorThemeId,darkColorThemeId,themeColorSystem,nsfwInherit,enableDirectReaction,automaticPush,enableAnimatedMFM,enableLongTextElipsed,enableFavoritedRenoteElipsed,tabPosition,textScaleFactor,bubbleGameBgmVolume,bubbleGameSfxVolume,emojiType,defaultFontName,serifFontName,monospaceFontName,cursiveFontName,fantasyFontName,languages,isDeckMode,lightNoteBackgroundPublic,lightNoteBackgroundHome,lightNoteBackgroundFollowers,lightNoteBackgroundDirect,darkNoteBackgroundPublic,darkNoteBackgroundHome,darkNoteBackgroundFollowers,darkNoteBackgroundDirect]);

@override
String toString() {
  return 'GeneralSettings(lightColorThemeId: $lightColorThemeId, darkColorThemeId: $darkColorThemeId, themeColorSystem: $themeColorSystem, nsfwInherit: $nsfwInherit, enableDirectReaction: $enableDirectReaction, automaticPush: $automaticPush, enableAnimatedMFM: $enableAnimatedMFM, enableLongTextElipsed: $enableLongTextElipsed, enableFavoritedRenoteElipsed: $enableFavoritedRenoteElipsed, tabPosition: $tabPosition, textScaleFactor: $textScaleFactor, bubbleGameBgmVolume: $bubbleGameBgmVolume, bubbleGameSfxVolume: $bubbleGameSfxVolume, emojiType: $emojiType, defaultFontName: $defaultFontName, serifFontName: $serifFontName, monospaceFontName: $monospaceFontName, cursiveFontName: $cursiveFontName, fantasyFontName: $fantasyFontName, languages: $languages, isDeckMode: $isDeckMode, lightNoteBackgroundPublic: $lightNoteBackgroundPublic, lightNoteBackgroundHome: $lightNoteBackgroundHome, lightNoteBackgroundFollowers: $lightNoteBackgroundFollowers, lightNoteBackgroundDirect: $lightNoteBackgroundDirect, darkNoteBackgroundPublic: $darkNoteBackgroundPublic, darkNoteBackgroundHome: $darkNoteBackgroundHome, darkNoteBackgroundFollowers: $darkNoteBackgroundFollowers, darkNoteBackgroundDirect: $darkNoteBackgroundDirect)';
}


}

/// @nodoc
abstract mixin class $GeneralSettingsCopyWith<$Res>  {
  factory $GeneralSettingsCopyWith(GeneralSettings value, $Res Function(GeneralSettings) _then) = _$GeneralSettingsCopyWithImpl;
@useResult
$Res call({
 String lightColorThemeId, String darkColorThemeId, ThemeColorSystem themeColorSystem, NSFWInherit nsfwInherit, bool enableDirectReaction, AutomaticPush automaticPush, bool enableAnimatedMFM, bool enableLongTextElipsed, bool enableFavoritedRenoteElipsed, TabPosition tabPosition, double textScaleFactor, double bubbleGameBgmVolume, double bubbleGameSfxVolume, EmojiType emojiType, String defaultFontName, String serifFontName, String monospaceFontName, String cursiveFontName, String fantasyFontName, Languages languages, bool isDeckMode,@ColorConverter() Color? lightNoteBackgroundPublic,@ColorConverter() Color? lightNoteBackgroundHome,@ColorConverter() Color? lightNoteBackgroundFollowers,@ColorConverter() Color? lightNoteBackgroundDirect,@ColorConverter() Color? darkNoteBackgroundPublic,@ColorConverter() Color? darkNoteBackgroundHome,@ColorConverter() Color? darkNoteBackgroundFollowers,@ColorConverter() Color? darkNoteBackgroundDirect
});




}
/// @nodoc
class _$GeneralSettingsCopyWithImpl<$Res>
    implements $GeneralSettingsCopyWith<$Res> {
  _$GeneralSettingsCopyWithImpl(this._self, this._then);

  final GeneralSettings _self;
  final $Res Function(GeneralSettings) _then;

/// Create a copy of GeneralSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lightColorThemeId = null,Object? darkColorThemeId = null,Object? themeColorSystem = null,Object? nsfwInherit = null,Object? enableDirectReaction = null,Object? automaticPush = null,Object? enableAnimatedMFM = null,Object? enableLongTextElipsed = null,Object? enableFavoritedRenoteElipsed = null,Object? tabPosition = null,Object? textScaleFactor = null,Object? bubbleGameBgmVolume = null,Object? bubbleGameSfxVolume = null,Object? emojiType = null,Object? defaultFontName = null,Object? serifFontName = null,Object? monospaceFontName = null,Object? cursiveFontName = null,Object? fantasyFontName = null,Object? languages = null,Object? isDeckMode = null,Object? lightNoteBackgroundPublic = freezed,Object? lightNoteBackgroundHome = freezed,Object? lightNoteBackgroundFollowers = freezed,Object? lightNoteBackgroundDirect = freezed,Object? darkNoteBackgroundPublic = freezed,Object? darkNoteBackgroundHome = freezed,Object? darkNoteBackgroundFollowers = freezed,Object? darkNoteBackgroundDirect = freezed,}) {
  return _then(_self.copyWith(
lightColorThemeId: null == lightColorThemeId ? _self.lightColorThemeId : lightColorThemeId // ignore: cast_nullable_to_non_nullable
as String,darkColorThemeId: null == darkColorThemeId ? _self.darkColorThemeId : darkColorThemeId // ignore: cast_nullable_to_non_nullable
as String,themeColorSystem: null == themeColorSystem ? _self.themeColorSystem : themeColorSystem // ignore: cast_nullable_to_non_nullable
as ThemeColorSystem,nsfwInherit: null == nsfwInherit ? _self.nsfwInherit : nsfwInherit // ignore: cast_nullable_to_non_nullable
as NSFWInherit,enableDirectReaction: null == enableDirectReaction ? _self.enableDirectReaction : enableDirectReaction // ignore: cast_nullable_to_non_nullable
as bool,automaticPush: null == automaticPush ? _self.automaticPush : automaticPush // ignore: cast_nullable_to_non_nullable
as AutomaticPush,enableAnimatedMFM: null == enableAnimatedMFM ? _self.enableAnimatedMFM : enableAnimatedMFM // ignore: cast_nullable_to_non_nullable
as bool,enableLongTextElipsed: null == enableLongTextElipsed ? _self.enableLongTextElipsed : enableLongTextElipsed // ignore: cast_nullable_to_non_nullable
as bool,enableFavoritedRenoteElipsed: null == enableFavoritedRenoteElipsed ? _self.enableFavoritedRenoteElipsed : enableFavoritedRenoteElipsed // ignore: cast_nullable_to_non_nullable
as bool,tabPosition: null == tabPosition ? _self.tabPosition : tabPosition // ignore: cast_nullable_to_non_nullable
as TabPosition,textScaleFactor: null == textScaleFactor ? _self.textScaleFactor : textScaleFactor // ignore: cast_nullable_to_non_nullable
as double,bubbleGameBgmVolume: null == bubbleGameBgmVolume ? _self.bubbleGameBgmVolume : bubbleGameBgmVolume // ignore: cast_nullable_to_non_nullable
as double,bubbleGameSfxVolume: null == bubbleGameSfxVolume ? _self.bubbleGameSfxVolume : bubbleGameSfxVolume // ignore: cast_nullable_to_non_nullable
as double,emojiType: null == emojiType ? _self.emojiType : emojiType // ignore: cast_nullable_to_non_nullable
as EmojiType,defaultFontName: null == defaultFontName ? _self.defaultFontName : defaultFontName // ignore: cast_nullable_to_non_nullable
as String,serifFontName: null == serifFontName ? _self.serifFontName : serifFontName // ignore: cast_nullable_to_non_nullable
as String,monospaceFontName: null == monospaceFontName ? _self.monospaceFontName : monospaceFontName // ignore: cast_nullable_to_non_nullable
as String,cursiveFontName: null == cursiveFontName ? _self.cursiveFontName : cursiveFontName // ignore: cast_nullable_to_non_nullable
as String,fantasyFontName: null == fantasyFontName ? _self.fantasyFontName : fantasyFontName // ignore: cast_nullable_to_non_nullable
as String,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as Languages,isDeckMode: null == isDeckMode ? _self.isDeckMode : isDeckMode // ignore: cast_nullable_to_non_nullable
as bool,lightNoteBackgroundPublic: freezed == lightNoteBackgroundPublic ? _self.lightNoteBackgroundPublic : lightNoteBackgroundPublic // ignore: cast_nullable_to_non_nullable
as Color?,lightNoteBackgroundHome: freezed == lightNoteBackgroundHome ? _self.lightNoteBackgroundHome : lightNoteBackgroundHome // ignore: cast_nullable_to_non_nullable
as Color?,lightNoteBackgroundFollowers: freezed == lightNoteBackgroundFollowers ? _self.lightNoteBackgroundFollowers : lightNoteBackgroundFollowers // ignore: cast_nullable_to_non_nullable
as Color?,lightNoteBackgroundDirect: freezed == lightNoteBackgroundDirect ? _self.lightNoteBackgroundDirect : lightNoteBackgroundDirect // ignore: cast_nullable_to_non_nullable
as Color?,darkNoteBackgroundPublic: freezed == darkNoteBackgroundPublic ? _self.darkNoteBackgroundPublic : darkNoteBackgroundPublic // ignore: cast_nullable_to_non_nullable
as Color?,darkNoteBackgroundHome: freezed == darkNoteBackgroundHome ? _self.darkNoteBackgroundHome : darkNoteBackgroundHome // ignore: cast_nullable_to_non_nullable
as Color?,darkNoteBackgroundFollowers: freezed == darkNoteBackgroundFollowers ? _self.darkNoteBackgroundFollowers : darkNoteBackgroundFollowers // ignore: cast_nullable_to_non_nullable
as Color?,darkNoteBackgroundDirect: freezed == darkNoteBackgroundDirect ? _self.darkNoteBackgroundDirect : darkNoteBackgroundDirect // ignore: cast_nullable_to_non_nullable
as Color?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneralSettings].
extension GeneralSettingsPatterns on GeneralSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneralSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneralSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneralSettings value)  $default,){
final _that = this;
switch (_that) {
case _GeneralSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneralSettings value)?  $default,){
final _that = this;
switch (_that) {
case _GeneralSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lightColorThemeId,  String darkColorThemeId,  ThemeColorSystem themeColorSystem,  NSFWInherit nsfwInherit,  bool enableDirectReaction,  AutomaticPush automaticPush,  bool enableAnimatedMFM,  bool enableLongTextElipsed,  bool enableFavoritedRenoteElipsed,  TabPosition tabPosition,  double textScaleFactor,  double bubbleGameBgmVolume,  double bubbleGameSfxVolume,  EmojiType emojiType,  String defaultFontName,  String serifFontName,  String monospaceFontName,  String cursiveFontName,  String fantasyFontName,  Languages languages,  bool isDeckMode, @ColorConverter()  Color? lightNoteBackgroundPublic, @ColorConverter()  Color? lightNoteBackgroundHome, @ColorConverter()  Color? lightNoteBackgroundFollowers, @ColorConverter()  Color? lightNoteBackgroundDirect, @ColorConverter()  Color? darkNoteBackgroundPublic, @ColorConverter()  Color? darkNoteBackgroundHome, @ColorConverter()  Color? darkNoteBackgroundFollowers, @ColorConverter()  Color? darkNoteBackgroundDirect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneralSettings() when $default != null:
return $default(_that.lightColorThemeId,_that.darkColorThemeId,_that.themeColorSystem,_that.nsfwInherit,_that.enableDirectReaction,_that.automaticPush,_that.enableAnimatedMFM,_that.enableLongTextElipsed,_that.enableFavoritedRenoteElipsed,_that.tabPosition,_that.textScaleFactor,_that.bubbleGameBgmVolume,_that.bubbleGameSfxVolume,_that.emojiType,_that.defaultFontName,_that.serifFontName,_that.monospaceFontName,_that.cursiveFontName,_that.fantasyFontName,_that.languages,_that.isDeckMode,_that.lightNoteBackgroundPublic,_that.lightNoteBackgroundHome,_that.lightNoteBackgroundFollowers,_that.lightNoteBackgroundDirect,_that.darkNoteBackgroundPublic,_that.darkNoteBackgroundHome,_that.darkNoteBackgroundFollowers,_that.darkNoteBackgroundDirect);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lightColorThemeId,  String darkColorThemeId,  ThemeColorSystem themeColorSystem,  NSFWInherit nsfwInherit,  bool enableDirectReaction,  AutomaticPush automaticPush,  bool enableAnimatedMFM,  bool enableLongTextElipsed,  bool enableFavoritedRenoteElipsed,  TabPosition tabPosition,  double textScaleFactor,  double bubbleGameBgmVolume,  double bubbleGameSfxVolume,  EmojiType emojiType,  String defaultFontName,  String serifFontName,  String monospaceFontName,  String cursiveFontName,  String fantasyFontName,  Languages languages,  bool isDeckMode, @ColorConverter()  Color? lightNoteBackgroundPublic, @ColorConverter()  Color? lightNoteBackgroundHome, @ColorConverter()  Color? lightNoteBackgroundFollowers, @ColorConverter()  Color? lightNoteBackgroundDirect, @ColorConverter()  Color? darkNoteBackgroundPublic, @ColorConverter()  Color? darkNoteBackgroundHome, @ColorConverter()  Color? darkNoteBackgroundFollowers, @ColorConverter()  Color? darkNoteBackgroundDirect)  $default,) {final _that = this;
switch (_that) {
case _GeneralSettings():
return $default(_that.lightColorThemeId,_that.darkColorThemeId,_that.themeColorSystem,_that.nsfwInherit,_that.enableDirectReaction,_that.automaticPush,_that.enableAnimatedMFM,_that.enableLongTextElipsed,_that.enableFavoritedRenoteElipsed,_that.tabPosition,_that.textScaleFactor,_that.bubbleGameBgmVolume,_that.bubbleGameSfxVolume,_that.emojiType,_that.defaultFontName,_that.serifFontName,_that.monospaceFontName,_that.cursiveFontName,_that.fantasyFontName,_that.languages,_that.isDeckMode,_that.lightNoteBackgroundPublic,_that.lightNoteBackgroundHome,_that.lightNoteBackgroundFollowers,_that.lightNoteBackgroundDirect,_that.darkNoteBackgroundPublic,_that.darkNoteBackgroundHome,_that.darkNoteBackgroundFollowers,_that.darkNoteBackgroundDirect);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lightColorThemeId,  String darkColorThemeId,  ThemeColorSystem themeColorSystem,  NSFWInherit nsfwInherit,  bool enableDirectReaction,  AutomaticPush automaticPush,  bool enableAnimatedMFM,  bool enableLongTextElipsed,  bool enableFavoritedRenoteElipsed,  TabPosition tabPosition,  double textScaleFactor,  double bubbleGameBgmVolume,  double bubbleGameSfxVolume,  EmojiType emojiType,  String defaultFontName,  String serifFontName,  String monospaceFontName,  String cursiveFontName,  String fantasyFontName,  Languages languages,  bool isDeckMode, @ColorConverter()  Color? lightNoteBackgroundPublic, @ColorConverter()  Color? lightNoteBackgroundHome, @ColorConverter()  Color? lightNoteBackgroundFollowers, @ColorConverter()  Color? lightNoteBackgroundDirect, @ColorConverter()  Color? darkNoteBackgroundPublic, @ColorConverter()  Color? darkNoteBackgroundHome, @ColorConverter()  Color? darkNoteBackgroundFollowers, @ColorConverter()  Color? darkNoteBackgroundDirect)?  $default,) {final _that = this;
switch (_that) {
case _GeneralSettings() when $default != null:
return $default(_that.lightColorThemeId,_that.darkColorThemeId,_that.themeColorSystem,_that.nsfwInherit,_that.enableDirectReaction,_that.automaticPush,_that.enableAnimatedMFM,_that.enableLongTextElipsed,_that.enableFavoritedRenoteElipsed,_that.tabPosition,_that.textScaleFactor,_that.bubbleGameBgmVolume,_that.bubbleGameSfxVolume,_that.emojiType,_that.defaultFontName,_that.serifFontName,_that.monospaceFontName,_that.cursiveFontName,_that.fantasyFontName,_that.languages,_that.isDeckMode,_that.lightNoteBackgroundPublic,_that.lightNoteBackgroundHome,_that.lightNoteBackgroundFollowers,_that.lightNoteBackgroundDirect,_that.darkNoteBackgroundPublic,_that.darkNoteBackgroundHome,_that.darkNoteBackgroundFollowers,_that.darkNoteBackgroundDirect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneralSettings implements GeneralSettings {
  const _GeneralSettings({this.lightColorThemeId = "", this.darkColorThemeId = "", this.themeColorSystem = ThemeColorSystem.system, this.nsfwInherit = NSFWInherit.inherit, this.enableDirectReaction = false, this.automaticPush = AutomaticPush.none, this.enableAnimatedMFM = true, this.enableLongTextElipsed = false, this.enableFavoritedRenoteElipsed = true, this.tabPosition = TabPosition.top, this.textScaleFactor = 1.0, this.bubbleGameBgmVolume = 0.25, this.bubbleGameSfxVolume = 1.0, this.emojiType = EmojiType.twemoji, this.defaultFontName = "", this.serifFontName = "", this.monospaceFontName = "", this.cursiveFontName = "", this.fantasyFontName = "", this.languages = Languages.jaJP, this.isDeckMode = false, @ColorConverter() this.lightNoteBackgroundPublic = null, @ColorConverter() this.lightNoteBackgroundHome = null, @ColorConverter() this.lightNoteBackgroundFollowers = null, @ColorConverter() this.lightNoteBackgroundDirect = null, @ColorConverter() this.darkNoteBackgroundPublic = null, @ColorConverter() this.darkNoteBackgroundHome = null, @ColorConverter() this.darkNoteBackgroundFollowers = null, @ColorConverter() this.darkNoteBackgroundDirect = null});
  factory _GeneralSettings.fromJson(Map<String, dynamic> json) => _$GeneralSettingsFromJson(json);

@override@JsonKey() final  String lightColorThemeId;
@override@JsonKey() final  String darkColorThemeId;
@override@JsonKey() final  ThemeColorSystem themeColorSystem;
/// NSFW設定を継承する
@override@JsonKey() final  NSFWInherit nsfwInherit;
/// ノートのカスタム絵文字直接タップでのリアクションを有効にする
@override@JsonKey() final  bool enableDirectReaction;
/// TLの自動更新を有効にする
@override@JsonKey() final  AutomaticPush automaticPush;
/// 動きのあるMFMを有効にする
@override@JsonKey() final  bool enableAnimatedMFM;
/// 長いノートを省略する
@override@JsonKey() final  bool enableLongTextElipsed;
/// リアクション済みノートを短くする
@override@JsonKey() final  bool enableFavoritedRenoteElipsed;
/// タブの位置
@override@JsonKey() final  TabPosition tabPosition;
/// 文字の大きさの倍率
@override@JsonKey() final  double textScaleFactor;
/// バブルゲームのBGMの音量
@override@JsonKey() final  double bubbleGameBgmVolume;
/// バブルゲームの効果音の音量
@override@JsonKey() final  double bubbleGameSfxVolume;
/// 使用するUnicodeの絵文字種別
@override@JsonKey() final  EmojiType emojiType;
/// デフォルトのフォント名
@override@JsonKey() final  String defaultFontName;
/// `$[font.serif のフォント名
@override@JsonKey() final  String serifFontName;
/// `$[font.monospace およびコードブロックのフォント名
@override@JsonKey() final  String monospaceFontName;
/// `$[font.cursive のフォント名
@override@JsonKey() final  String cursiveFontName;
/// `$[font.fantasy のフォント名
@override@JsonKey() final  String fantasyFontName;
/// 言語設定
@override@JsonKey() final  Languages languages;
/// デッキモード
@override@JsonKey() final  bool isDeckMode;
/// ライトモードでの公開範囲ごとのノート背景色
@override@JsonKey()@ColorConverter() final  Color? lightNoteBackgroundPublic;
@override@JsonKey()@ColorConverter() final  Color? lightNoteBackgroundHome;
@override@JsonKey()@ColorConverter() final  Color? lightNoteBackgroundFollowers;
@override@JsonKey()@ColorConverter() final  Color? lightNoteBackgroundDirect;
/// ダークモードでの公開範囲ごとのノート背景色
@override@JsonKey()@ColorConverter() final  Color? darkNoteBackgroundPublic;
@override@JsonKey()@ColorConverter() final  Color? darkNoteBackgroundHome;
@override@JsonKey()@ColorConverter() final  Color? darkNoteBackgroundFollowers;
@override@JsonKey()@ColorConverter() final  Color? darkNoteBackgroundDirect;

/// Create a copy of GeneralSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneralSettingsCopyWith<_GeneralSettings> get copyWith => __$GeneralSettingsCopyWithImpl<_GeneralSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneralSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneralSettings&&(identical(other.lightColorThemeId, lightColorThemeId) || other.lightColorThemeId == lightColorThemeId)&&(identical(other.darkColorThemeId, darkColorThemeId) || other.darkColorThemeId == darkColorThemeId)&&(identical(other.themeColorSystem, themeColorSystem) || other.themeColorSystem == themeColorSystem)&&(identical(other.nsfwInherit, nsfwInherit) || other.nsfwInherit == nsfwInherit)&&(identical(other.enableDirectReaction, enableDirectReaction) || other.enableDirectReaction == enableDirectReaction)&&(identical(other.automaticPush, automaticPush) || other.automaticPush == automaticPush)&&(identical(other.enableAnimatedMFM, enableAnimatedMFM) || other.enableAnimatedMFM == enableAnimatedMFM)&&(identical(other.enableLongTextElipsed, enableLongTextElipsed) || other.enableLongTextElipsed == enableLongTextElipsed)&&(identical(other.enableFavoritedRenoteElipsed, enableFavoritedRenoteElipsed) || other.enableFavoritedRenoteElipsed == enableFavoritedRenoteElipsed)&&(identical(other.tabPosition, tabPosition) || other.tabPosition == tabPosition)&&(identical(other.textScaleFactor, textScaleFactor) || other.textScaleFactor == textScaleFactor)&&(identical(other.bubbleGameBgmVolume, bubbleGameBgmVolume) || other.bubbleGameBgmVolume == bubbleGameBgmVolume)&&(identical(other.bubbleGameSfxVolume, bubbleGameSfxVolume) || other.bubbleGameSfxVolume == bubbleGameSfxVolume)&&(identical(other.emojiType, emojiType) || other.emojiType == emojiType)&&(identical(other.defaultFontName, defaultFontName) || other.defaultFontName == defaultFontName)&&(identical(other.serifFontName, serifFontName) || other.serifFontName == serifFontName)&&(identical(other.monospaceFontName, monospaceFontName) || other.monospaceFontName == monospaceFontName)&&(identical(other.cursiveFontName, cursiveFontName) || other.cursiveFontName == cursiveFontName)&&(identical(other.fantasyFontName, fantasyFontName) || other.fantasyFontName == fantasyFontName)&&(identical(other.languages, languages) || other.languages == languages)&&(identical(other.isDeckMode, isDeckMode) || other.isDeckMode == isDeckMode)&&(identical(other.lightNoteBackgroundPublic, lightNoteBackgroundPublic) || other.lightNoteBackgroundPublic == lightNoteBackgroundPublic)&&(identical(other.lightNoteBackgroundHome, lightNoteBackgroundHome) || other.lightNoteBackgroundHome == lightNoteBackgroundHome)&&(identical(other.lightNoteBackgroundFollowers, lightNoteBackgroundFollowers) || other.lightNoteBackgroundFollowers == lightNoteBackgroundFollowers)&&(identical(other.lightNoteBackgroundDirect, lightNoteBackgroundDirect) || other.lightNoteBackgroundDirect == lightNoteBackgroundDirect)&&(identical(other.darkNoteBackgroundPublic, darkNoteBackgroundPublic) || other.darkNoteBackgroundPublic == darkNoteBackgroundPublic)&&(identical(other.darkNoteBackgroundHome, darkNoteBackgroundHome) || other.darkNoteBackgroundHome == darkNoteBackgroundHome)&&(identical(other.darkNoteBackgroundFollowers, darkNoteBackgroundFollowers) || other.darkNoteBackgroundFollowers == darkNoteBackgroundFollowers)&&(identical(other.darkNoteBackgroundDirect, darkNoteBackgroundDirect) || other.darkNoteBackgroundDirect == darkNoteBackgroundDirect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,lightColorThemeId,darkColorThemeId,themeColorSystem,nsfwInherit,enableDirectReaction,automaticPush,enableAnimatedMFM,enableLongTextElipsed,enableFavoritedRenoteElipsed,tabPosition,textScaleFactor,bubbleGameBgmVolume,bubbleGameSfxVolume,emojiType,defaultFontName,serifFontName,monospaceFontName,cursiveFontName,fantasyFontName,languages,isDeckMode,lightNoteBackgroundPublic,lightNoteBackgroundHome,lightNoteBackgroundFollowers,lightNoteBackgroundDirect,darkNoteBackgroundPublic,darkNoteBackgroundHome,darkNoteBackgroundFollowers,darkNoteBackgroundDirect]);

@override
String toString() {
  return 'GeneralSettings(lightColorThemeId: $lightColorThemeId, darkColorThemeId: $darkColorThemeId, themeColorSystem: $themeColorSystem, nsfwInherit: $nsfwInherit, enableDirectReaction: $enableDirectReaction, automaticPush: $automaticPush, enableAnimatedMFM: $enableAnimatedMFM, enableLongTextElipsed: $enableLongTextElipsed, enableFavoritedRenoteElipsed: $enableFavoritedRenoteElipsed, tabPosition: $tabPosition, textScaleFactor: $textScaleFactor, bubbleGameBgmVolume: $bubbleGameBgmVolume, bubbleGameSfxVolume: $bubbleGameSfxVolume, emojiType: $emojiType, defaultFontName: $defaultFontName, serifFontName: $serifFontName, monospaceFontName: $monospaceFontName, cursiveFontName: $cursiveFontName, fantasyFontName: $fantasyFontName, languages: $languages, isDeckMode: $isDeckMode, lightNoteBackgroundPublic: $lightNoteBackgroundPublic, lightNoteBackgroundHome: $lightNoteBackgroundHome, lightNoteBackgroundFollowers: $lightNoteBackgroundFollowers, lightNoteBackgroundDirect: $lightNoteBackgroundDirect, darkNoteBackgroundPublic: $darkNoteBackgroundPublic, darkNoteBackgroundHome: $darkNoteBackgroundHome, darkNoteBackgroundFollowers: $darkNoteBackgroundFollowers, darkNoteBackgroundDirect: $darkNoteBackgroundDirect)';
}


}

/// @nodoc
abstract mixin class _$GeneralSettingsCopyWith<$Res> implements $GeneralSettingsCopyWith<$Res> {
  factory _$GeneralSettingsCopyWith(_GeneralSettings value, $Res Function(_GeneralSettings) _then) = __$GeneralSettingsCopyWithImpl;
@override @useResult
$Res call({
 String lightColorThemeId, String darkColorThemeId, ThemeColorSystem themeColorSystem, NSFWInherit nsfwInherit, bool enableDirectReaction, AutomaticPush automaticPush, bool enableAnimatedMFM, bool enableLongTextElipsed, bool enableFavoritedRenoteElipsed, TabPosition tabPosition, double textScaleFactor, double bubbleGameBgmVolume, double bubbleGameSfxVolume, EmojiType emojiType, String defaultFontName, String serifFontName, String monospaceFontName, String cursiveFontName, String fantasyFontName, Languages languages, bool isDeckMode,@ColorConverter() Color? lightNoteBackgroundPublic,@ColorConverter() Color? lightNoteBackgroundHome,@ColorConverter() Color? lightNoteBackgroundFollowers,@ColorConverter() Color? lightNoteBackgroundDirect,@ColorConverter() Color? darkNoteBackgroundPublic,@ColorConverter() Color? darkNoteBackgroundHome,@ColorConverter() Color? darkNoteBackgroundFollowers,@ColorConverter() Color? darkNoteBackgroundDirect
});




}
/// @nodoc
class __$GeneralSettingsCopyWithImpl<$Res>
    implements _$GeneralSettingsCopyWith<$Res> {
  __$GeneralSettingsCopyWithImpl(this._self, this._then);

  final _GeneralSettings _self;
  final $Res Function(_GeneralSettings) _then;

/// Create a copy of GeneralSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lightColorThemeId = null,Object? darkColorThemeId = null,Object? themeColorSystem = null,Object? nsfwInherit = null,Object? enableDirectReaction = null,Object? automaticPush = null,Object? enableAnimatedMFM = null,Object? enableLongTextElipsed = null,Object? enableFavoritedRenoteElipsed = null,Object? tabPosition = null,Object? textScaleFactor = null,Object? bubbleGameBgmVolume = null,Object? bubbleGameSfxVolume = null,Object? emojiType = null,Object? defaultFontName = null,Object? serifFontName = null,Object? monospaceFontName = null,Object? cursiveFontName = null,Object? fantasyFontName = null,Object? languages = null,Object? isDeckMode = null,Object? lightNoteBackgroundPublic = freezed,Object? lightNoteBackgroundHome = freezed,Object? lightNoteBackgroundFollowers = freezed,Object? lightNoteBackgroundDirect = freezed,Object? darkNoteBackgroundPublic = freezed,Object? darkNoteBackgroundHome = freezed,Object? darkNoteBackgroundFollowers = freezed,Object? darkNoteBackgroundDirect = freezed,}) {
  return _then(_GeneralSettings(
lightColorThemeId: null == lightColorThemeId ? _self.lightColorThemeId : lightColorThemeId // ignore: cast_nullable_to_non_nullable
as String,darkColorThemeId: null == darkColorThemeId ? _self.darkColorThemeId : darkColorThemeId // ignore: cast_nullable_to_non_nullable
as String,themeColorSystem: null == themeColorSystem ? _self.themeColorSystem : themeColorSystem // ignore: cast_nullable_to_non_nullable
as ThemeColorSystem,nsfwInherit: null == nsfwInherit ? _self.nsfwInherit : nsfwInherit // ignore: cast_nullable_to_non_nullable
as NSFWInherit,enableDirectReaction: null == enableDirectReaction ? _self.enableDirectReaction : enableDirectReaction // ignore: cast_nullable_to_non_nullable
as bool,automaticPush: null == automaticPush ? _self.automaticPush : automaticPush // ignore: cast_nullable_to_non_nullable
as AutomaticPush,enableAnimatedMFM: null == enableAnimatedMFM ? _self.enableAnimatedMFM : enableAnimatedMFM // ignore: cast_nullable_to_non_nullable
as bool,enableLongTextElipsed: null == enableLongTextElipsed ? _self.enableLongTextElipsed : enableLongTextElipsed // ignore: cast_nullable_to_non_nullable
as bool,enableFavoritedRenoteElipsed: null == enableFavoritedRenoteElipsed ? _self.enableFavoritedRenoteElipsed : enableFavoritedRenoteElipsed // ignore: cast_nullable_to_non_nullable
as bool,tabPosition: null == tabPosition ? _self.tabPosition : tabPosition // ignore: cast_nullable_to_non_nullable
as TabPosition,textScaleFactor: null == textScaleFactor ? _self.textScaleFactor : textScaleFactor // ignore: cast_nullable_to_non_nullable
as double,bubbleGameBgmVolume: null == bubbleGameBgmVolume ? _self.bubbleGameBgmVolume : bubbleGameBgmVolume // ignore: cast_nullable_to_non_nullable
as double,bubbleGameSfxVolume: null == bubbleGameSfxVolume ? _self.bubbleGameSfxVolume : bubbleGameSfxVolume // ignore: cast_nullable_to_non_nullable
as double,emojiType: null == emojiType ? _self.emojiType : emojiType // ignore: cast_nullable_to_non_nullable
as EmojiType,defaultFontName: null == defaultFontName ? _self.defaultFontName : defaultFontName // ignore: cast_nullable_to_non_nullable
as String,serifFontName: null == serifFontName ? _self.serifFontName : serifFontName // ignore: cast_nullable_to_non_nullable
as String,monospaceFontName: null == monospaceFontName ? _self.monospaceFontName : monospaceFontName // ignore: cast_nullable_to_non_nullable
as String,cursiveFontName: null == cursiveFontName ? _self.cursiveFontName : cursiveFontName // ignore: cast_nullable_to_non_nullable
as String,fantasyFontName: null == fantasyFontName ? _self.fantasyFontName : fantasyFontName // ignore: cast_nullable_to_non_nullable
as String,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as Languages,isDeckMode: null == isDeckMode ? _self.isDeckMode : isDeckMode // ignore: cast_nullable_to_non_nullable
as bool,lightNoteBackgroundPublic: freezed == lightNoteBackgroundPublic ? _self.lightNoteBackgroundPublic : lightNoteBackgroundPublic // ignore: cast_nullable_to_non_nullable
as Color?,lightNoteBackgroundHome: freezed == lightNoteBackgroundHome ? _self.lightNoteBackgroundHome : lightNoteBackgroundHome // ignore: cast_nullable_to_non_nullable
as Color?,lightNoteBackgroundFollowers: freezed == lightNoteBackgroundFollowers ? _self.lightNoteBackgroundFollowers : lightNoteBackgroundFollowers // ignore: cast_nullable_to_non_nullable
as Color?,lightNoteBackgroundDirect: freezed == lightNoteBackgroundDirect ? _self.lightNoteBackgroundDirect : lightNoteBackgroundDirect // ignore: cast_nullable_to_non_nullable
as Color?,darkNoteBackgroundPublic: freezed == darkNoteBackgroundPublic ? _self.darkNoteBackgroundPublic : darkNoteBackgroundPublic // ignore: cast_nullable_to_non_nullable
as Color?,darkNoteBackgroundHome: freezed == darkNoteBackgroundHome ? _self.darkNoteBackgroundHome : darkNoteBackgroundHome // ignore: cast_nullable_to_non_nullable
as Color?,darkNoteBackgroundFollowers: freezed == darkNoteBackgroundFollowers ? _self.darkNoteBackgroundFollowers : darkNoteBackgroundFollowers // ignore: cast_nullable_to_non_nullable
as Color?,darkNoteBackgroundDirect: freezed == darkNoteBackgroundDirect ? _self.darkNoteBackgroundDirect : darkNoteBackgroundDirect // ignore: cast_nullable_to_non_nullable
as Color?,
  ));
}


}

// dart format on
