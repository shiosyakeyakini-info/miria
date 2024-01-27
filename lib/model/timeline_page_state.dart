import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_page_state.freezed.dart';

@freezed
class TimelinePageState with _$TimelinePageState {
  const TimelinePageState._();

  const factory TimelinePageState({
    required PageController pageController,
    required int index,
    @Default(false) bool isErrorExpanded,
  }) = _TimelinePageState;
}
