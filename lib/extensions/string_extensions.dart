import 'package:flutter/widgets.dart';

extension StringExtensions on String {
  String get tight {
    return Characters(this)
        .replaceAll(Characters(''), Characters('\u{200B}'))
        .toString();
  }

  Color? toColor() {
    final code = startsWith("#") ? substring(1) : this;
    switch (code.length) {
      case 3:
        final rgb = code
            .split("")
            .map((c) => int.tryParse(c, radix: 16))
            .nonNulls
            .map((i) => i * 16 + i)
            .toList();
        if (rgb.length == 3) {
          return Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
        }
      case 4:
        final argb = code
            .split("")
            .map((c) => int.tryParse(c, radix: 16))
            .nonNulls
            .map((i) => i * 16 + i)
            .toList();
        if (argb.length != 4) {
          return Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
        }
      case 6:
        final hex = int.tryParse(code, radix: 16);
        if (hex != null) {
          return Color(hex + 0xFF000000);
        }
      case 8:
        final hex = int.tryParse(
          "${code.substring(6)}${code.substring(0, 6)}",
          radix: 16,
        );
        if (hex != null) {
          return Color(hex);
        }
      default:
        return null;
    }
    return null;
  }
}
