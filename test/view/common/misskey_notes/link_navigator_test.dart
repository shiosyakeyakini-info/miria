import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/link_navigator.dart";
import "package:mockito/mockito.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:url_launcher_platform_interface/url_launcher_platform_interface.dart";

import "../../../test_util/default_root_widget.dart";
import "../../../test_util/mock.mocks.dart";
import "../../../test_util/test_datas.dart";

const externalUrl = "https://example.com/gaibu";

Widget buildTestWidget({
  required List<Override> overrides,
  String url = externalUrl,
}) => ProviderScope(
  overrides: overrides,
  child: DefaultRootNoRouterWidget(
    child: Scaffold(
      body: AccountContextScope.as(
        account: TestData.account,
        child: Consumer(
          builder: (context, ref, _) => ElevatedButton(
            onPressed: () async =>
                const LinkNavigator().onTapLink(context, ref, url, null),
            child: const Text("ひらく"),
          ),
        ),
      ),
    ),
  ),
);

/// [PreferredLaunchMode] で呼び出しを絞りこむ matcher
Matcher launchedWith(PreferredLaunchMode mode) =>
    predicate<LaunchOptions?>((options) => options?.mode == mode);

void main() {
  group("外部サイトのリンク", () {
    late MockUrlLauncherPlatform mockUrlLauncher;
    late MockMisskey mockMisskey;
    late List<Override> overrides;

    setUp(() {
      mockUrlLauncher = MockUrlLauncherPlatform();
      UrlLauncherPlatform.instance = mockUrlLauncher;
      when(mockUrlLauncher.canLaunch(any)).thenAnswer((_) async => true);

      // Misskeyではないサーバーなので、メタ情報の取得に失敗する
      mockMisskey = MockMisskey();
      when(mockMisskey.meta()).thenThrow(Exception("not misskey"));

      overrides = [
        misskeyWithoutAccountProvider.overrideWith((ref, host) => mockMisskey),
      ];
    });

    testWidgets("URLを扱えるアプリがない場合、外部ブラウザで開かれること", (tester) async {
      // iOSでは、Universal Linkを扱えるアプリがないとき例外ではなくfalseが返る。
      // 例外だけを見ているとフォールバックが発火せず、なにも起きなくなる。
      when(mockUrlLauncher.launchUrl(any, any)).thenAnswer((invocation) async {
        final options = invocation.positionalArguments[1] as LaunchOptions;
        return options.mode !=
            PreferredLaunchMode.externalNonBrowserApplication;
      });

      await tester.pumpWidget(buildTestWidget(overrides: overrides));
      await tester.pumpAndSettle();
      await tester.tap(find.text("ひらく"));
      await tester.pumpAndSettle();

      verify(
        mockUrlLauncher.launchUrl(
          externalUrl,
          argThat(launchedWith(PreferredLaunchMode.externalApplication)),
        ),
      ).called(1);
    });

    testWidgets("例外が投げられた場合も、外部ブラウザで開かれること", (tester) async {
      // Androidはfalseを返さずPlatformExceptionを投げる
      when(
        mockUrlLauncher.launchUrl(
          any,
          argThat(
            launchedWith(PreferredLaunchMode.externalNonBrowserApplication),
          ),
        ),
      ).thenThrow(PlatformException(code: "ACTIVITY_NOT_FOUND"));
      when(
        mockUrlLauncher.launchUrl(
          any,
          argThat(launchedWith(PreferredLaunchMode.externalApplication)),
        ),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(buildTestWidget(overrides: overrides));
      await tester.pumpAndSettle();
      await tester.tap(find.text("ひらく"));
      await tester.pumpAndSettle();

      verify(
        mockUrlLauncher.launchUrl(
          externalUrl,
          argThat(launchedWith(PreferredLaunchMode.externalApplication)),
        ),
      ).called(1);
    });

    testWidgets("URLを扱えるアプリがある場合、外部ブラウザは開かれないこと", (tester) async {
      when(mockUrlLauncher.launchUrl(any, any)).thenAnswer((_) async => true);

      await tester.pumpWidget(buildTestWidget(overrides: overrides));
      await tester.pumpAndSettle();
      await tester.tap(find.text("ひらく"));
      await tester.pumpAndSettle();

      verify(
        mockUrlLauncher.launchUrl(
          externalUrl,
          argThat(
            launchedWith(PreferredLaunchMode.externalNonBrowserApplication),
          ),
        ),
      ).called(1);
      verifyNever(
        mockUrlLauncher.launchUrl(
          any,
          argThat(launchedWith(PreferredLaunchMode.externalApplication)),
        ),
      );
    });
  });
}
