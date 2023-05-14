import 'package:flutter/material.dart';

class AppTheme extends InheritedWidget {
  final AppThemeData themeData;

  const AppTheme({super.key, required super.child, required this.themeData});

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return oldWidget.themeData != themeData;
  }

  static AppThemeData of(BuildContext context) {
    final account = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    if (account == null) {
      throw Exception("has not ancestor");
    }

    return account.themeData;
  }
}

class AppThemeData {
  final InputDecoration noteTextStyle;
  final ButtonStyle reactionButtonStyle;
  final TextStyle linkStyle;

  const AppThemeData({
    required this.noteTextStyle,
    required this.reactionButtonStyle,
    required this.linkStyle,
  });
}
