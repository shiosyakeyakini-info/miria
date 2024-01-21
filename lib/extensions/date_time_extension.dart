import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  Duration operator -(DateTime other) => difference(other);
  operator <(DateTime other) => compareTo(other) < 0;
  operator <=(DateTime other) => compareTo(other) <= 0;
  operator >(DateTime other) => compareTo(other) > 0;
  operator >=(DateTime other) => compareTo(other) >= 0;

  String format(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(localeName).format(toUtc().toLocal());
  }

  String formatUntilSeconds(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final formattedDate =
        DateFormat.yMMMd(localeName).add_Hms().format(toUtc().toLocal());
    return "${year < 0 ? "-" : ""}$formattedDate";
  }

  String formatUntilMilliSeconds(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final formattedDate = DateFormat.yMd(localeName)
        .add_Hms()
        .addPattern("S", ".")
        .format(toUtc().toLocal());
    return "${year < 0 ? "-" : ""}$formattedDate";
  }

  String differenceNowDetail(BuildContext context) {
    final differ = this - DateTime.now();
    if (differ <= Duration.zero) {
      return differenceNow(context);
    } else if (differ >= const Duration(days: 365)) {
      return S.of(context).inYears(differ.inDays ~/ 365);
    } else if (differ >= const Duration(days: 1)) {
      return S.of(context).inDays(differ.inDays);
    } else if (differ >= const Duration(hours: 1)) {
      return S.of(context).inHours(differ.inHours);
    } else if (differ >= const Duration(minutes: 1)) {
      return S.of(context).inMinutes(differ.inMinutes);
    } else if (differ >= const Duration(seconds: 1)) {
      return S.of(context).inSeconds(differ.inSeconds);
    } else {
      return S.of(context).justNow;
    }
  }

  String differenceNow(BuildContext context) {
    final differ = DateTime.now() - this;
    if (DateTime.now() < this) {
      return S.of(context).future;
    } else if (differ < const Duration(seconds: 1)) {
      return S.of(context).justNow;
    } else if (differ < const Duration(minutes: 1)) {
      return S.of(context).secondsAgo(differ.inSeconds);
    } else if (differ < const Duration(hours: 1)) {
      return S.of(context).minutesAgo(differ.inMinutes);
    } else if (differ < const Duration(days: 1)) {
      return S.of(context).hoursAgo(differ.inHours);
    } else if (differ <= const Duration(days: 365)) {
      return S.of(context).daysAgo(differ.inDays);
    } else {
      return S.of(context).yearsAgo(differ.inDays ~/ 365);
    }
  }
}

extension DurationExtenion on Duration {
  String format(BuildContext context) {
    if (this < const Duration(minutes: 1)) {
      return S.of(context).nSeconds(inSeconds);
    } else if (this < const Duration(hours: 1)) {
      return S.of(context).nMinutes(inMinutes);
    } else if (this < const Duration(days: 1)) {
      return S.of(context).nHours(inHours);
    } else {
      return S.of(context).nDays(inDays);
    }
  }
}
