import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/model/tab_icon.dart';

class IconDataConverter extends JsonConverter<TabIcon, dynamic> {
  const IconDataConverter();

  @override
  TabIcon fromJson(dynamic json) {
    if (json is int) {
      // old compatibility
      return TabIcon(codePoint: json);
    } else if (json is Map<String, dynamic>) {
      return TabIcon.fromJson(json);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  dynamic toJson(TabIcon object) => object.toJson();
}
