import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";
import "../../test_util/widget_tester_extension.dart";

void main() {
  group("チャンネル", () {
    group("チャンネル検索", () {
      testWidgets("チャンネル検索ができること", (tester) async {
        final channel = MockMisskeyChannels();
        final misskey = MockMisskey();
        when(misskey.channels).thenReturn(channel);
        when(channel.search(any)).thenAnswer(
          (_) async => [TestData.channel1.copyWith(bannerUrl: null)],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [misskeyProvider.overrideWith((_) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ChannelsRoute(
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text("検索"));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), "ゲーム開発部");
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(find.text(TestData.channel1.name), findsOneWidget);
        verify(
          channel.search(
            argThat(equals(const ChannelsSearchRequest(query: "ゲーム開発部"))),
          ),
        );

        await tester.pageNation();
        verify(
          channel.search(
            argThat(
              equals(
                ChannelsSearchRequest(
                  query: "ゲーム開発部",
                  untilId: TestData.channel1.id,
                ),
              ),
            ),
          ),
        );
      });
    });

    group("トレンド", () {
      testWidgets("トレンドが表示されること", (tester) async {
        final channel = MockMisskeyChannels();
        final misskey = MockMisskey();
        when(misskey.channels).thenReturn(channel);
        when(channel.featured()).thenAnswer(
          (_) async => [TestData.channel1.copyWith(bannerUrl: null)],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [misskeyProvider.overrideWith((_) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ChannelsRoute(
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text("トレンド"));
        await tester.pumpAndSettle();

        expect(find.text(TestData.channel1.name), findsOneWidget);
      });
    });

    group("お気に入り", () {
      testWidgets("お気に入り中のチャンネルが表示されること", (tester) async {
        final channel = MockMisskeyChannels();
        final misskey = MockMisskey();
        when(misskey.channels).thenReturn(channel);
        when(channel.myFavorite(any)).thenAnswer(
          (_) async => [TestData.channel1.copyWith(bannerUrl: null)],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [misskeyProvider.overrideWith((_) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ChannelsRoute(
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text("お気に入り"));
        await tester.pumpAndSettle();

        expect(find.text(TestData.channel1.name), findsOneWidget);
        verify(
          channel
              .myFavorite(argThat(equals(const ChannelsMyFavoriteRequest()))),
        );
      });
    });

    group("フォロー中", () {
      testWidgets("フォロー中のチャンネルが表示されること", (tester) async {
        final channel = MockMisskeyChannels();
        final misskey = MockMisskey();
        when(misskey.channels).thenReturn(channel);
        when(channel.followed(any)).thenAnswer(
          (_) async => [TestData.channel1.copyWith(bannerUrl: null)],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [misskeyProvider.overrideWith((_) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ChannelsRoute(
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text("フォロー中"));
        await tester.pumpAndSettle();

        expect(find.text(TestData.channel1.name), findsOneWidget);
        verify(
          channel.followed(argThat(equals(const ChannelsFollowedRequest()))),
        );
        await tester.pageNation();
        verify(
          channel.followed(
            argThat(
              equals(ChannelsFollowedRequest(untilId: TestData.channel1.id)),
            ),
          ),
        );
      });
    });
  });
}
