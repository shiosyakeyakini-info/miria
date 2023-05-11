import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/network_image.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AvatarIcon extends StatelessWidget {
  final User user;
  final double height;

  const AvatarIcon({
    super.key,
    required this.user,
    this.height = 48,
  });

  factory AvatarIcon.fromIResponse(IResponse response, {double height = 48}) {
    return AvatarIcon(
      user: User(
        id: response.id,
        username: response.username,
        avatarUrl: response.avatarUrl,
        isCat: response.isCat,
        isBot: response.isBot,
      ),
      height: height,
    );
  }

  factory AvatarIcon.fromUserResponse(UsersShowResponse response,
      {double height = 48}) {
    return AvatarIcon(
      user: User(
        id: response.id,
        username: response.username,
        avatarUrl: response.avatarUrl,
        isCat: response.isCat,
        isBot: response.isBot,
      ),
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.pushRoute(
              UserRoute(userId: user.id, account: AccountScope.of(context)));
        },
        child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Stack(children: [
              if (user.isCat)
                Positioned(
                    left: 0,
                    top: 0,
                    width: height,
                    height: height,
                    child: Transform.rotate(
                      angle: -0 * pi / 180,
                      child: Transform.translate(
                        offset: Offset(-height * 0.3, -height * 0.3),
                        child: Icon(Icons.play_arrow_rounded,
                            color: Theme.of(context).primaryColor,
                            size: height * 1),
                      ),
                    )),
              if (user.isCat)
                Positioned(
                    left: 0,
                    top: 0,
                    width: height,
                    height: height,
                    child: Transform.translate(
                      offset: Offset(height * 1.333, -height * 0.3),
                      child: Transform(
                        transform: Matrix4.rotationY(pi),
                        child: Icon(Icons.play_arrow_rounded,
                            color: Theme.of(context).primaryColor,
                            size: height * 1),
                      ),
                    )),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    height * MediaQuery.of(context).textScaleFactor),
                child: SizedBox(
                    width: height * MediaQuery.of(context).textScaleFactor,
                    height: height * MediaQuery.of(context).textScaleFactor,
                    child: NetworkImageView(
                      fit: BoxFit.fitHeight,
                      url: user.avatarUrl.toString(),
                      type: ImageType.avatarIcon,
                    )),
              ),
            ])));
  }
}
