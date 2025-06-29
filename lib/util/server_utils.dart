/// Utilities for handling server hostnames and URLs.
///
/// These helpers normalize server strings, ensuring any internationalized
/// domain names are converted to punycode and that only valid host and port
/// information is retained.
import "package:punycode/punycode.dart";

// Converts a hostname containing non-ASCII characters into its punycode
// representation.

String toAscii(String host) {
  return host.splitMapJoin(
    ".",
    onNonMatch: (n) {
      if (RegExp(r"[^\x00-\x7F]").hasMatch(n)) {
        try {
          return "xn--${punycodeEncode(n)}";
        } catch (_) {}
      }
      return n;
    },
  );
}

// Validates and normalizes the user's server input to a host with an optional scheme and port.
String normalizeServer(String input) {
  final trimmed = input.trim().replaceAll(RegExp(r"/+$"), "");
  if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
    final uri = Uri.parse(trimmed);
    if (uri.path.isNotEmpty ||
        uri.query.isNotEmpty ||
        uri.fragment.isNotEmpty) {
      throw const FormatException("invalid server");
    }
    final asciiHost = toAscii(uri.host);
    final portPart = uri.hasPort ? ":${uri.port}" : "";
    return "${uri.scheme}://$asciiHost$portPart";
  }
  return toAscii(trimmed);
}

// Converts a normalized server string to a [Uri] object, defaulting to https if no scheme is present.
Uri serverToUri(String server) {
  final normalized = normalizeServer(server);
  final uri =
      normalized.startsWith("http://") || normalized.startsWith("https://")
      ? Uri.parse(normalized)
      : Uri.parse("https://$normalized");
  if (uri.host.isEmpty) {
    throw const FormatException("invalid server");
  }
  return uri;
}
