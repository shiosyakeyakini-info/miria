import "dart:math";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:misskey_dart/misskey_dart.dart";

class AvatarIcon extends HookConsumerWidget {
  final User user;
  final double height;
  final VoidCallback? onTap;

  const AvatarIcon({
    required this.user,
    super.key,
    this.height = 48,
    this.onTap,
  });

  Color? averageColor() {
    // https://github.com/woltapp/blurhash/blob/master/Algorithm.md
    final blurhash = user.avatarBlurhash;
    if (blurhash == null) {
      return null;
    }
    final value = blurhash
        .substring(2, 6)
        .split("")
        .map(
          r"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~"
              .indexOf,
        )
        .fold(0, (acc, i) => acc * 83 + i);
    return Color(0xFF000000 | value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseHeight = MediaQuery.textScalerOf(context).scale(height);
    final catEarColor = useMemoized(() => user.isCat ? averageColor() : null);

    return GestureDetector(
      onTap: onTap ??
          () async => context.pushRoute(
                UserRoute(
                  userId: user.id,
                  accountContext: ref.read(accountContextProvider),
                ),
              ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 3,
          left: MediaQuery.textScalerOf(context).scale(15),
          right: MediaQuery.textScalerOf(context).scale(5),
        ),
        child: Stack(
          children: [
            if (user.isCat)
              Positioned(
                left: 0,
                top: 0,
                width: baseHeight,
                height: baseHeight,
                child: Transform.rotate(
                  angle: -0 * pi / 180,
                  child: Transform.translate(
                    offset: Offset(
                      -baseHeight * 0.333,
                      -baseHeight * 0.3,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: catEarColor ?? Theme.of(context).primaryColor,
                      size: baseHeight,
                    ),
                  ),
                ),
              ),
            if (user.isCat)
              Positioned(
                left: 0,
                top: 0,
                width: baseHeight,
                height: baseHeight,
                child: Transform.translate(
                  offset: Offset(
                    baseHeight * 1.333,
                    -baseHeight * 0.3,
                  ),
                  child: Transform(
                    transform: Matrix4.rotationY(pi),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: catEarColor ?? Theme.of(context).primaryColor,
                      size: baseHeight,
                    ),
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(baseHeight),
              child: SizedBox(
                width: baseHeight,
                height: baseHeight,
                child: NetworkImageView(
                  fit: BoxFit.cover,
                  url: user.avatarUrl.toString(),
                  type: ImageType.avatarIcon,
                ),
              ),
            ),
            for (final decoration in user.avatarDecorations)
              Transform.scale(
                scaleX: 2,
                scaleY: 2,
                child: Transform.translate(
                  offset: Offset(
                    baseHeight * decoration.offsetX,
                    baseHeight * decoration.offsetY,
                  ),
                  child: Transform.rotate(
                    angle: (decoration.angle ?? 0) * 2 * pi,
                    alignment: Alignment.center,
                    child: decoration.flipH
                        ? Transform.flip(
                            flipX: true,
                            child: SizedBox(
                              width: baseHeight,
                              child: NetworkImageView(
                                url: decoration.url,
                                type: ImageType.other,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: baseHeight,
                            child: NetworkImageView(
                              url: decoration.url,
                              type: ImageType.avatarDecoration,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
