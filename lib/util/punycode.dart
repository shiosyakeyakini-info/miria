import 'package:punycode/punycode.dart';

String toAscii(String host) {
  return host.splitMapJoin(
    '.',
    onNonMatch: (n) {
      if (RegExp(r'[^\x00-\x7F]').hasMatch(n)) {
        try {
          return 'xn--${punycodeEncode(n)}';
        } catch (_) {}
      }
      return n;
    },
  );
}
