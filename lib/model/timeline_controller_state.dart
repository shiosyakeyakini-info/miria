import 'package:flutter/material.dart';

class TimelineControllerState {
  const TimelineControllerState({
    required this.listKey,
    required this.scrollController,
  });

  final GlobalKey<SliverAnimatedListState> listKey;
  final ScrollController scrollController;
}
