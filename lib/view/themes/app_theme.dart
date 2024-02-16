import 'package:flutter/material.dart';
import 'package:miria/model/color_theme.dart';
import 'package:miria/model/general_settings.dart';

class AppTheme extends InheritedWidget {
  final AppThemeData themeData;

  const AppTheme({
    super.key,
    required super.child,
    required this.themeData,
  });

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return oldWidget.themeData != themeData;
  }

  static AppThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    if (theme == null) {
      throw Exception("has not ancestor");
    }
    return theme.themeData;
  }
}

class AppThemeData {
  final ColorTheme colorTheme;
  final bool isDarkMode;
  final InputDecoration noteTextStyle;
  final ButtonStyle reactionButtonStyle;
  final TextStyle linkStyle;
  final TextStyle mentionStyle;
  final TextStyle hashtagStyle;
  final TextStyle unicodeEmojiStyle;
  final TextStyle serifStyle;
  final TextStyle monospaceStyle;
  final TextStyle cursiveStyle;
  final TextStyle fantasyStyle;
  final Color reactionButtonMeReactedColor;
  final Color reactionButtonBackgroundColor;
  final Color renoteBorderColor;
  final double renoteStrokeWidth;
  final double renoteStrokePadding;
  final Radius renoteBorderRadius;
  final List<double> renoteDashPattern;
  final Color currentDisplayTabColor;
  final Color buttonBackground;
  final Languages languages;

  const AppThemeData({
    required this.colorTheme,
    required this.isDarkMode,
    required this.noteTextStyle,
    required this.reactionButtonStyle,
    required this.linkStyle,
    required this.mentionStyle,
    required this.hashtagStyle,
    required this.unicodeEmojiStyle,
    required this.serifStyle,
    required this.monospaceStyle,
    required this.cursiveStyle,
    required this.fantasyStyle,
    required this.reactionButtonMeReactedColor,
    required this.reactionButtonBackgroundColor,
    required this.renoteBorderColor,
    required this.renoteStrokeWidth,
    required this.renoteStrokePadding,
    required this.renoteBorderRadius,
    required this.renoteDashPattern,
    required this.currentDisplayTabColor,
    required this.buttonBackground,
    required this.languages,
  });
}
