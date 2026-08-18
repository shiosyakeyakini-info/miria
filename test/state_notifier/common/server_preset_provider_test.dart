import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/common/server_preset_provider.dart";
import "package:mockito/mockito.dart";

import "../../test_util/mock.mocks.dart";

void main() {
  group("ServerPresetProvider", () {
    late MockDio mockDio;
    late ProviderContainer container;

    setUp(() {
      mockDio = MockDio();
      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(mockDio)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test("should parse JSON string response correctly", () async {
      const jsonString = """
      {
        "limitedApiServers": ["example.com"],
        "particularTimelinePresets": []
      }
      """;

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonString,
          statusCode: 200,
          requestOptions: RequestOptions(path: ""),
        ),
      );

      final result = await container.read(serverPresetsProvider.future);

      expect(result.limitedApiServers, ["example.com"]);
      expect(result.particularTimelinePresets, isEmpty);
    });

    test("should parse Map response correctly", () async {
      final jsonMap = {
        "limitedApiServers": ["example.com"],
        "particularTimelinePresets": [],
      };

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonMap,
          statusCode: 200,
          requestOptions: RequestOptions(path: ""),
        ),
      );

      final result = await container.read(serverPresetsProvider.future);

      expect(result.limitedApiServers, ["example.com"]);
      expect(result.particularTimelinePresets, isEmpty);
    });

    test(
      "should handle limitedApiServers as objects with host field",
      () async {
        const jsonString = """
      {
        "limitedApiServers": [{"host": "example.com"}],
        "particularTimelinePresets": []
      }
      """;

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: jsonString,
            statusCode: 200,
            requestOptions: RequestOptions(path: ""),
          ),
        );

        final result = await container.read(serverPresetsProvider.future);

        expect(result.limitedApiServers, ["example.com"]);
        expect(result.particularTimelinePresets, isEmpty);
      },
    );

    test("should handle invalid response gracefully", () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: ""),
        ),
      );

      // 自動破棄で読み込み中に破棄されないよう購読を保持したうえで状態を確認する
      final subscription = container.listen(
        serverPresetsProvider,
        (_, _) {},
        onError: (_, _) {},
      );
      addTearDown(subscription.close);

      await pumpEventQueue();

      final value = container.read(serverPresetsProvider);
      expect(value.hasError, isTrue);
      expect(value.error, isA<Exception>());
    });

    test("should handle invalid JSON string gracefully", () async {
      const invalidJson = "not a valid json";

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: invalidJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ""),
        ),
      );

      // 自動破棄で読み込み中に破棄されないよう購読を保持したうえで状態を確認する
      final subscription = container.listen(
        serverPresetsProvider,
        (_, _) {},
        onError: (_, _) {},
      );
      addTearDown(subscription.close);

      await pumpEventQueue();

      final value = container.read(serverPresetsProvider);
      expect(value.hasError, isTrue);
      expect(value.error, isA<Exception>());
    });
  });
}
