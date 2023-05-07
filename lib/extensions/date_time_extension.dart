import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  Duration operator -(DateTime other) => difference(other);
  operator <(DateTime other) => compareTo(other) < 0;
  operator <=(DateTime other) => compareTo(other) <= 0;
  operator >(DateTime other) => compareTo(other) > 0;
  operator >=(DateTime other) => compareTo(other) >= 0;

  String get format => DateFormat("yyyy 年 M 月 d 日").format(this);

  String get differenceNow {
    final differ = DateTime.now() - this;
    if (DateTime.now() < this) {
      return "未来";
    } else if (differ < const Duration(seconds: 1)) {
      return "たったいま";
    } else if (differ < const Duration(minutes: 1)) {
      return "${differ.inSeconds}秒前";
    } else if (differ < const Duration(hours: 1)) {
      return "${differ.inMinutes}分前";
    } else if (differ < const Duration(days: 1)) {
      return "${differ.inHours}時間前";
    } else {
      return "${differ.inDays}日前";
    }
  }
}
