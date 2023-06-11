import 'dart:math';

import 'package:image_editor/image_editor.dart';
import 'package:miria/extensions/color_option_extension.dart';

class ColorFilterPresets {
  final List<ColorFilterPreset> presets;

  ColorFilterPresets()
      : presets = [
          ColorFilterPreset(
              name: "clarendon",
              option: [_brightness(.1), _contrast(.1), _saturation(.15)]),
          ColorFilterPreset(
              name: "addictiveRed", option: [_addictiveColor(50, 0, 0)]),
          ColorFilterPreset(
              name: "addictiveGreen", option: [_addictiveColor(0, 50, 0)]),
          ColorFilterPreset(
              name: "addictiveBlue", option: [_addictiveColor(0, 0, 50)]),
          ColorFilterPreset(
              name: "gingham", option: [_sepia(.04), _contrast(-.15)]),
          ColorFilterPreset(
              name: "moon",
              option: [_grayscale(), _contrast(-.04), _brightness(0.1)]),
          ColorFilterPreset(name: "lark", option: [
            _brightness(0.08),
            _grayscale(),
            _contrast(-.04),
          ]),
          ColorFilterPreset(
              name: "Reyes",
              option: [_sepia(0.4), _brightness(0.13), _contrast(-.06)]),
          ColorFilterPreset(
              name: "Juno",
              option: [_rgbScale(1.01, 1.04, 1), _saturation(0.3)]),
          ColorFilterPreset(
              name: "Slumber", option: [_brightness(.1), _saturation(-0.5)]),
          ColorFilterPreset(
              name: "Crema",
              option: [_rgbScale(1.04, 1, 1.02), _saturation(-0.05)]),
          ColorFilterPreset(
              name: "Ludwig", option: [_brightness(.05), _saturation(-0.03)]),
          ColorFilterPreset(
              name: "Aden",
              option: [_colorOverlay(228, 130, 225, 0.13), _saturation(-0.2)]),
          ColorFilterPreset(
              name: "Perpetua", option: [_rgbScale(1.05, 1.1, 1)]),
          ColorFilterPreset(name: "Amaro", option: [
            _saturation(0.3),
            _brightness(0.15),
          ]),
          ColorFilterPreset(
              name: "Mayfair",
              option: [_colorOverlay(230, 115, 108, 0.05), _saturation(0.15)]),
          ColorFilterPreset(name: "Rise", option: [
            _colorOverlay(255, 170, 0, 0.1),
            _brightness(0.09),
            _saturation(0.1)
          ]),
          ColorFilterPreset(name: "Hudson", option: [
            _rgbScale(1, 1, 1.25),
            _contrast(0.1),
            _brightness(0.15)
          ]),
          ColorFilterPreset(name: "Valencia", option: [
            _colorOverlay(255, 255, 80, 0.8),
            _saturation(0.1),
            _contrast(0.05),
          ]),
          ColorFilterPreset(name: "X-Pro II", option: [
            _colorOverlay(255, 255, 0, 0.7),
            _saturation(0.2),
            _contrast(0.15)
          ]),
          ColorFilterPreset(
              name: "Sierra", option: [_contrast(-0.15), _saturation(0.1)]),
          ColorFilterPreset(
              name: "Lo-Fi", option: [_contrast(0.15), _saturation(0.2)]),
          ColorFilterPreset(name: "InkWell", option: [_grayscale()]),
          ColorFilterPreset(
              name: "Hefe", option: [_contrast(0.1), _saturation(0.15)]),
          ColorFilterPreset(
              name: "Nashville",
              option: [_colorOverlay(220, 115, 188, 0.12), _contrast(-0.05)]),
          ColorFilterPreset(
              name: "Stinson", option: [_brightness(0.1), _sepia(0.3)]),
          ColorFilterPreset(name: "Vesper", option: [
            _colorOverlay(225, 225, 0, 0.5),
            _brightness(0.06),
            _contrast(0.06)
          ]),
          ColorFilterPreset(
              name: "Earlybird",
              option: [_colorOverlay(255, 165, 40, 0.2), _saturation(0.15)]),
          ColorFilterPreset(
              name: "Brannan",
              option: [_contrast(0.2), _colorOverlay(140, 10, 185, 0.1)]),
          ColorFilterPreset(
              name: "Sutro", option: [_brightness(-0.1), _saturation(-0.1)]),
          ColorFilterPreset(
              name: "Toaster",
              option: [_sepia(0.1), _colorOverlay(255, 145, 0, 0.2)]),
          ColorFilterPreset(
              name: "Walden",
              option: [_brightness(0.1), _colorOverlay(255, 255, 0, 0.2)]),
          ColorFilterPreset(
              name: "1997",
              option: [_colorOverlay(255, 25, 0, 0.15), _brightness(0.1)]),
          ColorFilterPreset(name: "Kelvin", option: [
            _colorOverlay(255, 140, 0, 0.1),
            _rgbScale(1.15, 1.05, 1),
            _saturation(0.35)
          ]),
          ColorFilterPreset(name: "Maven", option: [
            _colorOverlay(225, 240, 0, 0.1),
            _saturation(0.25),
            _contrast(0.05)
          ]),
          ColorFilterPreset(
              name: "Ginza", option: [_sepia(0.06), _brightness(0.1)]),
          ColorFilterPreset(
              name: "Skyline", option: [_saturation(0.35), _brightness(0.1)]),
          ColorFilterPreset(
              name: "Dogpatch", option: [_contrast(0.15), _brightness(0.1)]),
          ColorFilterPreset(
              name: "Brooklyn",
              option: [_colorOverlay(25, 240, 252, 0.05), _sepia(0.3)]),
          ColorFilterPreset(
              name: "Helena",
              option: [_colorOverlay(208, 208, 86, 0.2), _contrast(0.15)]),
          ColorFilterPreset(
              name: "Ashby",
              option: [_colorOverlay(255, 160, 25, 0.1), _brightness(0.1)]),
          ColorFilterPreset(
              name: "Charmes",
              option: [_colorOverlay(255, 50, 80, 0.12), _contrast(0.05)])
        ];
}

class ColorFilterPreset {
  final String name;
  final List<ColorOption> option;

  const ColorFilterPreset({required this.name, required this.option});
}

ColorOption _colorOverlay(double red, double green, double blue, double scale) {
  return ColorOption(matrix: [
    (1 - scale),
    0,
    0,
    0,
    -1 * red * scale,
    0,
    (1 - scale),
    0,
    0,
    -1 * green * scale,
    0,
    0,
    (1 - scale),
    0,
    -1 * blue * scale,
    0,
    0,
    0,
    1,
    0
  ]);
}

ColorOption _rgbScale(double r, double g, double b) {
  return ColorOption(matrix: [
    r,
    0,
    0,
    0,
    0,
    0,
    g,
    0,
    0,
    0,
    0,
    0,
    b,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);
}

ColorOption _addictiveColor(double r, double g, double b) {
  return ColorOption(matrix: [
    1,
    0,
    0,
    0,
    r,
    0,
    1,
    0,
    0,
    g,
    0,
    0,
    1,
    0,
    b,
    0,
    0,
    0,
    1,
    0,
  ]);
}

ColorOption _grayscale() {
  return ColorOption(matrix: [
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);
}

ColorOption _sepia(double value) {
  return ColorOption(matrix: [
    (1 - (0.607 * value)),
    0.769 * value,
    0.189 * value,
    0,
    0,
    0.349 * value,
    (1 - (0.314 * value)),
    0.168 * value,
    0,
    0,
    0.272 * value,
    0.534 * value,
    (1 - (0.869 * value)),
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);
}

ColorOption _invert() {
  return ColorOption(matrix: [
    -1,
    0,
    0,
    0,
    255,
    0,
    -1,
    0,
    0,
    255,
    0,
    0,
    -1,
    0,
    255,
    0,
    0,
    0,
    1,
    0,
  ]);
}

ColorOption _hue(double value) {
  value = value * pi;

  if (value == 0) {
    return ColorOption(matrix: [
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
  }

  var cosVal = cos(value);
  var sinVal = sin(value);
  var lumR = 0.213;
  var lumG = 0.715;
  var lumB = 0.072;

  return ColorOption(
      matrix: List<double>.from(<double>[
    (lumR + (cosVal * (1 - lumR))) + (sinVal * (-lumR)),
    (lumG + (cosVal * (-lumG))) + (sinVal * (-lumG)),
    (lumB + (cosVal * (-lumB))) + (sinVal * (1 - lumB)),
    0,
    0,
    (lumR + (cosVal * (-lumR))) + (sinVal * 0.143),
    (lumG + (cosVal * (1 - lumG))) + (sinVal * 0.14),
    (lumB + (cosVal * (-lumB))) + (sinVal * (-0.283)),
    0,
    0,
    (lumR + (cosVal * (-lumR))) + (sinVal * (-(1 - lumR))),
    (lumG + (cosVal * (-lumG))) + (sinVal * lumG),
    (lumB + (cosVal * (1 - lumB))) + (sinVal * lumB),
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]).map((i) => i.toDouble()).toList());
}

ColorOption _brightness(double value) {
  if (value <= 0) {
    value = value * 255;
  } else {
    value = value * 100;
  }

  if (value == 0) {
    return ColorOption(matrix: [
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
  }

  return ColorOption(
      matrix: List<double>.from(<double>[
    1,
    0,
    0,
    0,
    value,
    0,
    1,
    0,
    0,
    value,
    0,
    0,
    1,
    0,
    value,
    0,
    0,
    0,
    1,
    0
  ]).map((i) => i.toDouble()).toList());
}

ColorOption _contrast(double value) {
// RGBA contrast(RGBA color, num adj) {
//   adj *= 255;
//   double factor = (259 * (adj + 255)) / (255 * (259 - adj));
//   return new RGBA(
//     red: (factor * (color.red - 128) + 128),
//     green: (factor * (color.green - 128) + 128),
//     blue: (factor * (color.blue - 128) + 128),
//     alpha: color.alpha,
//   );
// }
  double adj = value * 255;
  double factor = (259 * (adj + 255)) / (255 * (259 - adj));

  return ColorOption(matrix: [
    factor,
    0,
    0,
    0,
    128 * (1 - factor),
    0,
    factor,
    0,
    0,
    128 * (1 - factor),
    0,
    0,
    factor,
    0,
    128 * (1 - factor),
    0,
    0,
    0,
    1,
    0,
  ]);
}

ColorOption _saturation(double value) {
  value = value * 100;

  if (value == 0) {
    return ColorOption(matrix: [
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
  }

  var x =
      ((1 + ((value > 0) ? ((3 * value) / 100) : (value / 100)))).toDouble();
  var lumR = 0.3086;
  var lumG = 0.6094;
  var lumB = 0.082;

  return ColorOption(
      matrix: List<double>.from(<double>[
    (lumR * (1 - x)) + x,
    lumG * (1 - x),
    lumB * (1 - x),
    0,
    0,
    lumR * (1 - x),
    (lumG * (1 - x)) + x,
    lumB * (1 - x),
    0,
    0,
    lumR * (1 - x),
    lumG * (1 - x),
    (lumB * (1 - x)) + x,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]).map((i) => i.toDouble()).toList());
}
