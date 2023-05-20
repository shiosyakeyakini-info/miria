import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends ConsumerState<SplashPage> {
  static bool _isFirst = true;

  Future<void> initialize() async {
    await ref.read(accountRepository).load();
    await ref.read(tabSettingsRepositoryProvider).load();
    await ref.read(accountSettingsRepositoryProvider).load();

    for (final account in ref.read(accountRepository).account) {
      await ref.read(emojiRepositoryProvider(account)).loadFromSource();
    }

    if (_isFirst) {
      LicenseRegistry.addLicense(() => Stream.fromIterable(<LicenseEntry>[
            const LicenseEntryWithLineBreaks(["Blob Emoji"], """
Copyright blob.gg

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
          """),
            const LicenseEntryWithLineBreaks(["Meowmoji"], """
Meowmoji is a derivative of Blob Emoji, licensed under Apache 2.0.
The license follows the meowmoji official server community at  https://discord.gg/pFUhE5z.
          """)
          ]));
    }

    _isFirst = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final isSigned = ref.read(accountRepository).account.isNotEmpty;
              final hasTabSetting = ref
                  .read(tabSettingsRepositoryProvider)
                  .tabSettings
                  .isNotEmpty;

              if (isSigned && hasTabSetting) {
                context.replaceRoute(TimeLineRoute(
                    currentTabSetting: ref
                        .read(tabSettingsRepositoryProvider)
                        .tabSettings
                        .first));
              } else if (isSigned && !hasTabSetting) {
                // KeyChainに保存したデータだけアンインストールしても残るので
                // この状況が発生する
                Future(() async {
                  final accounts = ref.read(accountRepository).account.toList();
                  for (final account in accounts) {
                    await ref.read(accountRepository).remove(account);
                  }
                  if (!mounted) return;

                  context.replaceRoute(const LoginRoute());
                });
              } else {
                context.replaceRoute(const LoginRoute());
              }
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
