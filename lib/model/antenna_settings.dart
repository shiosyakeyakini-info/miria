import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'antenna_settings.freezed.dart';

@freezed
class AntennaSettings with _$AntennaSettings {
  const factory AntennaSettings({
    @Default("") String name,
    @Default(AntennaSource.all) AntennaSource src,
    String? userListId,
    @Default([]) List<List<String>> keywords,
    @Default([]) List<List<String>> excludeKeywords,
    @Default([]) List<String> users,
    @Default(false) bool caseSensitive,
    @Default(false) bool withReplies,
    @Default(false) bool withFile,
    @Default(false) bool notify,
    @Default(false) bool localOnly,
  }) = _AntennaSettings;
  const AntennaSettings._();

  factory AntennaSettings.fromAntenna(Antenna antenna) {
    return AntennaSettings(
      name: antenna.name,
      src: antenna.src,
      userListId: antenna.userListId,
      keywords: antenna.keywords,
      excludeKeywords: antenna.excludeKeywords,
      users: antenna.users,
      caseSensitive: antenna.caseSensitive,
      withReplies: antenna.withReplies,
      withFile: antenna.withFile,
      notify: antenna.notify,
      localOnly: antenna.localOnly ?? false,
    );
  }
}
