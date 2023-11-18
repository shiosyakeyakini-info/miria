import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  Duration operator -(DateTime other) => difference(other);
  operator <(DateTime other) => compareTo(other) < 0;
  operator <=(DateTime other) => compareTo(other) <= 0;
  operator >(DateTime other) => compareTo(other) > 0;
  operator >=(DateTime other) => compareTo(other) >= 0;

  String get format => DateFormat("yyyy 年 M 月 d 日").format(toUtc().toLocal());

  String get formatUntilSeconds =>
      "${year < 0 ? "-" : ""}${DateFormat("yyyy 年 M 月 d 日 HH:mm:ss").format(toUtc().toLocal())}";

  String get formatUntilMilliSeconds =>
      "${year < 0 ? "-" : ""}${DateFormat("yyyy/MM/dd HH:mm:ss", "ja_jp").format(toUtc().toLocal())}.${millisecond.toString().padLeft(3, '0')}";

  String get differenceNowDetail {
    final differ = this - DateTime.now();
    if (differ <= const Duration(seconds: 0)) {
      return differenceNow;
    } else if (differ >= const Duration(days: 365)) {
      return "${differ.inDays ~/ 365}年後";
    } else if (differ >= const Duration(days: 1)) {
      return "${differ.inDays}日後";
    } else if (differ >= const Duration(hours: 1)) {
      return "${differ.inHours}時間後";
    } else if (differ >= const Duration(minutes: 1)) {
      return "${differ.inMinutes}分後";
    } else if (differ >= const Duration(seconds: 1)) {
      return "${differ.inSeconds}秒後";
    } else {
      return "たったいま";
    }
  }

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
    } else if (differ <= const Duration(days: 365)) {
      return "${differ.inDays}日前";
    } else {
      return "${differ.inDays ~/ 365}年前";
    }
  }
}

extension DurationExtenion on Duration {
  String get format {
    if (this < const Duration(minutes: 1)) {
      return "$inSeconds秒";
    } else if (this < const Duration(hours: 1)) {
      return "$inMinutes分";
    } else if (this < const Duration(days: 1)) {
      return "$inHours時間";
    } else {
      return "$inDays日";
    }
  }
}
