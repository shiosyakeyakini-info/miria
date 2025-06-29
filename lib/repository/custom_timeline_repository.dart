import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

/// Timeline repository for custom endpoints.
class CustomTimelineRepository extends SocketTimelineRepository {
  CustomTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  Future<Iterable<Note>> _request({String? untilId}) async {
    final path = tabSetting.customApiPath;
    if (path == null) return [];
    final params = Map<String, dynamic>.from(tabSetting.customParameters ?? {});
    if (untilId != null) params["untilId"] = untilId;
    final res = await misskey.apiService.post<List>(path, params);
    return res.map((e) => Note.fromJson(e));
  }

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) =>
      _request(untilId: untilId);

  @override
  Channel get channel {
    final channelName = tabSetting.customChannelName;
    return channelName != null
        ? Channel.custom(channelName)
        : Channel.homeTimeline();
  }

  @override
  Map<String, dynamic> get parameters => tabSetting.customParameters ?? {};
}
