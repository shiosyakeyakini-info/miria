import 'package:flutter/material.dart';

class AppTheme extends InheritedWidget {
  final AppThemeData lightThemeData;
  final AppThemeData darkThemeData;

  const AppTheme({
    super.key,
    required super.child,
    required this.lightThemeData,
    required this.darkThemeData,
  });

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return oldWidget.lightThemeData != lightThemeData ||
        oldWidget.darkThemeData != darkThemeData;
  }

  static AppThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    if (theme == null) {
      throw Exception("has not ancestor");
    }

    if (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.light) {
      return theme.lightThemeData;
    } else {
      return theme.darkThemeData;
    }
  }
}

class AppThemeData {
  final InputDecoration noteTextStyle;
  final ButtonStyle reactionButtonStyle;
  final TextStyle linkStyle;
  final Color reactionButtonMeReactedColor;
  final Color reactionButtonBackgroundColor;

  const AppThemeData({
    required this.noteTextStyle,
    required this.reactionButtonStyle,
    required this.linkStyle,
    required this.reactionButtonMeReactedColor,
    required this.reactionButtonBackgroundColor,
  });
}
