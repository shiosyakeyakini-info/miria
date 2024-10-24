import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class LocalOnlyIcon extends StatelessWidget {
  final double? size;
  final Color? color;

  const LocalOnlyIcon({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/images/unfederate.svg",
      colorFilter: ColorFilter.mode(
        color ?? const Color(0xff5f6368),
        BlendMode.srcIn,
      ),
      height: size,
      width: size,
    );
  }
}
