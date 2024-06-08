import "dart:math";

import "package:flutter/material.dart";

class LocalOnlyIcon extends StatelessWidget {
  final double? size;
  final Color? color;

  const LocalOnlyIcon({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          Icons.rocket,
          size: size,
          color: color,
        ),
        Transform.translate(
          offset: Offset(3, (size ?? 22) / 2 - 1),
          child: Transform.rotate(
            angle: 45 * pi / 180,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: color ?? Colors.grey,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
