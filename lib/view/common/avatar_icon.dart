import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/network_image.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AvatarIcon extends StatelessWidget {
  final User user;

  const AvatarIcon({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(
            UserRoute(userId: user.id, account: AccountScope.of(context)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: SizedBox(
            width: 32 * MediaQuery.of(context).textScaleFactor,
            height: 32 * MediaQuery.of(context).textScaleFactor,
            child: NetworkImageView(
              url: user.avatarUrl.toString(),
              type: ImageType.avatarIcon,
            )),
      ),
    );
  }
}
