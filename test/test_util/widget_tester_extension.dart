import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTestExtension on WidgetTester {
  TextEditingController textEditingController(Finder finder) {
    final widget = finder.evaluate().first.widget;
    if (widget is TextField) {
      return widget.controller!;
    } else {
      throw Exception("$finder has not text editing controller.");
    }
  }

  Future<void> pageNation() async {
    await tap(find.descendant(
        of: find.descendant(
            of: find.byType(Center),
            matching: find.byType(IconButton).hitTestable()),
        matching: find.byIcon(Icons.keyboard_arrow_down)));
    await pumpAndSettle();
  }
}
