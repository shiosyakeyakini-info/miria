import "dart:async";

import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/state_notifier/aiscript_plugin_notifier.dart";

/// 入れてあるプラグインを、ログイン済みのアカウントそれぞれで動かす。
///
/// アプリの根に置く。アカウントは起動直後にはまだ読めていないので、
/// 増えるたびに動かす。二度目以降は
/// [AiScriptPluginNotifier.launchAll] 側で弾かれる。
class PluginLauncher extends ConsumerWidget {
  final Widget child;

  const PluginLauncher({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountRepositoryProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();

    for (final account in accounts) {
      unawaited(
        ref
            .read(aiScriptPluginProvider(account).notifier)
            .launchAll(locale: locale),
      );
    }

    return child;
  }
}
