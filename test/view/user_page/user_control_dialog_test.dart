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
  group("ユーザーメニュー", () {
    // #677: userInfoProviderをwatchしていない画面(タイムラインのノートメニューなど)から
    // ユーザーメニューを開くと、UserInfoNotifierが即座にautoDisposeされてしまい
    // ミュート・ブロックの操作が一切効かなくなっていた。
    // ユーザー情報画面を経由せずに直接ユーザーメニューを開いて操作が届くことを確認する。
    testWidgets("ユーザー情報画面を経由せずに開いた場合でもリノートミュートができること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockUser = MockMisskeyUsers();
      final mockRenoteMute = MockMisskeyRenoteMute();
      when(mockMisskey.users).thenReturn(mockUser);
      when(mockMisskey.renoteMute).thenReturn(mockRenoteMute);
      when(
        mockUser.show(any),
      ).thenAnswer((_) async => TestData.usersShowResponse1);
      when(mockRenoteMute.create(any)).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
          ],
          child: DefaultRootWidget(
            initialRoute: UserControlRoute(
              account: TestData.account,
              response: TestData.usersShowResponse1,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final target = find.text("リノートをミュートする");
      await tester.scrollUntilVisible(
        target,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(target);
      // 完了後はローディング表示のまま(実機ではmaybePopで閉じる)なのでpumpAndSettleは使えない
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      verify(
        mockRenoteMute.create(
          RenoteMuteCreateRequest(userId: TestData.usersShowResponse1.id),
        ),
      ).called(1);
    });
  });
}
