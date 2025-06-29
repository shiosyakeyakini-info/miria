
/// Returns true if the text looks like a query for ActivityPub object.
/// It matches strings that start with 'http://' or 'https://',
/// or strings that start with '@' and contain another '@'.
bool isApQuery(String text) {
  final trimmed = text.trim();
  return RegExp(r'^https?://').hasMatch(trimmed) ||
      (trimmed.startsWith('@') && '@'.allMatches(trimmed).length >= 2);
}

/// Converts an AP query string to [Uri].
/// If the input is a URL, it is returned directly.
/// If the input is a handle like '@user@example.com',
/// it will be converted to 'https://example.com/@user'.
Uri apQueryToUri(String text) {
  final trimmed = text.trim();
  if (RegExp(r'^https?://').hasMatch(trimmed)) {
    return Uri.parse(trimmed);
  }
  if (trimmed.startsWith('@') && '@'.allMatches(trimmed).length >= 2) {
    final withoutAt = trimmed.substring(1);
    final firstAt = withoutAt.indexOf('@');
    final user = withoutAt.substring(0, firstAt);
    final host = withoutAt.substring(firstAt + 1);
    return Uri.parse('https://$host/@$user');
  }
  throw FormatException('Invalid AP query', text);
}
