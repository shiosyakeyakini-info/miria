import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'federation_data.freezed.dart';

@freezed
class FederationData with _$FederationData {
  const factory FederationData({
    String? bannerUrl,
    String? faviconUrl,
    String? tosUrl,
    @Default("") String name,
    @Default("") String description,
    int? usersCount,
    int? notesCount,
    int? reactionCount,
    @Default("") String softwareName,
    @Default("") String softwareVersion,
    @Default([]) List<String> languages,
    @Default([]) List<MetaAd> ads,
    required bool isSupportedEmoji,
    required bool isSupportedAnnouncement,
    required bool isSupportedLocalTimeline,
  }) = _FederationData;
}
