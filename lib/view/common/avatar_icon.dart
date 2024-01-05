import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/cat_ear.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AvatarIcon extends StatefulWidget {
  final User user;
  final double height;
  final VoidCallback? onTap;

  const AvatarIcon({
    super.key,
    required this.user,
    this.height = 48,
    this.onTap,
  });

  factory AvatarIcon.fromIResponse(IResponse response, {double height = 48}) {
    return AvatarIcon(
      user: User(
        id: response.id,
        username: response.username,
        avatarUrl: response.avatarUrl,
        avatarBlurhash: response.avatarBlurhash,
        avatarDecorations: response.avatarDecorations,
        isCat: response.isCat,
        isBot: response.isBot,
      ),
      height: height,
    );
  }

  factory AvatarIcon.fromUserResponse(
    UsersShowResponse response, {
    double height = 48,
  }) {
    return AvatarIcon(
      user: User(
        id: response.id,
        username: response.username,
        avatarUrl: response.avatarUrl,
        avatarBlurhash: response.avatarBlurhash,
        avatarDecorations: response.avatarDecorations,
        isCat: response.isCat,
        isBot: response.isBot,
      ),
      height: height,
    );
  }

  @override
  State<StatefulWidget> createState() => AvatarIconState();
}

class AvatarIconState extends State<AvatarIcon>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? controller;
  Color? catEarColor;
  bool loopAnimation = false;

  Color? averageColor() {
    // https://github.com/woltapp/blurhash/blob/master/Algorithm.md
    final blurhash = widget.user.avatarBlurhash;
    if (blurhash == null) {
      return null;
    }
    final value = blurhash
        .substring(2, 6)
        .split("")
        .map(
          r'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~'
              .indexOf,
        )
        .fold(0, (acc, i) => acc * 83 + i);
    return Color(0xFF000000 | value);
  }

  @override
  void initState() {
    super.initState();

    if (widget.user.isCat) {
      catEarColor = averageColor();
      controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
      // 37.6deg -> 10deg -> 20deg -> 0deg -> 37.6deg
      animation = TweenSequence([
        TweenSequenceItem(
          tween: Tween(begin: 0.65624379, end: 0.17453292),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.17453292, end: 0.34906585),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.34906585, end: 0.0),
          weight: 20,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 0.65624379),
          weight: 25,
        ),
      ]).animate(controller!)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (loopAnimation) {
              controller?.forward(from: 0);
            }
          }
        });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseHeight = MediaQuery.textScalerOf(context).scale(widget.height);

    return GestureDetector(
      onTap: widget.onTap ??
          () {
            context.pushRoute(
              UserRoute(
                  userId: widget.user.id, account: AccountScope.of(context)),
            );
          },
      onLongPressStart: widget.user.isCat
          ? (_) {
              if (!loopAnimation) {
                controller?.forward(from: 0);
              }
              setState(() {
                loopAnimation = true;
              });
            }
          : null,
      onLongPressEnd: widget.user.isCat
          ? (_) {
              setState(() {
                loopAnimation = false;
              });
            }
          : null,
      child: Padding(
        padding: EdgeInsets.only(
          top: 3,
          left: MediaQuery.textScalerOf(context).scale(15),
          right: MediaQuery.textScalerOf(context).scale(5),
        ),
        child: Stack(
          children: [
            if (widget.user.isCat) ...[
              Transform.translate(
                offset: Offset(baseHeight * 0.25, baseHeight * 0.25),
                child: CatEar(
                  listenable: animation!,
                  color: catEarColor ?? Theme.of(context).primaryColor,
                  height: baseHeight * 0.5,
                ),
              ),
              Transform.translate(
                offset: Offset(baseHeight * 0.75, baseHeight * 0.25),
                child: CatEar(
                  listenable: animation!,
                  color: catEarColor ?? Theme.of(context).primaryColor,
                  height: baseHeight * 0.5,
                  flipped: true,
                ),
              ),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(baseHeight),
              child: SizedBox(
                width: baseHeight,
                height: baseHeight,
                child: NetworkImageView(
                  fit: BoxFit.cover,
                  url: widget.user.avatarUrl.toString(),
                  type: ImageType.avatarIcon,
                ),
              ),
            ),
            for (final decoration in widget.user.avatarDecorations)
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
                                  url: decoration.url, type: ImageType.other),
                            ),
                          )
                        : SizedBox(
                            width: baseHeight,
                            child: NetworkImageView(
                                url: decoration.url,
                                type: ImageType.avatarDecoration)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
