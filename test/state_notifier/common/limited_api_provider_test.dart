import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miria/model/server_preset.dart';
import 'package:miria/state_notifier/common/server_preset_provider.dart';

void main() {
  group('isLimitedApiServerProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          serverPresetsProvider.overrideWithValue(
            const AsyncData(ServerPresets(limitedApiServers: ['example.com'])),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('returns true when host is limited', () async {
      final result = await container.read(
        isLimitedApiServerProvider('example.com').future,
      );
      expect(result, isTrue);
    });

    test('returns false when host is not limited', () async {
      final result = await container.read(
        isLimitedApiServerProvider('other.com').future,
      );
      expect(result, isFalse);
    });
  });
}
