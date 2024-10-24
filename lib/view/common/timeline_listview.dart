import "dart:math" as math;

import "package:flutter/gestures.dart" show DragStartBehavior;
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";

/// Infinite ListView
///
/// ListView that builds its children with to an infinite extent.
///
class TimelineListView extends StatefulWidget {
  /// See [ListView.builder]
  const TimelineListView.builder({
    required this.itemBuilder,
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.physics,
    this.padding,
    this.itemExtent,
    this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.anchor = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : separatorBuilder = null;

  /// See [ListView.separated]
  const TimelineListView.separated({
    required this.itemBuilder,
    required this.separatorBuilder,
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.physics,
    this.padding,
    this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.anchor = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : itemExtent = null;

  /// See: [ScrollView.scrollDirection]
  final Axis scrollDirection;

  /// See: [ScrollView.reverse]
  final bool reverse;

  /// See: [ScrollView.controller]
  final TimelineScrollController? controller;

  /// See: [ScrollView.physics]
  final ScrollPhysics? physics;

  /// See: [BoxScrollView.padding]
  final EdgeInsets? padding;

  /// See: [ListView.builder]
  final NullableIndexedWidgetBuilder itemBuilder;

  /// See: [ListView.separated]
  final IndexedWidgetBuilder? separatorBuilder;

  /// See: [SliverChildBuilderDelegate.childCount]
  final int? itemCount;

  /// See: [ListView.itemExtent]
  final double? itemExtent;

  /// See: [ScrollView.cacheExtent]
  final double? cacheExtent;

  /// See: [ScrollView.anchor]
  final double anchor;

  /// See: [SliverChildBuilderDelegate.addAutomaticKeepAlives]
  final bool addAutomaticKeepAlives;

  /// See: [SliverChildBuilderDelegate.addRepaintBoundaries]
  final bool addRepaintBoundaries;

  /// See: [SliverChildBuilderDelegate.addSemanticIndexes]
  final bool addSemanticIndexes;

  /// See: [ScrollView.dragStartBehavior]
  final DragStartBehavior dragStartBehavior;

  /// See: [ScrollView.keyboardDismissBehavior]
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// See: [ScrollView.restorationId]
  final String? restorationId;

  /// See: [ScrollView.clipBehavior]
  final Clip clipBehavior;

  @override
  State<TimelineListView> createState() => _TimelineListViewState();
}

class _TimelineListViewState extends State<TimelineListView> {
  TimelineScrollController? _controller;

  TimelineScrollController get _effectiveController =>
      widget.controller ?? _controller!;

  _InfiniteScrollPosition? _negativeOffset;

  void timingCallback(_) {
    final negativeOffset = _negativeOffset;
    if (negativeOffset == null) return;
    final extent = negativeOffset.maxScrollExtent;
    negativeOffset._minMaxExtent = -extent;
    _effectiveController._offset = -extent;
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TimelineScrollController();
    }
    WidgetsBinding.instance.addTimingsCallback(timingCallback);
  }

  @override
  void didUpdateWidget(TimelineListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _controller = TimelineScrollController();
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
    WidgetsBinding.instance.removeTimingsCallback(timingCallback);
  }

  @override
  Widget build(BuildContext context) {
    final slivers = _buildSlivers(context, negative: false);
    final negativeSlivers = _buildSlivers(context, negative: true);
    final axisDirection = _getDirection(context);
    final scrollPhysics =
        widget.physics ?? const AlwaysScrollableScrollPhysics();
    return Scrollable(
      axisDirection: axisDirection,
      controller: _effectiveController,
      physics: scrollPhysics,
      viewportBuilder: (context, offset) {
        return Builder(
          builder: (context) {
            /// Build negative [ScrollPosition] for the negative scrolling [Viewport].
            final state = Scrollable.of(context);
            final negativeOffset = _InfiniteScrollPosition(
              physics: scrollPhysics,
              context: state,
              initialPixels: -offset.pixels,
              keepScrollOffset: _effectiveController.keepScrollOffset,
              negativeScroll: true,
            );
            _negativeOffset = negativeOffset;

            /// Keep the negative scrolling [Viewport] positioned to the [ScrollPosition].
            offset.addListener(() {
              negativeOffset._forceNegativePixels(offset.pixels);
            });

            /// Stack the two [Viewport]s on top of each other so they move in sync.
            return Stack(
              children: <Widget>[
                Viewport(
                  axisDirection: flipAxisDirection(axisDirection),
                  anchor: 1.0 - widget.anchor,
                  offset: negativeOffset,
                  slivers: negativeSlivers,
                  cacheExtent: widget.cacheExtent,
                ),
                Viewport(
                  axisDirection: axisDirection,
                  anchor: widget.anchor,
                  offset: offset,
                  slivers: slivers,
                  cacheExtent: widget.cacheExtent,
                ),
              ],
            );
          },
        );
      },
    );
  }

  AxisDirection _getDirection(BuildContext context) {
    return getAxisDirectionFromAxisReverseAndDirectionality(
      context,
      widget.scrollDirection,
      widget.reverse,
    );
  }

  List<Widget> _buildSlivers(BuildContext context, {bool negative = false}) {
    final itemExtent = widget.itemExtent;
    return <Widget>[
      SliverPadding(
        sliver: (itemExtent != null)
            ? SliverFixedExtentList(
                delegate: negative
                    ? negativeChildrenDelegate
                    : positiveChildrenDelegate,
                itemExtent: itemExtent,
              )
            : SliverList(
                delegate: negative
                    ? negativeChildrenDelegate
                    : positiveChildrenDelegate,
              ),
        padding: EdgeInsets.zero,
      ),
    ];
  }

  SliverChildDelegate get negativeChildrenDelegate {
    return SliverChildBuilderDelegate(
      (context, index) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final negativeOffset = _negativeOffset;
          if (negativeOffset == null) return;
          final extent = negativeOffset.hasContentDimensions
              ? negativeOffset.maxScrollExtent
              : null;
          negativeOffset._minMaxExtent = -(extent ?? 0);
          _controller?._offset = -(extent ?? 0);
        });
        final separatorBuilder = widget.separatorBuilder;
        if (separatorBuilder != null) {
          final itemIndex = (-1 - index) ~/ 2;
          return index.isOdd
              ? widget.itemBuilder(context, itemIndex)
              : separatorBuilder(context, itemIndex);
        } else {
          return widget.itemBuilder(context, -1 - index);
        }
      },
      childCount: widget.itemCount,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
    );
  }

  SliverChildDelegate get positiveChildrenDelegate {
    final separatorBuilder = widget.separatorBuilder;
    final itemCount = widget.itemCount;
    return SliverChildBuilderDelegate(
      (separatorBuilder != null)
          ? (context, index) {
              final itemIndex = index ~/ 2;
              return index.isEven
                  ? widget.itemBuilder(context, itemIndex)
                  : separatorBuilder(context, itemIndex);
            }
          : (context, index) => widget.itemBuilder(context, index),
      childCount: separatorBuilder == null
          ? itemCount
          : (itemCount != null ? math.max(0, itemCount * 2 - 1) : null),
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Axis>("scrollDirection", widget.scrollDirection))
      ..add(
        FlagProperty(
          "reverse",
          value: widget.reverse,
          ifTrue: "reversed",
          showName: true,
        ),
      )
      ..add(
        DiagnosticsProperty<ScrollController>(
          "controller",
          widget.controller,
          showName: false,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<ScrollPhysics>(
          "physics",
          widget.physics,
          showName: false,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<EdgeInsetsGeometry>(
          "padding",
          widget.padding,
          defaultValue: null,
        ),
      )
      ..add(
        DoubleProperty("itemExtent", widget.itemExtent, defaultValue: null),
      )
      ..add(
        DoubleProperty("cacheExtent", widget.cacheExtent, defaultValue: null),
      );
  }
}

/// Same as a [ScrollController] except it provides [ScrollPosition] objects with infinite bounds.
class TimelineScrollController extends ScrollController {
  /// Creates a new [TimelineScrollController]
  TimelineScrollController({
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
  }) {
    addListener(() {
      final currentPosition = position.pixels;
      _previousPosition = currentPosition;
      _previousMaxExtent = position.maxScrollExtent;
    });
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _InfiniteScrollPosition(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
      negativePredicate: () => _offset,
    );
  }

  double _offset = 0.0;

  double _previousPosition = 0.0;
  double _previousMaxExtent = 0.0;

  void forceScrollToTop() {
    if (isDisposed) return;
    if (positions.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        forceScrollToTop();
      });
    }
    jumpTo(position.maxScrollExtent);
    scrollToTop();
  }

  bool isDisposed = false;

  @override
  void dispose() {
    if (isDisposed) return;
    isDisposed = true;
    super.dispose();
  }

  void scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isDisposed) return;

      if (positions.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (isDisposed) return;
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
          if (isDisposed) return;

          scrollToTop();
        });
      }
    });
  }
}

class _InfiniteScrollPosition extends ScrollPositionWithSingleContext {
  _InfiniteScrollPosition({
    required super.physics,
    required super.context,
    super.initialPixels,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
    this.negativeScroll = false,
    this.negativePredicate,
  });

  final bool negativeScroll;
  final double Function()? negativePredicate;

  void _forceNegativePixels(double value) {
    super.forcePixels(-value);
  }

  @override
  void saveScrollOffset() {
    if (!negativeScroll) {
      super.saveScrollOffset();
    }
  }

  @override
  void restoreScrollOffset() {
    if (!negativeScroll) {
      super.restoreScrollOffset();
    }
  }

  @override
  double get minScrollExtent => negativePredicate?.call() ?? _minMaxExtent;

  double _minMaxExtent = 0;
}
