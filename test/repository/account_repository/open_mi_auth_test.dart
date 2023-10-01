import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/account_repository.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';
import 'auth_test_data.dart';

void main() {
  test("誤ったホスト名を入力するとエラーを返すこと", () async {
    final provider = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(MockDio())]);
    final accountRepository = AccountRepository(MockTabSettingsRepository(),
        MockAccountSettingsRepository(), provider.read);

    expect(() => accountRepository.openMiAuth("https://misskey.io/"),
        throwsA(isA<SpecifiedException>()));
  });

  test("Activity Pub非対応サーバーの場合、エラーを返すこと", () {
    final dio = MockDio();
    when(dio.getUri(any)).thenAnswer((_) async => throw TestData.response404);
    final provider =
        ProviderContainer(overrides: [dioProvider.overrideWithValue(dio)]);
    final accountRepository = AccountRepository(MockTabSettingsRepository(),
        MockAccountSettingsRepository(), provider.read);

    expect(() async => await accountRepository.openMiAuth("sawakai.space"),
        throwsA(isA<SpecifiedException>()));
    verify(dio.getUri(argThat(equals(Uri(
        scheme: "https",
        host: "sawakai.space",
        pathSegments: [".well-known", "nodeinfo"])))));
  });

  test("非対応のソフトウェアの場合、エラーを返すこと", () async {
    final dio = MockDio();
    when(dio.getUri(any)).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(), data: AuthTestData.calckeyNodeInfo));
    when(dio.get(any)).thenAnswer((realInvocation) async => Response(
        requestOptions: RequestOptions(), data: AuthTestData.calckeyNodeInfo2));
    final mockMisskey = MockMisskey();
    when(mockMisskey.endpoints()).thenAnswer((_) async => []);
    final provider = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        misskeyProvider.overrideWith((ref, arg) => mockMisskey),
      ],
    );
    final accountRepository = AccountRepository(MockTabSettingsRepository(),
        MockAccountSettingsRepository(), provider.read);

    await expectLater(
        () async => await accountRepository.openMiAuth("calckey.jp"),
        throwsA(isA<SpecifiedException>()));

    verifyInOrder([
      dio.getUri(argThat(equals(Uri(
          scheme: "https",
          host: "calckey.jp",
          pathSegments: [".well-known", "nodeinfo"])))),
      dio.get(argThat(equals("https://calckey.jp/nodeinfo/2.1")))
    ]);
  });

  test("Misskeyの場合でも、バージョンが古い場合、エラーを返すこと", () async {
    final dio = MockDio();
    when(dio.getUri(any)).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(),
        data: AuthTestData.oldVerMisskeyNodeInfo));
    when(dio.get(any)).thenAnswer((realInvocation) async => Response(
        requestOptions: RequestOptions(),
        data: AuthTestData.oldVerMisskeyNodeInfo2));
    final mockMisskey = MockMisskey();
    when(mockMisskey.endpoints()).thenAnswer((_) async => []);
    final provider = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        misskeyProvider.overrideWith((ref, arg) => mockMisskey),
      ],
    );
    final accountRepository = AccountRepository(MockTabSettingsRepository(),
        MockAccountSettingsRepository(), provider.read);

    await expectLater(
        () async => await accountRepository.openMiAuth("misskey.dev"),
        throwsA(isA<SpecifiedException>()));
  });
}
