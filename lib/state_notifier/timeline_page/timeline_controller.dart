import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/timeline_controller_state.dart';
import 'package:miria/providers.dart';

class TimelineController
    extends AutoDisposeFamilyNotifier<TimelineControllerState, TabSetting> {
  /// スクロール位置が最上部かどうか
  bool _atTopEdge = true;

  @override
  TimelineControllerState build(TabSetting arg) {
    final listKey = GlobalKey<SliverAnimatedListState>();
    final scrollController = ScrollController();
    final timelineRepository =
        ref.watch(timelineRepositoryProvider(arg).notifier);

    Future(() {
      timelineRepository.startTimeline();
    });

    // 定期的にスクロールすることで追従する
    final timer = Timer.periodic(
      const Duration(milliseconds: 20),
      (_) => _scrollToTop(),
    );

    scrollController.addListener(
      () {
        _atTopEdge = (scrollController.position.extentBefore == 0);
      },
    );

    ref.listen(
      timelineRepositoryProvider(arg)
          .select((timeline) => timeline.newerNotes.length),
      (prev, next) {
        final diff = next - (prev ?? 0);
        if (diff >= 0) {
          _animatedList!.insertAllItems(prev ?? 0, diff);
        } else {
          // 要素が減っていたら一度クリアして追加しなおす
          _animatedList!.removeAllItems(
            (_, __) => const SizedBox.shrink(),
            duration: Duration.zero,
          );
          _animatedList!.insertAllItems(0, next, duration: Duration.zero);
        }
      },
    );

    ref.onDispose(() {
      timer.cancel();
      scrollController.dispose();
      timelineRepository.disconnect();
    });

    return TimelineControllerState(
      listKey: listKey,
      scrollController: scrollController,
    );
  }

  SliverAnimatedListState? get _animatedList => state.listKey.currentState;

  /// 前回のスクロール時に最上部にいたら最上部までジャンプする
  void _scrollToTop() {
    final scrollController = state.scrollController;
    if (_atTopEdge && scrollController.positions.isNotEmpty) {
      final position = scrollController.position;
      if (position.extentBefore != 0) {
        scrollController.jumpTo(position.minScrollExtent);
      }
    }
  }

  void forceScrollToTop() {
    final scrollController = state.scrollController;
    if (scrollController.positions.isNotEmpty) {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
  }
}
