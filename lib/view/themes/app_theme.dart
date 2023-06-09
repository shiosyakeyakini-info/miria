import 'package:flutter/material.dart';

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
  final bool isDarkMode;
  final InputDecoration noteTextStyle;
  final ButtonStyle reactionButtonStyle;
  final TextStyle linkStyle;
  final TextStyle mentionStyle;
  final TextStyle hashtagStyle;
  final TextStyle unicodeEmojiStyle;
  final Color reactionButtonMeReactedColor;
  final Color reactionButtonBackgroundColor;
  final Color renoteBorderColor;
  final double renoteStrokeWidth;
  final double renoteStrokePadding;
  final Radius renoteBorderRadius;
  final List<double> renoteDashPattern;
  final Color currentDisplayTabColor;
  final Color voteColor1;
  final Color voteColor2;

  const AppThemeData({
    required this.isDarkMode,
    required this.noteTextStyle,
    required this.reactionButtonStyle,
    required this.linkStyle,
    required this.mentionStyle,
    required this.hashtagStyle,
    required this.unicodeEmojiStyle,
    required this.reactionButtonMeReactedColor,
    required this.reactionButtonBackgroundColor,
    required this.renoteBorderColor,
    required this.renoteStrokeWidth,
    required this.renoteStrokePadding,
    required this.renoteBorderRadius,
    required this.renoteDashPattern,
    required this.currentDisplayTabColor,
    required this.voteColor1,
    required this.voteColor2,
  });
}
