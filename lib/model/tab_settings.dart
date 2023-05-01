import 'package:flutter/cupertino.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_settings.freezed.dart';

@freezed
class TabSettings with _$TabSettings {
  const TabSettings._();

  ChangeNotifierProvider<TimeLineRepository> get timelineProvider =>
      tabType.timelineProvider(this);

  const factory TabSettings({
    required IconData icon,
    required TabType tabType,
    String? channelId,
    required String name,
  }) = _TabSettings;
}
