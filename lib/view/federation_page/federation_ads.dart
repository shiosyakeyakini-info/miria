import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/federation_page/federation_page.dart";
import "package:url_launcher/url_launcher.dart";

class FederationAds extends ConsumerStatefulWidget {
  const FederationAds({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FederationAdsState();
}

class FederationAdsState extends ConsumerState<FederationAds> {
  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(
      federationPageFederationDataProvider.select((value) => value?.ads),
    );
    if (ads == null) return const SizedBox.shrink();
    return ListView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        return Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => launchUrl(ad.url),
            child: NetworkImageView(
              url: ad.imageUrl.toString(),
              type: ImageType.ad,
            ),
          ),
        );
      },
    );
  }
}
