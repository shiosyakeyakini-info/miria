import "dart:async";
import "dart:io";

import "package:auto_route/auto_route.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";

/// 認証そのものが通らなかったことを示す Misskey のエラーコード。
///
/// トークンが失効した・取り消された (`AUTHENTICATION_FAILED`) か、
/// そもそも付いていない (`CREDENTIAL_REQUIRED`) か。どちらもユーザーには
/// 「ログインし直す」以外に手がないので、同じ導線に寄せる。
const _authenticationErrorCodes = {
  "AUTHENTICATION_FAILED",
  "CREDENTIAL_REQUIRED",
};

/// ストリーミングの接続が認証で弾かれたかどうか。
///
/// Misskey は WebSocket のハンドシェイクも 401 で返すが、Dart の WebSocket は
/// [WebSocketException] しか投げず、Misskey のエラーコードは取り出せない。
/// さらに `Future.wait` に包まれて [ParallelWaitError] で届くこともあるため、
/// 文字列で見るしかない。
///
/// ここで拾わないと、接続先の URL がそのままエラーとして表示される。
/// miria はトークンをクエリに載せて接続するので、画面にトークンが出てしまう。
bool _isWebSocketAuthFailure(Object? error) {
  final message = error.toString();
  return message.contains("not upgraded to websocket") &&
      (message.contains("401") || message.contains("403"));
}

class ErrorDetail extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;

  const ErrorDetail({required this.error, required this.stackTrace, super.key});

  @override
  Widget build(BuildContext context) {
    final e = error;

    if (_isWebSocketAuthFailure(e)) {
      return _ReLoginSuggestion(message: S.of(context).thrownTokenExpired);
    }

    // misskey_dart は API のエラー応答を MisskeyException に変換するので、
    // 認証切れは DioException ではなくこちらに来る。
    if (e is MisskeyException) {
      if (_authenticationErrorCodes.contains(e.code)) {
        return _ReLoginSuggestion(message: S.of(context).thrownTokenExpired);
      }
      if (e.code == "PERMISSION_DENIED") {
        return _ReLoginSuggestion(
          message: S.of(context).thrownPermissionDenied,
        );
      }
      // サーバーの文言のほうが具体的なので、そのまま見せる。
      return Text(e.message);
    }

    if (e is DioException) {
      final response = e.response;
      if (e.type == DioExceptionType.connectionError) {
        return Text(S.of(context).thrownConnectionError);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Text(S.of(context).thrownConnectionTimeout);
      } else if (response?.statusCode == 401 || response?.statusCode == 403) {
        // JSON で返ってこず MisskeyException に変換できなかった場合の受け皿。
        return _ReLoginSuggestion(message: S.of(context).thrownTokenExpired);
      } else if (response != null) {
        return Text("[${response.statusCode}] ${response.data}");
      }
    }
    if (e is WebSocketException) {
      return Text("${S.of(context).thrownWebSocketException}\n$stackTrace");
    }
    if (e is TimeoutException) {
      return Text(S.of(context).thrownTimeoutException);
    }
    return Text("${S.of(context).thrownUnknownError}$error\n$stackTrace");
  }
}

/// [ErrorDetail] を、画面の一定割合を超えない高さに収めて表示する。
///
/// タイムラインのエラーは高さの制約がない [Column] の子として置かれていたため、
/// Misskey.io の障害時のような長文が返ると、その下にあるノート欄と（下配置に
/// している場合は）タブバーごと画面外へ押し出してしまい、設定を開くことも
/// できなくなっていた (#523)。溢れる分はこの中でスクロールさせる。
class BoundedErrorDetail extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;

  /// 画面の高さに対する上限の割合。
  final double heightFactor;

  const BoundedErrorDetail({
    required this.error,
    required this.stackTrace,
    super.key,
    this.heightFactor = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * heightFactor,
      ),
      child: SingleChildScrollView(
        child: ErrorDetail(error: error, stackTrace: stackTrace),
      ),
    );
  }
}

/// 認証をやり直す以外に手がないエラーのときに出す案内。
class _ReLoginSuggestion extends StatelessWidget {
  final String message;

  const _ReLoginSuggestion({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () async => context.pushRoute(const LoginRoute()),
            child: Text(S.of(context).reLogin),
          ),
        ),
      ],
    );
  }
}
