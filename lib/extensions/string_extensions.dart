import 'package:flutter/widgets.dart';

extension StringExtensions on String {
  String get tight {
    return Characters(this)
        .replaceAll(Characters(' '), Characters('\u{000A0}'))
        .toString();
  }
}
