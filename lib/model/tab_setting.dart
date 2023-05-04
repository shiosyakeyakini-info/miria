import 'package:flutter/cupertino.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/model/converters/icon_converter.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_setting.freezed.dart';
part 'tab_setting.g.dart';

@freezed
class TabSetting with _$TabSetting {
  const TabSetting._();

  ChangeNotifierProvider<TimeLineRepository> get timelineProvider =>
      tabType.timelineProvider(this);

  const factory TabSetting({
    @IconDataConverter() required IconData icon,
    required TabType tabType,
    String? channelId,
    required String name,
    required Account account,
  }) = _TabSetting;

  factory TabSetting.fromJson(Map<String, Object?> json) =>
      _$TabSettingFromJson(json);
}
