import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";
import "package:url_launcher_platform_interface/url_launcher_platform_interface.dart";

import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";
import "auth_test_data.dart";

void main() {
  test("誤ったホスト名を入力するとエラーを返すこと", () async {
    final provider = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(MockDio())],
    );
    final accountRepository = provider.read(accountRepositoryProvider.notifier);

    expect(
      () => accountRepository.openMiAuth("https://misskey.io/path"),
      throwsA(isA<InvalidServerException>()),
    );
  });

  test("Misskeyとして読めないサーバーの場合、エラーを返すこと", () async {
    final dio = MockDio();
    // nodeinfoも引けないので、サーバー種別は特定できない。
    // ignore: discarded_futures
    when(dio.getUri(any)).thenAnswer((_) async => throw TestData.response404);
    final mockMisskey = MockMisskey();
    // ignore: discarded_futures
    when(mockMisskey.endpoints()).thenAnswer((_) async => throw Exception());
    final provider = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        misskeyWithoutAccountProvider.overrideWith((ref, host) => mockMisskey),
      ],
    );
    final accountRepository = provider.read(accountRepositoryProvider.notifier);

    await expectLater(
      () async => await accountRepository.openMiAuth("sawakai.space"),
      throwsA(isA<ServerIsNotMisskeyException>()),
    );
  });

  test("Misskeyとして読めない場合、nodeinfoでソフトウェアを特定すること", () async {
    final dio = MockDio();
    when(dio.getUri(any)).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: AuthTestData.mastodonNodeInfo,
      ),
    );
    when(dio.get(any)).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: AuthTestData.mastodonNodeInfo2,
      ),
    );
    final mockMisskey = MockMisskey();
    // ignore: discarded_futures
    when(mockMisskey.endpoints()).thenAnswer((_) async => throw Exception());
    final provider = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        misskeyWithoutAccountProvider.overrideWith((ref, host) => mockMisskey),
      ],
    );
    final accountRepository = provider.read(accountRepositoryProvider.notifier);

    await expectLater(
      () async => await accountRepository.openMiAuth("mastodon.social"),
      throwsA(isA<SoftwareNotSupportedException>()),
    );
  });

  test("連合オフでnodeinfoが403でも、ログインできること", () async {
    // 連合をオフにしたサーバーは .well-known/nodeinfo を403で返す。
    // それを入口にすると本来使えるサーバーが弾かれてしまう。
    // https://github.com/shiosyakeyakini-info/miria/issues/770
    final dio = MockDio();
    // ignore: discarded_futures
    when(dio.getUri(any)).thenAnswer((_) async => throw TestData.response404);
    final mockMisskey = MockMisskey();
    when(mockMisskey.endpoints()).thenAnswer((_) async => ["emojis", "meta"]);
    final mockUrlLauncher = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockUrlLauncher;
    final provider = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        misskeyWithoutAccountProvider.overrideWith((ref, host) => mockMisskey),
      ],
    );
    final accountRepository = provider.read(accountRepositoryProvider.notifier);

    await accountRepository.openMiAuth("http://localhost:3000");

    // nodeinfoを見に行かずにMisskeyと判定できていること。
    verifyNever(dio.getUri(any));
    verify(mockUrlLauncher.launchUrl(any, any));
  });

  // test("非対応のソフトウェアの場合、エラーを返すこと", () async {
  //   final dio = MockDio();
  //   when(dio.getUri(any)).thenAnswer((_) async => Response(
  //       requestOptions: RequestOptions(), data: AuthTestData.calckeyNodeInfo));
  //   when(dio.get(any)).thenAnswer((realInvocation) async => Response(
  //       requestOptions: RequestOptions(), data: AuthTestData.calckeyNodeInfo2));
  //   final mockMisskey = MockMisskey();
  //   final provider = ProviderContainer(
  //     overrides: [
  //       dioProvider.overrideWithValue(dio),
  //       misskeyProvider.overrideWith((ref, account) => mockMisskey),
  //     ],
  //   );
  //   final accountRepository = provider.read(accountRepositoryProvider.notifier);

  //   await expectLater(
  //       () async => await accountRepository.openMiAuth("calckey.jp"),
  //       throwsA(isA<SoftwareNotCompatibleException>()));

  //   verifyInOrder([
  //     dio.getUri(argThat(equals(Uri(
  //         scheme: "https",
  //         host: "calckey.jp",
  //         pathSegments: [".well-known", "nodeinfo"])))),
  //     dio.get(argThat(equals("https://calckey.jp/nodeinfo/2.1")))
  //   ]);
  // });

  test("Misskeyの場合でも、バージョンが古い場合、エラーを返すこと", () async {
    final dio = MockDio();
    when(dio.getUri(any)).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: AuthTestData.oldVerMisskeyNodeInfo,
      ),
    );
    when(dio.get(any)).thenAnswer(
      (realInvocation) async => Response(
        requestOptions: RequestOptions(),
        data: AuthTestData.oldVerMisskeyNodeInfo2,
      ),
    );
    final mockMisskey = MockMisskey();
    when(mockMisskey.endpoints()).thenAnswer((_) async => []);
    when(mockMisskey.meta()).thenAnswer(
      (_) async =>
          MetaResponse.fromJson(jsonDecode(AuthTestData.oldVerMisskeyMeta)),
    );
    final provider = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        misskeyProvider.overrideWith((ref, account) => mockMisskey),
        misskeyWithoutAccountProvider.overrideWith((ref, host) => mockMisskey),
      ],
    );
    final accountRepository = provider.read(accountRepositoryProvider.notifier);

    await expectLater(
      () async => await accountRepository.openMiAuth("misskey.dev"),
      throwsA(isA<SoftwareNotCompatibleException>()),
    );
  });
}
