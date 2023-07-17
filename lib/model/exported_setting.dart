import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/model/tab_setting.dart';

part 'exported_setting.freezed.dart';
part 'exported_setting.g.dart';

@freezed
class ExportedSetting with _$ExportedSetting {
  const factory ExportedSetting({
    @Default([]) List<AccountSettings> accountSettings,
    required GeneralSettings generalSettings,
    @Default([]) List<TabSetting> tabSettings,
  }) = _ExportedSetting;

  factory ExportedSetting.fromJson(Map<String, dynamic> json) =>
      _$ExportedSettingFromJson(json);
}
