import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/server_preset.dart';
import '../../providers.dart';

part 'server_preset_provider.g.dart';

const _serversUrl =
    'https://raw.githubusercontent.com/shiosyakeyakini-info/miria/refs/heads/develop/servers.json';

@riverpod
Future<ServerPresets> serverPresets(ServerPresetsRef ref) async {
  final dio = ref.read(dioProvider);
  final res = await dio.get<Map<String, dynamic>>(_serversUrl);
  return ServerPresets.fromJson(res.data ?? <String, dynamic>{});
}
