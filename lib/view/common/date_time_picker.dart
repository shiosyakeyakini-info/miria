import 'package:flutter/material.dart';

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  String? datePickerHelpText,
  String? timePickerHelpText,
}) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    helpText: datePickerHelpText,
  );
  if (!context.mounted) return null;
  if (date == null) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
    helpText: timePickerHelpText,
  );
  if (time == null) return null;

  return date.copyWith(
    hour: time.hour,
    minute: time.minute,
  );
}
