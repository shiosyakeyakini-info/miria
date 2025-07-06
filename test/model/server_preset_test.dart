import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:miria/model/server_preset.dart";

void main() {
  group("ServerPresets", () {
    test("should parse valid JSON from servers.json file", () async {
      // servers.jsonファイルを読み込み
      final file = File("servers.json");
      expect(file.existsSync(), true, reason: "servers.json file should exist");

      final jsonString = await file.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // ServerPresetsをパース
      expect(() => ServerPresets.fromJson(jsonData), returnsNormally);
      final serverPresets = ServerPresets.fromJson(jsonData);

      // 基本的な構造をテスト
      expect(serverPresets.limitedApiServers, isA<List<String>>());
      expect(
        serverPresets.particularTimelinePresets,
        isA<List<TimelinePreset>>(),
      );
    });

    test("should handle limitedApiServers as objects with host field", () {
      final json = {
        "limitedApiServers": [
          {"host": "example1.com"},
          {"host": "example2.com"},
        ],
        "particularTimelinePresets": [],
      };

      final serverPresets = ServerPresets.fromJson(json);

      expect(serverPresets.limitedApiServers, ["example1.com", "example2.com"]);
    });

    test("should handle limitedApiServers as strings", () {
      final json = {
        "limitedApiServers": ["example1.com", "example2.com"],
        "particularTimelinePresets": [],
      };

      final serverPresets = ServerPresets.fromJson(json);

      expect(serverPresets.limitedApiServers, ["example1.com", "example2.com"]);
    });

    test("should handle empty limitedApiServers", () {
      final json = {"limitedApiServers": [], "particularTimelinePresets": []};

      final serverPresets = ServerPresets.fromJson(json);

      expect(serverPresets.limitedApiServers, isEmpty);
    });
  });

  group("TimelinePreset", () {
    test("should parse valid TimelinePreset", () {
      final json = {
        "host": "example.com",
        "name": "Test Timeline",
        "endpoint": "api/notes/timeline",
        "websocketChannelName": "timeline",
        "parameters": '{"test": true}',
      };

      final preset = TimelinePreset.fromJson(json);

      expect(preset.host, "example.com");
      expect(preset.name, "Test Timeline");
      expect(preset.endpoint, "api/notes/timeline");
      expect(preset.websocketChannelName, "timeline");
      expect(preset.parameters, {"test": true});
    });

    test("should handle empty parameters string", () {
      final json = {
        "host": "example.com",
        "name": "Test Timeline",
        "endpoint": "api/notes/timeline",
        "websocketChannelName": "timeline",
        "parameters": "",
      };

      final preset = TimelinePreset.fromJson(json);

      expect(preset.parameters, isEmpty);
    });

    test("should handle parameters as Map", () {
      final json = {
        "host": "example.com",
        "name": "Test Timeline",
        "endpoint": "api/notes/timeline",
        "websocketChannelName": "timeline",
        "parameters": {"test": true},
      };

      final preset = TimelinePreset.fromJson(json);

      expect(preset.parameters, {"test": true});
    });

    test("should handle invalid parameters JSON string", () {
      final json = {
        "host": "example.com",
        "name": "Test Timeline",
        "endpoint": "api/notes/timeline",
        "websocketChannelName": "timeline",
        "parameters": "invalid json",
      };

      final preset = TimelinePreset.fromJson(json);

      expect(preset.parameters, isEmpty);
    });

    test("should validate servers.json specific data", () async {
      final file = File("servers.json");
      final jsonString = await file.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final serverPresets = ServerPresets.fromJson(jsonData);

      // 特定のプリセットが正しくパースされることを確認
      final taiChanPresets = serverPresets.particularTimelinePresets
          .where((preset) => preset.host == "mi.taichan.site")
          .toList();

      expect(taiChanPresets.length, 2);

      // ホームタイムライン（ローカルのみ）の確認
      final homePreset = taiChanPresets.firstWhere(
        (preset) => preset.name == "ホームタイムライン（ローカルのみ）",
      );
      expect(homePreset.endpoint, "api/notes/timeline");
      expect(homePreset.websocketChannelName, "localTimeline");
      expect(homePreset.parameters, {"onlyLocal": true});

      // ソーシャルタイムライン（ローカルのみ）の確認
      final socialPreset = taiChanPresets.firstWhere(
        (preset) => preset.name == "ソーシャルタイムライン（ローカルのみ）",
      );
      expect(socialPreset.endpoint, "api/notes/hybrid-timeline");
      expect(socialPreset.websocketChannelName, "hybridTimeline");
      expect(socialPreset.parameters, {"onlyLocal": true});
    });
  });
}
