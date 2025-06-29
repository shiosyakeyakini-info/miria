import 'package:flutter_test/flutter_test.dart';
import 'package:miria/util/ap_query.dart';

void main() {
  group('isApQuery', () {
    test('returns true for url', () {
      expect(isApQuery('https://example.com/note/1'), isTrue);
    });

    test('returns true for handle', () {
      expect(isApQuery('@user@example.com'), isTrue);
    });

    test('returns false for normal text', () {
      expect(isApQuery('hello'), isFalse);
    });
  });

  group('apQueryToUri', () {
    test('returns same url', () {
      final uri = apQueryToUri('https://server/notes/1');
      expect(uri.toString(), 'https://server/notes/1');
    });

    test('converts handle', () {
      final uri = apQueryToUri('@name@example.com');
      expect(uri.toString(), 'https://example.com/@name');
    });
  });
}
