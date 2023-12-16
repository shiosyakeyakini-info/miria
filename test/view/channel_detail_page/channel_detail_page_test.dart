import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';
import '../../test_util/widget_tester_extension.dart';

void main() {
  group("チャンネル詳細", () {
    testWidgets("チャンネルの詳細情報が表示されること", (tester) async {
      final channel = MockMisskeyChannels();
      final misskey = MockMisskey();
      when(misskey.channels).thenReturn(channel);
      when(channel.show(any))
          .thenAnswer((_) async => TestData.channel1.copyWith(bannerUrl: null));

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ChannelDetailRoute(
                account: TestData.account, channelId: TestData.channel1.id),
          )));
      await tester.pumpAndSettle();

      expect(
          find.textContaining(TestData.expectChannel1DescriptionContaining,
              findRichText: true),
          findsOneWidget);
    });

    testWidgets("チャンネルがセンシティブの場合、センシティブである旨が表示されること", (tester) async {
      final channel = MockMisskeyChannels();
      final misskey = MockMisskey();
      when(misskey.channels).thenReturn(channel);
      when(channel.show(any)).thenAnswer((_) async =>
          TestData.channel1.copyWith(bannerUrl: null, isSensitive: true));

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ChannelDetailRoute(
                account: TestData.account, channelId: TestData.channel1.id),
          )));
      await tester.pumpAndSettle();

      expect(find.textContaining("センシティブ"), findsOneWidget);
    });

    testWidgets("チャンネルをお気に入りに設定していない場合、お気に入りにすることができること", (tester) async {
      final channel = MockMisskeyChannels();
      final misskey = MockMisskey();
      when(misskey.channels).thenReturn(channel);
      when(channel.show(any)).thenAnswer((_) async =>
          TestData.channel1.copyWith(bannerUrl: null, isFavorited: false));

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ChannelDetailRoute(
                account: TestData.account, channelId: TestData.channel1.id),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.text("お気に入りに入れるで"));
      await tester.pumpAndSettle();
      expect(find.text("お気に入り"), findsOneWidget);

      verify(channel.favorite(argThat(
          equals(ChannelsFavoriteRequest(channelId: TestData.channel1.id)))));
    });

    testWidgets("チャンネルをお気に入りに設定している場合、お気に入りを解除できること", (tester) async {
      final channel = MockMisskeyChannels();
      final misskey = MockMisskey();
      when(misskey.channels).thenReturn(channel);
      when(channel.show(any)).thenAnswer((_) async =>
          TestData.channel1.copyWith(bannerUrl: null, isFavorited: true));

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ChannelDetailRoute(
                account: TestData.account, channelId: TestData.channel1.id),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.text("お気に入り"));
      await tester.pumpAndSettle();
      expect(find.text("お気に入りに入れるで"), findsOneWidget);

      verify(channel.unfavorite(argThat(
          equals(ChannelsUnfavoriteRequest(channelId: TestData.channel1.id)))));
    });

    testWidgets("チャンネルをフォローしていない場合、フォローすることができること", (tester) async {
      final channel = MockMisskeyChannels();
      final misskey = MockMisskey();
      when(misskey.channels).thenReturn(channel);
      when(channel.show(any)).thenAnswer((_) async =>
          TestData.channel1.copyWith(bannerUrl: null, isFollowing: false));

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ChannelDetailRoute(
                account: TestData.account, channelId: TestData.channel1.id),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.text("フォローするで"));
      await tester.pumpAndSettle();
      expect(find.text("フォロー中"), findsOneWidget);

      verify(channel.follow(argThat(
          equals(ChannelsFollowRequest(channelId: TestData.channel1.id)))));
    });

    testWidgets("チャンネルをフォローしている場合、フォロー解除をすることができること", (tester) async {
      final channel = MockMisskeyChannels();
      final misskey = MockMisskey();
      when(misskey.channels).thenReturn(channel);
      when(channel.show(any)).thenAnswer((_) async =>
          TestData.channel1.copyWith(bannerUrl: null, isFollowing: true));

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ChannelDetailRoute(
                account: TestData.account, channelId: TestData.channel1.id),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.text("フォロー中"));
      await tester.pumpAndSettle();
      expect(find.text("フォローするで"), findsOneWidget);

      verify(channel.unfollow(argThat(
          equals(ChannelsUnfollowRequest(channelId: TestData.channel1.id)))));
    });
  });

  group("チャンネル内ノート", () {
    testWidgets("チャンネル内のノートが表示されること", (tester) async {
      final channel = MockMisskeyChannels();
      final misskey = MockMisskey();
      when(misskey.channels).thenReturn(channel);
      when(channel.show(any)).thenAnswer((_) async =>
          TestData.channel1.copyWith(bannerUrl: null, isFollowing: false));
      when(channel.timeline(any))
          .thenAnswer((realInvocation) async => [TestData.note1]);

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ChannelDetailRoute(
                account: TestData.account, channelId: TestData.channel1.id),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.text("タイムライン"));
      await tester.pumpAndSettle();

      expect(find.text(TestData.note1.text!), findsOneWidget);
      verify(channel.timeline(argThat(predicate<ChannelsTimelineRequest>(
          (e) => e.channelId == TestData.channel1.id))));

      await tester.pageNation();
      verify(channel.timeline(argThat(predicate<ChannelsTimelineRequest>((e) =>
          e.channelId == TestData.channel1.id &&
          e.untilId == TestData.note1.id))));
    });
  });
}
