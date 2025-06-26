import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/repository/custom_timeline_repository.dart';
import 'package:miria/repository/general_settings_repository.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/repository/note_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:misskey_dart/src/services/api_service.dart';

import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';

class FakeApiService extends Fake implements ApiService {
  String? lastPath;
  Map<String, dynamic>? lastRequest;
  dynamic response;

  @override
  Future<T> post<T>(String path, Map<String, dynamic> request,
      {bool Function(String key, String? value)?
          excludeRemoveNullPredicate}) async {
    lastPath = path;
    lastRequest = request;
    return response as T;
  }
}

void main() {
  group('CustomTimelineRepository', () {
    late MockMisskey misskey;
    late FakeApiService apiService;
    late MockNoteRepository noteRepository;
    late MockGeneralSettingsRepository generalSettings;
    late TabSetting setting;

    setUp(() {
      misskey = MockMisskey();
      apiService = FakeApiService();
      noteRepository = MockNoteRepository();
      generalSettings = MockGeneralSettingsRepository();
      when(generalSettings.settings).thenReturn(const GeneralSettings());
      when(misskey.apiService).thenReturn(apiService);
      when(misskey.host).thenReturn('example.com');
      when(misskey.token).thenReturn('TOKEN');
      when(misskey.socketConnectionTimeout)
          .thenReturn(const Duration(seconds: 20));
      setting = TabSetting(
        icon: const TabIcon(codePoint: 0xe001),
        tabType: TabType.customTimeline,
        acct: TestData.account.acct,
        customApiPath: 'notes/custom',
        customParameters: {'foo': 'bar'},
        customWebSocketPath: null,
      );
    });

    test('initial load uses custom path and parameters', () async {
      apiService.response = [TestData.note1.toJson()];

      final repo = CustomTimelineRepository(
        misskey,
        TestData.account,
        noteRepository,
        generalSettings,
        setting,
      );

      repo.startTimeLine();
      await Future.delayed(Duration.zero);

      expect(apiService.lastPath, 'notes/custom');
      expect(apiService.lastRequest, {'foo': 'bar'});
      expect(repo.olderNotes.first.id, TestData.note1.id);
    });

    test('previousLoad uses untilId when available', () async {
      apiService.response = [TestData.note2.toJson()];
      final repo = CustomTimelineRepository(
        misskey,
        TestData.account,
        noteRepository,
        generalSettings,
        setting,
      );
      repo.olderNotes.add(TestData.note1);

      final count = await repo.previousLoad();

      expect(
          apiService.lastRequest, {'foo': 'bar', 'untilId': TestData.note1.id});
      expect(count, 1);
      expect(repo.olderNotes.last.id, TestData.note2.id);
    });
  });
}
