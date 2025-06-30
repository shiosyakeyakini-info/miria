import "dart:convert";

import "package:miria/model/server_preset.dart";
import "package:miria/providers.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "server_preset_provider.g.dart";

const _serversUrl =
    "https://raw.githubusercontent.com/shiosyakeyakini-info/miria/refs/heads/develop/servers.json";

@riverpod
Future<ServerPresets> serverPresets(Ref ref) async {
  try {
    final dio = ref.read(dioProvider);
    final res = await dio.get(_serversUrl);

    // Handle both String and Map responses
    final dynamic responseData = res.data;
    final Map<String, dynamic> jsonData;

    if (responseData is String) {
      try {
        jsonData = jsonDecode(responseData);
      } catch (e) {
        throw FormatException("Failed to parse JSON string: $e");
      }
    } else if (responseData is Map<String, dynamic>) {
      jsonData = responseData;
    } else {
      throw FormatException(
        "Unexpected response type: ${responseData.runtimeType}",
      );
    }

    return ServerPresets.fromJson(jsonData);
  } catch (e) {
    // Re-throw with more context
    throw Exception("Failed to load server presets: $e");
  }
}

@riverpod
Future<bool> isLimitedApiServer(Ref ref, String host) async {
  final presets = await ref.watch(serverPresetsProvider.future);
  return presets.limitedApiServers.contains(host);
}
