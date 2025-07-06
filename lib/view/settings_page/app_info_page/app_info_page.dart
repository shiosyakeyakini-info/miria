import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/common/cache_size_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "app_info_page.g.dart";

@riverpod
Future<PackageInfo> packageInfo(Ref ref) async =>
    await PackageInfo.fromPlatform();

@RoutePage()
class AppInfoPage extends HookConsumerWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheSize = ref.watch(cacheSizeNotifierProvider);
    final packageInfo = ref.watch(packageInfoProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).aboutMiria)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AccountContextScope.as(
            account: ref.read(accountsProvider).first,
            child: Column(
              children: [
                MfmText(
                  mfmText:
                      '''
<center>\$[x3 Miria]</center>
${S.of(context).packageName}: ${packageInfo?.packageName ?? ""}
${S.of(context).version}: ${packageInfo?.version ?? ""}+${packageInfo?.buildNumber ?? ""}

${S.of(context).developer}: @shiosyakeyakini@misskey.io

\$[x2 **${S.of(context).aboutMiria}**]
[${S.of(context).officialWebSite}](https://shiosyakeyakini.info/miria_web/index.html)
[GitHub](https://github.com/shiosyakeyakini-info/miria)

\$[x2 **${S.of(context).openSourceLicense}**]''',
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
                Padding(
                  padding: EdgeInsetsGeometry.only(top: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).cache,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            Text(S.of(context).cacheSize),
                            Center(
                              child: cacheSize.when(
                                loading: () =>
                                    const CircularProgressIndicator(),
                                error: (_, __) =>
                                    Text(S.of(context).cacheSizeError),
                                data: (cacheSize) {
                                  return Text(cacheSize);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (cacheSize.hasValue)
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await ref
                                .read(cacheSizeNotifierProvider.notifier)
                                .clear();
                          },
                          child: Text(S.of(context).clearCache),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
