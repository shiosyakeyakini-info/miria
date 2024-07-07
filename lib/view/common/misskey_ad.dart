import "dart:math";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:url_launcher/url_launcher.dart";

class MisskeyAd extends HookConsumerWidget {
  const MisskeyAd({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetAd = useMemoized(() {
      if (ref.read(accountContextProvider).getAccount.i.policies.canHideAds &&
          !ref
              .read(accountSettingsRepositoryProvider)
              .fromAccount(ref.read(accountContextProvider).getAccount)
              .forceShowAd) {
        return null;
      }

      final ads = ref.read(accountContextProvider).getAccount.meta?.ads ?? [];
      if (ads.isEmpty) return null;

      final totalRatio = ads.map((e) => e.ratio).sum;
      final choosenRatio = Random().nextDouble() * totalRatio;

      var calculatingRatio = 0.0;
      for (final ad in ads) {
        if (calculatingRatio + ad.ratio > choosenRatio) {
          return ad;
        }
        calculatingRatio += ad.ratio;
      }

      return ads.last;
    });

    if (targetAd == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: GestureDetector(
        onTap: () async =>
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
