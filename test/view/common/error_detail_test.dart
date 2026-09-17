import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/view/common/error_detail.dart";

const _html = """
<!doctype html>
<html lang="ja">
 <head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>かつてねむすぎーだったもの</title>
  <style>body { margin: 0; }</style>
  <script>console.log("ねむい");</script>
 </head>
 <body>
  <h1>このサーバーはもうない</h1>
  <p>移転先は&lt;とくにない&gt;。あきらめてほしい。</p>
 </body>
</html>
""";

DioException _dioException({
  required int statusCode,
  required Object data,
  String? contentType,
}) {
  final requestOptions = RequestOptions(path: "/api/notes/timeline");
  return DioException(
    requestOptions: requestOptions,
    response: Response<dynamic>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: data,
      headers: contentType == null
          ? Headers()
          : Headers.fromMap({
              Headers.contentTypeHeader: [contentType],
            }),
    ),
  );
}

/// タイムラインと同じく、スクロールしないColumnの直の子として置く。
Widget _wrap(Object error) {
  return MaterialApp(
    localizationsDelegates: S.localizationsDelegates,
    supportedLocales: S.supportedLocales,
    home: Scaffold(
      body: Column(
        children: [
          ErrorDetail(error: error, stackTrace: StackTrace.current),
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    ),
  );
}

void main() {
  group("ErrorDetail", () {
    testWidgets("api/がHTMLを返してもレイアウトがあふれないこと", (tester) async {
      await tester.pumpWidget(
        _wrap(
          _dioException(
            statusCode: 410,
            data: _html,
            contentType: "text/html; charset=utf-8",
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      // タグはそのまま並べない
      expect(find.textContaining("<!doctype html"), findsNothing);
      expect(find.textContaining("<h1>"), findsNothing);
      expect(find.textContaining("410"), findsOneWidget);
      // サーバーが書いている文言は拾う
      expect(find.textContaining("このサーバーはもうない"), findsOneWidget);
      expect(find.textContaining("かつてねむすぎーだったもの"), findsOneWidget);
      // 実体参照はほどく
      expect(find.textContaining("移転先は<とくにない>。"), findsOneWidget);
      // scriptとstyleの中身は本文ではない
      expect(find.textContaining("margin: 0"), findsNothing);
      expect(find.textContaining("console.log"), findsNothing);
    });

    testWidgets("Content-Typeがなくても本文がHTMLなら中身を並べないこと", (tester) async {
      await tester.pumpWidget(
        _wrap(_dioException(statusCode: 410, data: _html)),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.textContaining("<!doctype html"), findsNothing);
      expect(find.textContaining("このサーバーはもうない"), findsOneWidget);
    });

    testWidgets("HTMLでない長い本文も高さが抑えられること", (tester) async {
      await tester.pumpWidget(
        _wrap(
          _dioException(
            statusCode: 500,
            data: List.filled(400, "エラーの本文").join("\n"),
            contentType: "text/plain",
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(ErrorDetail)).height,
        lessThanOrEqualTo(200),
      );
    });

    testWidgets("JSONのエラーは今までどおり本文が出ること", (tester) async {
      await tester.pumpWidget(
        _wrap(
          _dioException(
            statusCode: 400,
            data: {"error": "NO_SUCH_NOTE"},
            contentType: "application/json",
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.textContaining("NO_SUCH_NOTE"), findsOneWidget);
    });
  });
}
