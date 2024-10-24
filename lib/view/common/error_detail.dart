import "dart:async";
import "dart:io";

import "package:dio/dio.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ErrorDetail extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;

  const ErrorDetail({
    required this.error,
    required this.stackTrace,
    super.key,
  });

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
