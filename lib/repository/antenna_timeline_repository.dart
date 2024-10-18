import "dart:async";

import "package:miria/repository/socket_timeline_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class AntennaTimelineRepository extends SocketTimelineRepository {
  AntennaTimelineRepository(
    super.misskey,
    super.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    super.ref,
  );

  @override
  Future<Iterable<Note>> requestNotes({String? untilId}) async {
    return await misskey.antennas.notes(
      AntennasNotesRequest(
        antennaId: tabSetting.antennaId!,
        limit: 30,
        untilId: untilId,
      ),
    );
  }

  @override
  Channel get channel => Channel.antenna;

  @override
  Map<String, dynamic> get parameters => {"antennaId": tabSetting.antennaId};
}
