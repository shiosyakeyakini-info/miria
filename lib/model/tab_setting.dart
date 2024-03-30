import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/model/acct.dart';
import 'package:miria/model/converters/icon_converter.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/repository/time_line_repository.dart';

part 'tab_setting.freezed.dart';
part 'tab_setting.g.dart';

Map<String, dynamic> _readAcct(Map<dynamic, dynamic> json, String name) {
  final account = json["account"];
  if (account != null) {
    return {
      "host": account["host"],
      "username": account["userId"],
    };
  }
  return json[name]! as Map<String, dynamic>;
}

@freezed
class TabSetting with _$TabSetting {
  const TabSetting._();

  ChangeNotifierProvider<TimelineRepository> get timelineProvider =>
      tabType.timelineProvider(this);

  const factory TabSetting({
    @IconDataConverter() required TabIcon icon,

    /// タブ種別
    required TabType tabType,

    /// ロールタイムラインのノートの場合、ロールID
    String? roleId,

    /// チャンネルのノートの場合、チャンネルID
    String? channelId,

    /// リストのノートの場合、リストID
    String? listId,

    /// アンテナのノートの場合、アンテナID
    String? antennaId,

    /// ノートの投稿のキャプチャをするかどうか
    @Default(true) bool isSubscribe,

    /// 返信を含むかどうか
    @Default(true) bool isIncludeReplies,

    /// ファイルのみにするかどうか
    @Default(false) bool isMediaOnly,

    /// タブ名
    String? name,

    /// アカウント情報
    // https://github.com/rrousselGit/freezed/issues/488
    // ignore: invalid_annotation_target
    @JsonKey(readValue: _readAcct) required Acct acct,

    /// Renoteを表示するかどうか
    @Default(true) bool renoteDisplay,
  }) = _TabSetting;

  factory TabSetting.fromJson(Map<String, Object?> json) =>
      _$TabSettingFromJson(json);
}
