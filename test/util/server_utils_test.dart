import "package:flutter_test/flutter_test.dart";
import "package:miria/util/server_utils.dart";

void main() {
  group("serverToUri", () {
    test("should preserve http scheme for localhost", () {
      final uri = serverToUri("http://localhost:3000");
      expect(uri.scheme, equals("http"));
      expect(uri.host, equals("localhost"));
      expect(uri.port, equals(3000));
      expect(uri.toString(), equals("http://localhost:3000"));
    });

    test("should preserve https scheme", () {
      final uri = serverToUri("https://example.com");
      expect(uri.scheme, equals("https"));
      expect(uri.host, equals("example.com"));
      expect(uri.toString(), equals("https://example.com"));
    });

    test("should default to https when no scheme provided", () {
      final uri = serverToUri("example.com");
      expect(uri.scheme, equals("https"));
      expect(uri.host, equals("example.com"));
      expect(uri.toString(), equals("https://example.com"));
    });

    test("should handle ports correctly", () {
      final uri = serverToUri("http://localhost:8080");
      expect(uri.scheme, equals("http"));
      expect(uri.host, equals("localhost"));
      expect(uri.port, equals(8080));
    });
  });

  group("normalizeServer", () {
    test("should preserve http scheme", () {
      final normalized = normalizeServer("http://localhost:3000");
      expect(normalized, equals("http://localhost:3000"));
    });

    test("should preserve https scheme", () {
      final normalized = normalizeServer("https://example.com");
      expect(normalized, equals("https://example.com"));
    });

    test("should normalize without scheme", () {
      final normalized = normalizeServer("example.com");
      expect(normalized, equals("example.com"));
    });

    test("should remove trailing slashes", () {
      final normalized = normalizeServer("http://localhost:3000///");
      expect(normalized, equals("http://localhost:3000"));
    });
  });
}
