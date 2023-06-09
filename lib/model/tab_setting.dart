import 'package:miria/model/account.dart';
import 'package:miria/model/converters/icon_converter.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/repository/time_line_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_setting.freezed.dart';
part 'tab_setting.g.dart';

@freezed
class TabSetting with _$TabSetting {
  const TabSetting._();

  ChangeNotifierProvider<TimelineRepository> get timelineProvider =>
      tabType.timelineProvider(this);

  const factory TabSetting({
    @IconDataConverter() required TabIcon icon,

    /// タブ種別
    required TabType tabType,

    /// チャンネルのノートの場合、チャンネルID
    String? channelId,

    /// リストのノートの場合、リストID
    String? listId,

    /// アンテナのノートの場合、アンテナID
    String? antennaId,

    /// ノートの投稿のキャプチャをするかどうか
    @Default(true) isSubscribe,

    /// タブ名
    required String name,

    /// アカウント情報
    required Account account,
    @Default(true) bool renoteDisplay,
  }) = _TabSetting;

  factory TabSetting.fromJson(Map<String, Object?> json) =>
      _$TabSettingFromJson(json);
}
