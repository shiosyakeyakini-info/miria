import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class MisskeyAd extends ConsumerStatefulWidget {
  const MisskeyAd({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyAdState();
}

class MisskeyAdState extends ConsumerState<MisskeyAd> {
  MetaAd? choosen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (AccountScope.of(context).i.policies.canHideAds &&
        !ref
            .read(accountSettingsRepositoryProvider)
            .fromAccount(AccountScope.of(context))
            .forceShowAd) {
      return;
    }

    final ads = AccountScope.of(context).meta?.ads ?? [];
    final totalRatio = ads.map((e) => e.ratio).sum;
    final choosenRatio = Random().nextDouble() * totalRatio;

    var calculatingRatio = 0.0;
    for (final ad in ads) {
      if (calculatingRatio + ad.ratio > choosenRatio) {
        choosen = ad;
        break;
      }
      calculatingRatio += ad.ratio;
    }
    if (choosen == null && ads.isNotEmpty) {
      choosen = ads.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetAd = choosen;
    if (targetAd == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: GestureDetector(
        onTap: () =>
            launchUrl(targetAd.url, mode: LaunchMode.externalApplication),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: NetworkImageView(
              url: targetAd.imageUrl.toString(),
              type: ImageType.ad,
            ),
          ),
        ),
      ),
    );
  }
}
