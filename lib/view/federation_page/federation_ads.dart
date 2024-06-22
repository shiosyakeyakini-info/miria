import "package:flutter/cupertino.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:url_launcher/url_launcher.dart";

class FederationAds extends StatelessWidget {
  final List<MetaAd> ads;

  const FederationAds({required this.ads, super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        return Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () async => launchUrl(ad.url),
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
