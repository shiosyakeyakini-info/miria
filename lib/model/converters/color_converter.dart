import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ColorConverter extends JsonConverter<Color?, int?> {
  const ColorConverter();

  @override
  Color? fromJson(int? json) => json == null ? null : Color(json);

  @override
  int? toJson(Color? object) => object?.value;
}
