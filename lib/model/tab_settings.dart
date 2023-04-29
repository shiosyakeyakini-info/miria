import 'package:flutter/cupertino.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_settings.freezed.dart';

@freezed
class TabSettings with _$TabSettings {
  const factory TabSettings({
    required IconData icon,
    required TabType tabType,
    String? channelId,
  }) = _TabSettings;
}
