import "dart:async";
import "dart:io";

import "package:auto_route/auto_route.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/router/app_router.dart";

/// エラーの本文を表示する高さの上限。
///
/// api/ がHTMLを返してくると本文が数十行になり、これを高さの制約なしに並べると
/// タイムラインのColumnがあふれて、投稿欄やタブが画面外に押し出されてしまう。
const _maxErrorBodyHeight = 200.0;

/// HTMLでない本文をそのまま出すときの文字数の上限。
const _maxErrorBodyLength = 1000;

class ErrorDetail extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;

  const ErrorDetail({required this.error, required this.stackTrace, super.key});

  @override
  Widget build(BuildContext context) {
    final e = error;
    if (e is DioException) {
      final response = e.response;
      if (e.type == DioExceptionType.connectionError) {
        return Text(S.of(context).thrownConnectionError);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Text(S.of(context).thrownConnectionTimeout);
      } else if (e.response?.statusCode == 403) {
        return Column(
          children: [
            Text("【エラー】APIの権限が不足しているか、アクセストークンが削除されています。"),
            ElevatedButton(
              onPressed: () async => context.pushRoute(const LoginRoute()),
              child: Text("再ログイン"),
            ),
          ],
        );
      } else if (response != null) {
        if (_isHtmlResponse(response)) {
          // 本文はMisskeyのAPIの応答ではないので、出しても読む値打ちがない
          return Text(
            "[${response.statusCode}] ${S.of(context).thrownHtmlResponse}",
          );
        }
        return _BoundedErrorBody(
          text: "[${response.statusCode}] ${_truncate(response.data)}",
        );
      }
    }
    if (e is WebSocketException) {
      return _BoundedErrorBody(
        text: "${S.of(context).thrownWebSocketException}\n$stackTrace",
      );
    }
    if (e is TimeoutException) {
      return Text(S.of(context).thrownTimeoutException);
    }
    return _BoundedErrorBody(
      text: "${S.of(context).thrownUnknownError}$error\n$stackTrace",
    );
  }
}

/// レスポンスがAPIの応答ではなくHTMLの文書かどうか。
///
/// リバースプロキシの設定ミスや、サーバーを畳んだあとの案内ページが
/// api/ に返ってくることがある。
bool _isHtmlResponse(Response<dynamic> response) {
  final contentType = response.headers.value(Headers.contentTypeHeader);
  if (contentType != null && contentType.toLowerCase().contains("text/html")) {
    return true;
  }
  final data = response.data;
  if (data is! String) return false;
  final head = data.trimLeft().toLowerCase();
  return head.startsWith("<!doctype html") || head.startsWith("<html");
}

String _truncate(Object? data) {
  final text = data?.toString() ?? "";
  if (text.length <= _maxErrorBodyLength) return text;
  return "${text.substring(0, _maxErrorBodyLength)}…";
}

/// 高さを抑えたうえで、中身は読めるようにスクロールさせる。
class _BoundedErrorBody extends StatelessWidget {
  final String text;

  const _BoundedErrorBody({required this.text});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: _maxErrorBodyHeight),
      child: SingleChildScrollView(child: Text(text)),
    );
  }
}
