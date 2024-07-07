import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "app_info_page.g.dart";

@riverpod
Future<PackageInfo> packageInfo(PackageInfoRef ref) async =>
    await PackageInfo.fromPlatform();

@RoutePage()
class AppInfoPage extends ConsumerWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).aboutMiria)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AccountContextScope.as(
            account: Account.demoAccount("", null),
            child: Column(
              children: [
                MfmText(
                  mfmText: '''
<center>\$[x3 Miria]</center>
${S.of(context).packageName}: ${packageInfo?.packageName ?? ""}
${S.of(context).version}: ${packageInfo?.version ?? ""}+${packageInfo?.buildNumber ?? ""}

${S.of(context).developer}: @shiosyakeyakini@misskey.io

\$[x2 **${S.of(context).aboutMiria}**]
[${S.of(context).officialWebSite}](https://shiosyakeyakini.info/miria_web/index.html)
[GitHub](https://github.com/shiosyakeyakini-info/miria)

\$[x2 **${S.of(context).openSourceLicense}**]
''',
                ),
                ElevatedButton(
                  onPressed: () async {
                    showLicensePage(
                      context: context,
                      applicationName: packageInfo?.appName.toString(),
                      applicationIcon: Image.asset("assets/images/icon.png"),
                      applicationVersion:
                          "${packageInfo?.version ?? ""}+${packageInfo?.buildNumber.toString() ?? ""}",
                    );
                  },
                  child: Text(S.of(context).showLicense),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
