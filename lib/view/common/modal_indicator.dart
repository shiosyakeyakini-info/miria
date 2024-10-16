/*
 * 汎用くるくるインジケータ
 */
import "package:flutter/material.dart";

class IndicatorView {
  /*
   * インジケータ表示
   */
  static showIndicator(BuildContext context) {
    Navigator.push(
      context,
      ModalOverlay(
        const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        isAndroidBackEnable: false,
      ),
    );
  }

  /*
   * インジケータ非表示
   */
  static hideIndicator(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/*
 * モーダルオーバーレイ
 */
class ModalOverlay extends ModalRoute<void> {
  // ダイアログ内のWidget
  final Widget contents;

  // Androidのバックボタンを有効にするか
  final bool isAndroidBackEnable;

  ModalOverlay(this.contents, {this.isAndroidBackEnable = true}) : super();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);
  @override
  bool get opaque => false;
  @override
  bool get barrierDismissible => false;
  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return PopScope(
      canPop: isAndroidBackEnable,
      child: contents,
    ); //
  }
}
