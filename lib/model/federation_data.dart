import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'federation_data.freezed.dart';

@freezed
class FederationData with _$FederationData {
  const factory FederationData({
    String? bannerUrl,
    String? faviconUrl,
    String? tosUrl,
    String? privacyPolicyUrl,
    String? impressumUrl,
    String? repositoryUrl,
    @Default([]) List<String> serverRules,
    @Default("") String name,
    @Default("") String description,
    String? maintainerName,
    String? maintainerEmail,
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
    MetaResponse? meta,
  }) = _FederationData;
}
