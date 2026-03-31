import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:misskey_dart/misskey_dart.dart";

/// ローカルMisskeyサーバーのセットアップと管理
class MisskeyTestSetup {
  static const host = "127.0.0.1:3000";
  static const baseUrl = "http://$host";
  static const apiUrl = "$baseUrl/api/";
  static const streamingUrl = "ws://$host/streaming/";

  final _dio = Dio(BaseOptions(responseType: ResponseType.json));

  late String adminToken;
  late String userToken;
  late String adminId;
  late String userId;
  late Misskey adminClient;
  late Misskey userClient;

  /// POST /api/<endpoint> をDioで直接呼び出す
  Future<Map<String, dynamic>> apiCall(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final data = <String, dynamic>{...?body};
    if (token != null) data["i"] = token;
    final response = await _dio.post(
      "$baseUrl/api/$endpoint",
      data: jsonEncode(data),
      options: Options(
        headers: {"Content-Type": "application/json"},
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: "$endpoint returned ${response.statusCode}: ${response.data}",
      );
    }
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {};
  }

  /// Misskey APIクライアントを作成
  Misskey createClient(String token) {
    return Misskey(
      host: host,
      token: token,
      apiUrl: apiUrl,
      streamingUrl: streamingUrl,
    );
  }

  /// reset-db (NODE_ENV=test で起動した場合のみ)
  /// 使わない場合はシェルスクリプトでDB再作成する
  Future<void> resetDb() async {
    try {
      await _dio.post(
        "$baseUrl/api/reset-db",
        data: "{}",
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      // reset-db後はサーバーが再起動するので待つ
      await _waitForServer();
    } catch (e) {
      // reset-dbが使えない場合は無視（シェルスクリプトでDB再作成済みの想定）
    }
  }

  /// サーバーが応答するまで待機
  Future<void> _waitForServer({int maxRetries = 30}) async {
    for (var i = 0; i < maxRetries; i++) {
      try {
        await _dio.post(
          "$baseUrl/api/ping",
          data: "{}",
          options: Options(headers: {"Content-Type": "application/json"}),
        );
        return;
      } catch (_) {
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    }
    throw Exception("Misskey server did not respond after $maxRetries retries");
  }

  /// セットアップ: setup_misskey.sh が生成したトークンファイルを読み込む。
  /// ファイルがなければAPIで直接セットアップを試みる。
  Future<void> setup() async {
    await _waitForServer();

    // トークンファイルから読み込みを試みる
    if (await _loadTokensFromFiles()) {
      adminClient = createClient(adminToken);
      userClient = createClient(userToken);

      // federation有効化（冪等）
      await apiCall(
        "admin/update-meta",
        token: adminToken,
        body: {"federation": "all"},
      );
      return;
    }

    // ファイルがなければ直接APIでセットアップ
    final adminResult = await apiCall(
      "admin/accounts/create",
      body: {"username": "admin", "password": "adminpassword"},
    );
    adminToken = adminResult["token"] as String;
    adminId = adminResult["id"] as String;
    adminClient = createClient(adminToken);

    await apiCall(
      "admin/update-meta",
      token: adminToken,
      body: {"federation": "all"},
    );

    final userResult = await apiCall(
      "admin/accounts/create",
      token: adminToken,
      body: {"username": "testuser", "password": "testpassword"},
    );
    userToken = userResult["token"] as String;
    userId = userResult["id"] as String;
    userClient = createClient(userToken);
  }

  /// /tmp のトークンファイルからトークンを読み込む
  Future<bool> _loadTokensFromFiles() async {
    try {
      final adminFile = File("/tmp/misskey_admin_token");
      final userFile = File("/tmp/misskey_user_token");
      if (!await adminFile.exists() || !await userFile.exists()) return false;

      adminToken = (await adminFile.readAsString()).trim();
      userToken = (await userFile.readAsString()).trim();
      if (adminToken.isEmpty || userToken.isEmpty) return false;

      // トークンが有効か確認
      final adminMe = await apiCall("i", token: adminToken);
      adminId = adminMe["id"] as String;
      final userMe = await apiCall("i", token: userToken);
      userId = userMe["id"] as String;

      return true;
    } catch (e) {
      // トークンが無効（DB再作成後の古いトークン等）
      return false;
    }
  }
}
