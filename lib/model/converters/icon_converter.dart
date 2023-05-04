import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class IconDataConverter extends JsonConverter<IconData, int> {
  const IconDataConverter();

  @override
  IconData fromJson(int json) => IconData(json, fontFamily: 'MaterialIcons');

  @override
  int toJson(IconData object) => object.codePoint;
}
