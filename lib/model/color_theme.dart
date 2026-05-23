import "dart:ui";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/extensions/color_extension.dart";
import "package:miria/extensions/string_extensions.dart";
import "package:miria/model/misskey_theme.dart";

part "color_theme.freezed.dart";

@freezed
abstract class ColorTheme with _$ColorTheme {
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
    final props =
        {...isDarkTheme ? defaultDarkThemeProps : defaultLightThemeProps}
          ..addAll(theme.props)
          ..cast<String, String>().removeWhere(
            (key, value) => value.startsWith('"'),
          );

    return ColorTheme(
      id: theme.id,
      name: theme.name,
      isDarkTheme: isDarkTheme,
      primary: _getThemeReferenceColor(props, "accent", [], 0),
      primaryDarken: _getThemeReferenceColor(props, "accentDarken", [], 0),
      primaryLighten: _getThemeReferenceColor(props, "accentLighten", [], 0),
      accentedBackground: _getThemeReferenceColor(props, "accentedBg", [], 0),
      background: _getThemeReferenceColor(props, "bg", [], 0),
      foreground: _getThemeReferenceColor(props, "fg", [], 0),
      renote: _getThemeReferenceColor(props, "renote", [], 0),
      mention: _getThemeReferenceColor(props, "mention", [], 0),
      hashtag: _getThemeReferenceColor(props, "hashtag", [], 0),
      link: _getThemeReferenceColor(props, "link", [], 0),
      divider: _getThemeReferenceColor(props, "divider", [], 0),
      buttonBackground: _getThemeReferenceColor(props, "buttonBg", [], 0),
      buttonGradateA: _getThemeReferenceColor(props, "buttonGradateA", [], 0),
      buttonGradateB: _getThemeReferenceColor(props, "buttonGradateB", [], 0),
      panel: _getThemeReferenceColor(props, "panel", [], 0),
      panelBackground: _getThemeReferenceColor(props, "panelHeaderBg", [], 0),
    );
  }
}

// misskey/packages/frontend/src/themes/_light.json5
const defaultLightThemeProps = {
  "accent": "#86b300",
  "accentDarken": ":darken<10<@accent",
  "accentLighten": ":lighten<10<@accent",
  "accentedBg": ":alpha<0.15<@accent",
  "focus": ":alpha<0.3<@accent",
  "bg": "#fff",
  "acrylicBg": ":alpha<0.5<@bg",
  "fg": "#5f5f5f",
  "fgTransparentWeak": ":alpha<0.75<@fg",
  "fgTransparent": ":alpha<0.5<@fg",
  "fgHighlighted": ":darken<3<@fg",
  "fgOnAccent": "#fff",
  "fgOnWhite": "#333",
  "divider": "rgba(0, 0, 0, 0.1)",
  "indicator": "@accent",
  "panel": ":lighten<3<@bg",
  "panelHighlight": ":darken<3<@panel",
  "panelHeaderBg": ":lighten<3<@panel",
  "panelHeaderFg": "@fg",
  "panelHeaderDivider": "rgba(0, 0, 0, 0)",
  "panelBorder": '" solid 1px var(--divider)',
  "acrylicPanel": ":alpha<0.5<@panel",
  "windowHeader": ":alpha<0.85<@panel",
  "popup": ":lighten<3<@panel",
  "shadow": "rgba(0, 0, 0, 0.1)",
  "header": ":alpha<0.7<@panel",
  "navBg": "@panel",
  "navFg": "@fg",
  "navHoverFg": ":darken<17<@fg",
  "navActive": "@accent",
  "navIndicator": "@indicator",
  "link": "#44a4c1",
  "hashtag": "#ff9156",
  "mention": "@accent",
  "mentionMe": "@mention",
  "renote": "#229e82",
  "modalBg": "rgba(0, 0, 0, 0.3)",
  "scrollbarHandle": "rgba(0, 0, 0, 0.2)",
  "scrollbarHandleHover": "rgba(0, 0, 0, 0.4)",
  "dateLabelFg": "@fg",
  "infoBg": "#e5f5ff",
  "infoFg": "#72818a",
  "infoWarnBg": "#fff0db",
  "infoWarnFg": "#8f6e31",
  "switchBg": "rgba(0, 0, 0, 0.15)",
  "cwBg": "#b1b9c1",
  "cwFg": "#fff",
  "cwHoverBg": "#bbc4ce",
  "buttonBg": "rgba(0, 0, 0, 0.05)",
  "buttonHoverBg": "rgba(0, 0, 0, 0.1)",
  "buttonGradateA": "@accent",
  "buttonGradateB": ":hue<20<@accent",
  "switchOffBg": "rgba(0, 0, 0, 0.1)",
  "switchOffFg": "@panel",
  "switchOnBg": "@accent",
  "switchOnFg": "@fgOnAccent",
  "inputBorder": "rgba(0, 0, 0, 0.1)",
  "inputBorderHover": "rgba(0, 0, 0, 0.2)",
  "listItemHoverBg": "rgba(0, 0, 0, 0.03)",
  "driveFolderBg": ":alpha<0.3<@accent",
  "wallpaperOverlay": "rgba(255, 255, 255, 0.5)",
  "badge": "#31b1ce",
  "messageBg": "@bg",
  "success": "#86b300",
  "error": "#ec4137",
  "warn": "#ecb637",
  "codeString": "#b98710",
  "codeNumber": "#0fbbbb",
  "codeBoolean": "#62b70c",
  "deckBg": ":darken<3<@bg",
  "htmlThemeColor": "@bg",
  "X2": ":darken<2<@panel",
  "X3": "rgba(0, 0, 0, 0.05)",
  "X4": "rgba(0, 0, 0, 0.1)",
  "X5": "rgba(0, 0, 0, 0.05)",
  "X6": "rgba(0, 0, 0, 0.25)",
  "X7": "rgba(0, 0, 0, 0.05)",
  "X8": ":lighten<5<@accent",
  "X9": ":darken<5<@accent",
  "X10": ":alpha<0.4<@accent",
  "X11": "rgba(0, 0, 0, 0.1)",
  "X12": "rgba(0, 0, 0, 0.1)",
  "X13": "rgba(0, 0, 0, 0.15)",
  "X14": ":alpha<0.5<@navBg",
  "X15": ":alpha<0<@panel",
  "X16": ":alpha<0.7<@panel",
  "X17": ":alpha<0.8<@bg",
};

// misskey/packages/frontend/src/themes/_dark.json5
const defaultDarkThemeProps = {
  "accent": "#86b300",
  "accentDarken": ":darken<10<@accent",
  "accentLighten": ":lighten<10<@accent",
  "accentedBg": ":alpha<0.15<@accent",
  "focus": ":alpha<0.3<@accent",
  "bg": "#000",
  "acrylicBg": ":alpha<0.5<@bg",
  "fg": "#dadada",
  "fgTransparentWeak": ":alpha<0.75<@fg",
  "fgTransparent": ":alpha<0.5<@fg",
  "fgHighlighted": ":lighten<3<@fg",
  "fgOnAccent": "#fff",
  "fgOnWhite": "#333",
  "divider": "rgba(255, 255, 255, 0.1)",
  "indicator": "@accent",
  "panel": ":lighten<3<@bg",
  "panelHighlight": ":lighten<3<@panel",
  "panelHeaderBg": ":lighten<3<@panel",
  "panelHeaderFg": "@fg",
  "panelHeaderDivider": "rgba(0, 0, 0, 0)",
  "panelBorder": '" solid 1px var(--divider)',
  "acrylicPanel": ":alpha<0.5<@panel",
  "windowHeader": ":alpha<0.85<@panel",
  "popup": ":lighten<3<@panel",
  "shadow": "rgba(0, 0, 0, 0.3)",
  "header": ":alpha<0.7<@panel",
  "navBg": "@panel",
  "navFg": "@fg",
  "navHoverFg": ":lighten<17<@fg",
  "navActive": "@accent",
  "navIndicator": "@indicator",
  "link": "#44a4c1",
  "hashtag": "#ff9156",
  "mention": "@accent",
  "mentionMe": "@mention",
  "renote": "#229e82",
  "modalBg": "rgba(0, 0, 0, 0.5)",
  "scrollbarHandle": "rgba(255, 255, 255, 0.2)",
  "scrollbarHandleHover": "rgba(255, 255, 255, 0.4)",
  "dateLabelFg": "@fg",
  "infoBg": "#253142",
  "infoFg": "#fff",
  "infoWarnBg": "#42321c",
  "infoWarnFg": "#ffbd3e",
  "switchBg": "rgba(255, 255, 255, 0.15)",
  "cwBg": "#687390",
  "cwFg": "#393f4f",
  "cwHoverBg": "#707b97",
  "buttonBg": "rgba(255, 255, 255, 0.05)",
  "buttonHoverBg": "rgba(255, 255, 255, 0.1)",
  "buttonGradateA": "@accent",
  "buttonGradateB": ":hue<20<@accent",
  "switchOffBg": "rgba(255, 255, 255, 0.1)",
  "switchOffFg": ":alpha<0.8<@fg",
  "switchOnBg": "@accentedBg",
  "switchOnFg": "@accent",
  "inputBorder": "rgba(255, 255, 255, 0.1)",
  "inputBorderHover": "rgba(255, 255, 255, 0.2)",
  "listItemHoverBg": "rgba(255, 255, 255, 0.03)",
  "driveFolderBg": ":alpha<0.3<@accent",
  "wallpaperOverlay": "rgba(0, 0, 0, 0.5)",
  "badge": "#31b1ce",
  "messageBg": "@bg",
  "success": "#86b300",
  "error": "#ec4137",
  "warn": "#ecb637",
  "codeString": "#ffb675",
  "codeNumber": "#cfff9e",
  "codeBoolean": "#c59eff",
  "deckBg": "#000",
  "htmlThemeColor": "@bg",
  "X2": ":darken<2<@panel",
  "X3": "rgba(255, 255, 255, 0.05)",
  "X4": "rgba(255, 255, 255, 0.1)",
  "X5": "rgba(255, 255, 255, 0.05)",
  "X6": "rgba(255, 255, 255, 0.15)",
  "X7": "rgba(255, 255, 255, 0.05)",
  "X8": ":lighten<5<@accent",
  "X9": ":darken<5<@accent",
  "X10": ":alpha<0.4<@accent",
  "X11": "rgba(0, 0, 0, 0.3)",
  "X12": "rgba(255, 255, 255, 0.1)",
  "X13": "rgba(255, 255, 255, 0.15)",
  "X14": ":alpha<0.5<@navBg",
  "X15": ":alpha<0<@panel",
  "X16": ":alpha<0.7<@panel",
  "X17": ":alpha<0.8<@bg",
};

const _maxThemeReferenceDepth = 8;

Color _getThemeReferenceColor(
  Map<String, String> props,
  String key,
  List<String> stack,
  int depth,
) {
  if (depth >= _maxThemeReferenceDepth) {
    throw FormatException("Theme reference limit exceeded");
  }

  if (stack.contains(key)) {
    throw FormatException("Theme contains circular references");
  }

  final nextValue = props[key];
  if (nextValue == null) {
    throw FormatException("Theme references missing property", key);
  }

  return _getColor(props, nextValue, [...stack, key], depth + 1);
}

Color _getColor(
  Map<String, String> props,
  String val,
  List<String> stack,
  int depth,
) {
  if (val[0] == "@") {
    return _getThemeReferenceColor(props, val.substring(1), stack, depth);
  } else if (val[0] == r"$") {
    return _getThemeReferenceColor(props, val, stack, depth);
  } else if (val[0] == ":") {
    if (depth >= _maxThemeReferenceDepth) {
      throw FormatException("Theme reference limit exceeded");
    }
    final parts = val.split("<");
    final func = parts.removeAt(0).substring(1);
    final arg = double.parse(parts.removeAt(0));
    final color = _getColor(props, parts.join("<"), stack, depth + 1);

    switch (func) {
      case "darken":
        return color.darken(arg / 100);
      case "lighten":
        return color.lighten(arg / 100);
      case "alpha":
        return color.withValues(alpha: arg);
      case "hue":
        return color.spin(arg);
      case "saturate":
        return color.saturate(arg / 100);
    }
  }

  final input = val.trim();

  if (input.startsWith("rgb(") && input.endsWith(")")) {
    final rgb = input
        .substring(4, input.length - 1)
        .split(RegExp("[, ]+"))
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
