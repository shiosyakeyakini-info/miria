import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Color spin(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslSpinned = hsl.withHue((hsl.hue + amount) % 360);

    return hslSpinned.toColor();
  }

  Color saturate([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslSaturated =
        hsl.withSaturation((hsl.saturation + amount).clamp(0.0, 1.0));

    return hslSaturated.toColor();
  }
}
