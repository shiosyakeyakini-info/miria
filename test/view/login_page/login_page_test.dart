import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';

void main() {
  group("MiAuth認証", () {
    testWidgets("ActivityPubに対応していないホストを入力すると、エラーダイアログが表示されること",
        (tester) async {
      final dio = MockDio();
      when(dio.getUri(any)).thenAnswer((_) async => throw TestData.response404);

      await tester.pumpWidget(ProviderScope(
          overrides: [dioProvider.overrideWithValue(dio)],
          child: const DefaultRootWidget(
            initialRoute: LoginRoute(),
          )));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "example.com");
      await tester.tap(find.text("認証をする"));
      await tester.pumpAndSettle();

      verify(dio.getUri(argThat(equals(Uri(
          scheme: "https",
          host: "example.com",
          pathSegments: [".well-known", "nodeinfo"]))))).called(1);
      expect(find.textContaining("Misskeyサーバーとして認識できませんでした。"), findsOneWidget);

      await tester.tap(find.text("ほい"));
      await tester.pumpAndSettle();

      expect(find.byType(TextField).hitTestable(), findsOneWidget);
    });
  });
}
