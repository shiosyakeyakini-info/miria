import 'package:flutter/cupertino.dart';

class TimelineScrollController extends ScrollController {
  double _previousPosition = 0.0;
  double _previousMaxExtent = 0.0;

  TimelineScrollController() {
    addListener(() {
      final currentPosition = position.pixels;
      _previousPosition = currentPosition;
      _previousMaxExtent = position.maxScrollExtent;
    });
  }

  void forceScrollToTop() {
    if (positions.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        forceScrollToTop();
      });
    }
    jumpTo(position.maxScrollExtent);
    scrollToTop();
  }

  void scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (positions.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          scrollToTop();
        });
        return;
      }
      if (_previousPosition == _previousMaxExtent &&
          position.maxScrollExtent != position.pixels) {
        jumpTo(position.maxScrollExtent);
        _previousPosition = position.maxScrollExtent;
        _previousMaxExtent = position.maxScrollExtent;
      }

      if (_previousPosition == _previousMaxExtent) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          scrollToTop();
        });
      }
    });
  }
}
