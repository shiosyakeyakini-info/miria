import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json5/json5.dart';
import 'package:miria/model/color_theme.dart';
import 'package:miria/model/misskey_theme.dart';

void main() {
  final themes = [
    "l-light",
    "d-dark",
    "l-coffee",
    "d-persimmon",
    "l-apricot",
    "d-astro",
    "l-rainy",
    "d-future",
    "l-botanical",
    "d-botanical",
    "l-vivid",
    "d-green-lime",
    "l-cherry",
    "d-green-orange",
    "l-sushi",
    "d-cherry",
    "l-u0",
    "d-ice",
    "d-u0",
  ]
      .map(
        (name) => ColorTheme.misskey(
          MisskeyTheme.fromJson(
            JSON5.parse(
              File(
                "assets_builder/misskey/packages/frontend/src/themes/$name.json5",
              ).readAsStringSync(),
            ),
          ),
        ),
      )
      .map(
        (theme) => 'ColorTheme('
            'id: "${theme.id}", '
            'name: "${theme.name}", '
            'isDarkTheme: ${theme.isDarkTheme}, '
            'primary: ${theme.primary}, '
            'primaryDarken: ${theme.primaryDarken}, '
            'primaryLighten: ${theme.primaryLighten}, '
            'background: ${theme.background}, '
            'foreground: ${theme.foreground}, '
            'renote: ${theme.renote}, '
            'mention: ${theme.mention}, '
            'hashtag: ${theme.hashtag}, '
            'link: ${theme.link}, '
            'divider: ${theme.divider}, '
            'buttonBackground: ${theme.buttonBackground}, '
            'panel: ${theme.panel}, '
            'panelBackground: ${theme.panelBackground}, '
            ')',
      )
      .toList();
  // ignore: avoid_print
  print(themes);
  runApp(MaterialApp(home: Scaffold(body: SelectableText(themes.toString()))));
}
