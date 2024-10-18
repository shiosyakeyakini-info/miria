import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_html/flutter_html.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/string_extensions.dart";
import "package:miria/model/federation_data.dart";
import "package:miria/view/common/constants.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:url_launcher/url_launcher.dart";
import "package:url_launcher/url_launcher_string.dart";

class FederationInfo extends ConsumerWidget {
  final FederationData data;

  const FederationInfo({required this.data, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = data.description;
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.bannerUrl != null)
              NetworkImageView(
                url: data.bannerUrl!.toString(),
                type: ImageType.other,
              ),
            Row(
              children: [
                if (data.faviconUrl != null)
                  SizedBox(
                    width: 32,
                    child: NetworkImageView(
                      url: data.faviconUrl!.toString(),
                      type: ImageType.serverIcon,
                    ),
                  ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Text(
                    data.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Html(
              data: description,
              style: {
                "a": Style(color: AppTheme.of(context).linkStyle.color),
              },
              onLinkTap: (url, _, __) async {
                await launchUrlString(url.toString());
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      data.usersCount.format(ifNull: "???"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      S.of(context).user,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      data.notesCount.format(ifNull: "???"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      S.of(context).federatedPosts,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Text(
                      S.of(context).software,
                      textAlign: TextAlign.center,
                    ),
                    Text("${data.softwareName} ${data.softwareVersion}"),
                  ],
                ),
                if (data.languages.isNotEmpty)
                  TableRow(
                    children: [
                      Text(
                        S.of(context).language,
                        textAlign: TextAlign.center,
                      ),
                      Text(data.languages.join(", ")),
                    ],
                  ),
                if (data.maintainerName != null)
                  TableRow(
                    children: [
                      Text(
                        S.of(context).administrator,
                        textAlign: TextAlign.center,
                      ),
                      Text("${data.maintainerName}"),
                    ],
                  ),
                if (data.maintainerEmail != null)
                  TableRow(
                    children: [
                      Text(
                        S.of(context).contact,
                        textAlign: TextAlign.center,
                      ),
                      Text("${data.maintainerEmail}"),
                    ],
                  ),
                if (data.serverRules.isNotEmpty)
                  TableRow(
                    children: [
                      Text(
                        S.of(context).serverRules,
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final rule in data.serverRules.indexed)
                            Html(
                              data: "${rule.$1 + 1}. ${rule.$2}<br>",
                              style: {
                                "a": Style(
                                  color: AppTheme.of(context).linkStyle.color,
                                ),
                              },
                              onLinkTap: (url, _, __) async {
                                await launchUrlString(url.toString());
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                if (data.tosUrl != null)
                  TableRow(
                    children: [
                      Text(
                        S.of(context).tos,
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () async => launchUrl(Uri.parse(data.tosUrl!)),
                        child: Text(
                          data.tosUrl!.toString().tight,
                          style: AppTheme.of(context).linkStyle,
                        ),
                      ),
                    ],
                  ),
                if (data.privacyPolicyUrl != null)
                  TableRow(
                    children: [
                      Text(
                        S.of(context).privacyPolicy,
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () async =>
                            launchUrl(Uri.parse(data.privacyPolicyUrl!)),
                        child: Text(
                          data.privacyPolicyUrl!.toString().tight,
                          style: AppTheme.of(context).linkStyle,
                        ),
                      ),
                    ],
                  ),
                if (data.impressumUrl != null)
                  TableRow(
                    children: [
                      Text(
                        S.of(context).impressum,
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () async =>
                            launchUrl(Uri.parse(data.impressumUrl!)),
                        child: Text(
                          data.impressumUrl!.toString().tight,
                          style: AppTheme.of(context).linkStyle,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
