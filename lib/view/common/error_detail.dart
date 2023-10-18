import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ErrorDetail extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;

  const ErrorDetail({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    final e = error;
    if (e is DioError) {
      final response = e.response;
      if (e.type == DioErrorType.connectionError) {
        return const Text("通信に失敗しました。");
      } else if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        return const Text("タイムアウトしました。");
      } else if (response != null) {
        return Text("[${response.statusCode}] ${response.data}");
      }
    }
    if (e is WebSocketException) {
      return Text("通信に失敗しました。\n$stackTrace");
    }
    if (e is TimeoutException) {
      return const Text("サーバーが応答してくれませんでした。");
    }
    return Text("不明なエラー：$error\n$stackTrace");
  }
}
