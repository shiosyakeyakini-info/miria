import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class AppInfoPage extends ConsumerStatefulWidget {
  const AppInfoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppInfoPageState();
}

class AppInfoPageState extends ConsumerState<AppInfoPage> {
  PackageInfo? packageInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      packageInfo = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("このアプリについて")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AccountScope(
            account: ref.read(accountRepository).account.first,
            child: Column(
              children: [
                MfmText(mfmText: '''
<center>\$[x3 Miria]</center>
パッケージ名：${packageInfo?.packageName ?? ""}
バージョン:${packageInfo?.version ?? ""}+${packageInfo?.buildNumber.toString() ?? ""}

開発者：@shiosyakeyakini@misskey.io

\$[x2 **このアプリについて**]
[公式ページ](https://shiosyakeyakini.info/miria_web/index.html)
[GitHub](https://github.com/shiosyakeyakini-info/miria)

\$[x2 **オープンソースライセンス**]
                '''),
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
                  child: const Text("ライセンスを表示する"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
