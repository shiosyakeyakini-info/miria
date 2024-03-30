import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/account_repository.dart';
import 'package:miria/router/app_router.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';

class TimelinePageTest {
  final mockMisskey = MockMisskey();
  final mockMisskeyNotes = MockMisskeyNotes();
  final mockMisskeyI = MockMisskeyI();
  final mockSocketController = MockSocketController();
  final mockStreamingService = MockStreamingService();
  final mockAccountRepository = MockAccountRepository();
  final mockTabSettingsRepository = MockTabSettingsRepository();
  late final TabSetting tabSetting;

  TimelinePageTest({
    required TabType tabType,
    isSubscribe = false,
    isIncludeReplies = false,
    isMediaOnly = false,
    String? roleId,
    String? antennaId,
    String? channelId,
    String? listId,
    bool renoteDisplay = false,
  }) {
    tabSetting = TabSetting(
      icon: const TabIcon(customEmojiName: ":ai_yay:"),
      tabType: tabType,
      isSubscribe: isSubscribe,
      isIncludeReplies: isIncludeReplies,
      isMediaOnly: isMediaOnly,
      roleId: roleId,
      antennaId: antennaId,
      channelId: channelId,
      listId: listId,
      name: "ろーかる",
      acct: TestData.account.acct,
      renoteDisplay: renoteDisplay,
    ).copyWith();
    when(mockMisskey.notes).thenReturn(mockMisskeyNotes);
    when(mockMisskey.streamingService).thenReturn(mockStreamingService);
    when(mockMisskey.i).thenReturn(mockMisskeyI);
    when(mockMisskey.meta()).thenAnswer((_) async => TestData.meta);

    when(mockMisskeyI.i()).thenAnswer((_) async => TestData.account.i);

    when(mockTabSettingsRepository.tabSettings).thenReturn([tabSetting]);
  }

  Widget buildWidget({
    List<Override> overrides = const [],
  }) {
    final mockAccountRepository = AccountRepository();

    return ProviderScope(
      overrides: [
        misskeyProvider.overrideWith((ref, arg) => mockMisskey),
        tabSettingsRepositoryProvider
            .overrideWith((ref) => mockTabSettingsRepository),
        accountsProvider.overrideWith((ref) => [TestData.account]),
        accountRepositoryProvider.overrideWith(() {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            mockAccountRepository.state = [TestData.account];
          });
          return mockAccountRepository;
        }),
        emojiRepositoryProvider
            .overrideWith((ref, arg) => MockEmojiRepository())
      ],
      child: DefaultRootWidget(
        initialRoute: TimeLineRoute(initialTabSetting: tabSetting),
      ),
    );
  }
}
