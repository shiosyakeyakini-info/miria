import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/string_extensions.dart';
import 'package:miria/model/federation_data.dart';
import 'package:miria/view/common/constants.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/federation_page/federation_page.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class FederationInfo extends ConsumerStatefulWidget {
  final String host;

  const FederationInfo({
    super.key,
    required this.host,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FederationInfoState();
}

class FederationInfoState extends ConsumerState<FederationInfo> {
  (Object?, StackTrace)? error;
  FederationData? data;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(federationPageFederationDataProvider);
    if (data != null) {
      final description = data.description.replaceAll(htmlTagRemove, "");
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
                    url: data.bannerUrl!.toString(), type: ImageType.other),
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
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Text(description),
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
                      const Text(
                        "ユーザー",
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
                      const Text(
                        "投稿",
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
                      const Text(
                        "ソフトウェア",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${data.softwareName} ${data.softwareVersion}",
                      )
                    ],
                  ),
                  if (data.languages.isNotEmpty)
                    TableRow(children: [
                      const Text("言語", textAlign: TextAlign.center),
                      Text(
                        data.languages.join(", "),
                      )
                    ]),
                  if (data.maintainerName != null)
                    TableRow(children: [
                      const Text(
                        "管理者",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${data.maintainerName}",
                      )
                    ]),
                  if (data.maintainerEmail != null)
                    TableRow(children: [
                      const Text(
                        "連絡先",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${data.maintainerEmail}",
                      )
                    ]),
                  if (data.serverRules.isNotEmpty)
                    TableRow(children: [
                      const Text(
                        "サーバーのきめごと",
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final rule in data.serverRules.indexed)
                            Text("${(rule.$1 + 1)}. ${rule.$2}\n")
                        ],
                      )
                    ]),
                  if (data.tosUrl != null)
                    TableRow(children: [
                      const Text(
                        "利用規約",
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(data.tosUrl!)),
                        child: Text(
                          data.tosUrl!.toString().tight,
                          style: AppTheme.of(context).linkStyle,
                        ),
                      )
                    ]),
                  if (data.privacyPolicyUrl != null)
                    TableRow(children: [
                      const Text(
                        "プライバシーポリシー",
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () =>
                            launchUrl(Uri.parse(data.privacyPolicyUrl!)),
                        child: Text(
                          data.tosUrl!.toString().tight,
                          style: AppTheme.of(context).linkStyle,
                        ),
                      )
                    ]),
                  if (data.impressumUrl != null)
                    TableRow(children: [
                      const Text(
                        "運営者情報",
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(data.impressumUrl!)),
                        child: Text(
                          data.tosUrl!.toString().tight,
                          style: AppTheme.of(context).linkStyle,
                        ),
                      )
                    ]),
                ],
              ),
            ],
          ),
        ),
      );
    }
    if (error != null) {
      ErrorDetail(
        error: error?.$1,
        stackTrace: error?.$2,
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
