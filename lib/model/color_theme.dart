import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

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
    required Color background,
    required Color foreground,
    required Color renote,
    required Color mention,
    required Color hashtag,
    required Color link,
    required Color divider,
    required Color buttonBackground,
    required Color panel,
    required Color panelBackground,
  }) = _ColorTheme;
}
