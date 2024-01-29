import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/extensions/color_extension.dart';
import 'package:miria/extensions/string_extensions.dart';
import 'package:miria/model/misskey_theme.dart';

part 'color_theme.freezed.dart';

@freezed
class ColorTheme with _$ColorTheme {
  const factory ColorTheme({
    required String id,
    required String name,
    required bool isDarkTheme,
    required Color primary,
    required Color primaryDarken,
    required Color primaryLighten,
    required Color accentedBackground,
    required Color background,
    required Color foreground,
    required Color renote,
    required Color mention,
    required Color hashtag,
    required Color link,
    required Color divider,
    required Color buttonBackground,
    required Color buttonGradateA,
    required Color buttonGradateB,
    required Color panel,
    required Color panelBackground,
  }) = _ColorTheme;

  factory ColorTheme.misskey(MisskeyTheme theme) {
    final isDarkTheme = theme.base == "dark";
    final props = {
      ...isDarkTheme ? defaultDarkThemeProps : defaultLightThemeProps
    };
    props.addAll(theme.props);
    props
        .cast<String, String>()
        .removeWhere((key, value) => value.startsWith('"'));

    // https://github.com/misskey-dev/misskey/blob/13.14.1/packages/frontend/src/scripts/theme.ts#L98-L124
    Color getColor(String val) {
      if (val[0] == "@") {
        return getColor(props[val.substring(1)]!);
      } else if (val[0] == r"$") {
        return getColor(props[val]!);
      } else if (val[0] == ":") {
        final parts = val.split("<");
        final func = parts.removeAt(0).substring(1);
        final arg = double.parse(parts.removeAt(0));
        final color = getColor(parts.join("<"));

        return switch (func) {
          "darken" => color.darken(arg / 100),
          "lighten" => color.lighten(arg / 100),
          "alpha" => color.withOpacity(arg),
          "hue" => color.spin(arg),
          "saturate" => color.saturate(arg / 100),
          _ => color,
        };
      }

      final input = val.trim();

      if (input.startsWith("rgb(") && input.endsWith(")")) {
        final rgb = input
            .substring(4, input.length - 1)
            .split(RegExp(r"[, ]+"))
            .map(int.parse)
            .toList();
        return Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
      }

      if (input.startsWith("rgba(") && input.endsWith(")")) {
        final rgbo = input.substring(5, input.length - 1).split(",");
        final rgb = rgbo.sublist(0, 3).map(int.parse).toList();
        final opacity = double.parse(rgbo[3]);
        return Color.fromRGBO(rgb[0], rgb[1], rgb[2], opacity);
      }

      final color = input.toColor();
      if (color != null) {
        return color;
      }

      throw FormatException("invalid color format", val);
    }

    final colors = props.map(
      (key, value) => MapEntry(key, getColor(value)),
    );

    return ColorTheme(
      id: theme.id,
      name: theme.name,
      isDarkTheme: isDarkTheme,
      primary: colors["accent"]!,
      primaryDarken: colors["accentDarken"]!,
      primaryLighten: colors["accentLighten"]!,
      accentedBackground: colors["accentedBg"]!,
      background: colors["bg"]!,
      foreground: colors["fg"]!,
      renote: colors["renote"]!,
      mention: colors["mention"]!,
      hashtag: colors["hashtag"]!,
      link: colors["link"]!,
      divider: colors["divider"]!,
      buttonBackground: colors["buttonBg"]!,
      buttonGradateA: colors["buttonGradateA"]!,
      buttonGradateB: colors["buttonGradateB"]!,
      panel: colors["panel"]!,
      panelBackground: colors["panelHeaderBg"]!,
    );
  }
}

// misskey/packages/frontend/src/themes/_light.json5
const defaultLightThemeProps = {
  "accent": '#86b300',
  "accentDarken": ':darken<10<@accent',
  "accentLighten": ':lighten<10<@accent',
  "accentedBg": ':alpha<0.15<@accent',
  "focus": ':alpha<0.3<@accent',
  "bg": '#fff',
  "acrylicBg": ':alpha<0.5<@bg',
  "fg": '#5f5f5f',
  "fgTransparentWeak": ':alpha<0.75<@fg',
  "fgTransparent": ':alpha<0.5<@fg',
  "fgHighlighted": ':darken<3<@fg',
  "fgOnAccent": '#fff',
  "fgOnWhite": '#333',
  "divider": 'rgba(0, 0, 0, 0.1)',
  "indicator": '@accent',
  "panel": ':lighten<3<@bg',
  "panelHighlight": ':darken<3<@panel',
  "panelHeaderBg": ':lighten<3<@panel',
  "panelHeaderFg": '@fg',
  "panelHeaderDivider": 'rgba(0, 0, 0, 0)',
  "panelBorder": '" solid 1px var(--divider)',
  "acrylicPanel": ':alpha<0.5<@panel',
  "windowHeader": ':alpha<0.85<@panel',
  "popup": ':lighten<3<@panel',
  "shadow": 'rgba(0, 0, 0, 0.1)',
  "header": ':alpha<0.7<@panel',
  "navBg": '@panel',
  "navFg": '@fg',
  "navHoverFg": ':darken<17<@fg',
  "navActive": '@accent',
  "navIndicator": '@indicator',
  "link": '#44a4c1',
  "hashtag": '#ff9156',
  "mention": '@accent',
  "mentionMe": '@mention',
  "renote": '#229e82',
  "modalBg": 'rgba(0, 0, 0, 0.3)',
  "scrollbarHandle": 'rgba(0, 0, 0, 0.2)',
  "scrollbarHandleHover": 'rgba(0, 0, 0, 0.4)',
  "dateLabelFg": '@fg',
  "infoBg": '#e5f5ff',
  "infoFg": '#72818a',
  "infoWarnBg": '#fff0db',
  "infoWarnFg": '#8f6e31',
  "switchBg": 'rgba(0, 0, 0, 0.15)',
  "cwBg": '#b1b9c1',
  "cwFg": '#fff',
  "cwHoverBg": '#bbc4ce',
  "buttonBg": 'rgba(0, 0, 0, 0.05)',
  "buttonHoverBg": 'rgba(0, 0, 0, 0.1)',
  "buttonGradateA": '@accent',
  "buttonGradateB": ':hue<20<@accent',
  "switchOffBg": 'rgba(0, 0, 0, 0.1)',
  "switchOffFg": '@panel',
  "switchOnBg": '@accent',
  "switchOnFg": '@fgOnAccent',
  "inputBorder": 'rgba(0, 0, 0, 0.1)',
  "inputBorderHover": 'rgba(0, 0, 0, 0.2)',
  "listItemHoverBg": 'rgba(0, 0, 0, 0.03)',
  "driveFolderBg": ':alpha<0.3<@accent',
  "wallpaperOverlay": 'rgba(255, 255, 255, 0.5)',
  "badge": '#31b1ce',
  "messageBg": '@bg',
  "success": '#86b300',
  "error": '#ec4137',
  "warn": '#ecb637',
  "codeString": '#b98710',
  "codeNumber": '#0fbbbb',
  "codeBoolean": '#62b70c',
  "deckBg": ':darken<3<@bg',
  "htmlThemeColor": '@bg',
  "X2": ':darken<2<@panel',
  "X3": 'rgba(0, 0, 0, 0.05)',
  "X4": 'rgba(0, 0, 0, 0.1)',
  "X5": 'rgba(0, 0, 0, 0.05)',
  "X6": 'rgba(0, 0, 0, 0.25)',
  "X7": 'rgba(0, 0, 0, 0.05)',
  "X8": ':lighten<5<@accent',
  "X9": ':darken<5<@accent',
  "X10": ':alpha<0.4<@accent',
  "X11": 'rgba(0, 0, 0, 0.1)',
  "X12": 'rgba(0, 0, 0, 0.1)',
  "X13": 'rgba(0, 0, 0, 0.15)',
  "X14": ':alpha<0.5<@navBg',
  "X15": ':alpha<0<@panel',
  "X16": ':alpha<0.7<@panel',
  "X17": ':alpha<0.8<@bg',
};

// misskey/packages/frontend/src/themes/_dark.json5
const defaultDarkThemeProps = {
  "accent": '#86b300',
  "accentDarken": ':darken<10<@accent',
  "accentLighten": ':lighten<10<@accent',
  "accentedBg": ':alpha<0.15<@accent',
  "focus": ':alpha<0.3<@accent',
  "bg": '#000',
  "acrylicBg": ':alpha<0.5<@bg',
  "fg": '#dadada',
  "fgTransparentWeak": ':alpha<0.75<@fg',
  "fgTransparent": ':alpha<0.5<@fg',
  "fgHighlighted": ':lighten<3<@fg',
  "fgOnAccent": '#fff',
  "fgOnWhite": '#333',
  "divider": 'rgba(255, 255, 255, 0.1)',
  "indicator": '@accent',
  "panel": ':lighten<3<@bg',
  "panelHighlight": ':lighten<3<@panel',
  "panelHeaderBg": ':lighten<3<@panel',
  "panelHeaderFg": '@fg',
  "panelHeaderDivider": 'rgba(0, 0, 0, 0)',
  "panelBorder": '" solid 1px var(--divider)',
  "acrylicPanel": ':alpha<0.5<@panel',
  "windowHeader": ':alpha<0.85<@panel',
  "popup": ':lighten<3<@panel',
  "shadow": 'rgba(0, 0, 0, 0.3)',
  "header": ':alpha<0.7<@panel',
  "navBg": '@panel',
  "navFg": '@fg',
  "navHoverFg": ':lighten<17<@fg',
  "navActive": '@accent',
  "navIndicator": '@indicator',
  "link": '#44a4c1',
  "hashtag": '#ff9156',
  "mention": '@accent',
  "mentionMe": '@mention',
  "renote": '#229e82',
  "modalBg": 'rgba(0, 0, 0, 0.5)',
  "scrollbarHandle": 'rgba(255, 255, 255, 0.2)',
  "scrollbarHandleHover": 'rgba(255, 255, 255, 0.4)',
  "dateLabelFg": '@fg',
  "infoBg": '#253142',
  "infoFg": '#fff',
  "infoWarnBg": '#42321c',
  "infoWarnFg": '#ffbd3e',
  "switchBg": 'rgba(255, 255, 255, 0.15)',
  "cwBg": '#687390',
  "cwFg": '#393f4f',
  "cwHoverBg": '#707b97',
  "buttonBg": 'rgba(255, 255, 255, 0.05)',
  "buttonHoverBg": 'rgba(255, 255, 255, 0.1)',
  "buttonGradateA": '@accent',
  "buttonGradateB": ':hue<20<@accent',
  "switchOffBg": 'rgba(255, 255, 255, 0.1)',
  "switchOffFg": ':alpha<0.8<@fg',
  "switchOnBg": '@accentedBg',
  "switchOnFg": '@accent',
  "inputBorder": 'rgba(255, 255, 255, 0.1)',
  "inputBorderHover": 'rgba(255, 255, 255, 0.2)',
  "listItemHoverBg": 'rgba(255, 255, 255, 0.03)',
  "driveFolderBg": ':alpha<0.3<@accent',
  "wallpaperOverlay": 'rgba(0, 0, 0, 0.5)',
  "badge": '#31b1ce',
  "messageBg": '@bg',
  "success": '#86b300',
  "error": '#ec4137',
  "warn": '#ecb637',
  "codeString": '#ffb675',
  "codeNumber": '#cfff9e',
  "codeBoolean": '#c59eff',
  "deckBg": '#000',
  "htmlThemeColor": '@bg',
  "X2": ':darken<2<@panel',
  "X3": 'rgba(255, 255, 255, 0.05)',
  "X4": 'rgba(255, 255, 255, 0.1)',
  "X5": 'rgba(255, 255, 255, 0.05)',
  "X6": 'rgba(255, 255, 255, 0.15)',
  "X7": 'rgba(255, 255, 255, 0.05)',
  "X8": ':lighten<5<@accent',
  "X9": ':darken<5<@accent',
  "X10": ':alpha<0.4<@accent',
  "X11": 'rgba(0, 0, 0, 0.3)',
  "X12": 'rgba(255, 255, 255, 0.1)',
  "X13": 'rgba(255, 255, 255, 0.15)',
  "X14": ':alpha<0.5<@navBg',
  "X15": ':alpha<0<@panel',
  "X16": ':alpha<0.7<@panel',
  "X17": ':alpha<0.8<@bg',
};
