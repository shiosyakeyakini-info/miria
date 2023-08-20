import 'package:intl/intl.dart';

Pattern get availableServerVersion => RegExp(r"^(1[3-9]\.|20[2-9][0-9])");
RegExp get htmlTagRemove => RegExp(r"""<("[^"]*"|'[^']*'|[^'">])*>""");

final intFormatter = NumberFormat("#,###");

extension IntFormat on int? {
  String format({String ifNull = ""}) =>
      this == null ? ifNull : intFormatter.format(this);
}
