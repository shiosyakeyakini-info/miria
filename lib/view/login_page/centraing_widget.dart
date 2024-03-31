import "package:flutter/cupertino.dart";

class CenteringWidget extends StatelessWidget {
  final Widget child;

  const CenteringWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: child)));
  }
}
