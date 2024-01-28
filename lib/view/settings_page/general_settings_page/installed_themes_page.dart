import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json5/json5.dart';
import 'package:miria/model/misskey_theme.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/settings_page/general_settings_page/install_theme_dialog.dart';

@RoutePage()
class InstalledThemesPage extends ConsumerWidget {
  const InstalledThemesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codes = ref.watch(installedThemeCodeRepositoryProvider);
    final themes = codes
        .map(
          (code) => MisskeyTheme.fromJson(
            json5Decode(code) as Map<String, dynamic>,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).installedThemes),
        actions: [
          IconButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => const InstallThemeDialog(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: themes.isEmpty
          ? Center(child: Text(S.of(context).noInstalledThemes))
          : ListView.builder(
              itemCount: themes.length,
              itemBuilder: (context, index) {
                final theme = themes[index];
                final code = codes[index];
                return ListTile(
                  title: Text(theme.name),
                  subtitle: Text(theme.author ?? ""),
                  trailing: IconButton(
                    onPressed: () async {
                      final result = await SimpleConfirmDialog.show(
                        context: context,
                        message: S.of(context).confirmDeleteTheme,
                        primary: S.of(context).willDelete,
                        secondary: S.of(context).cancel,
                      );
                      if (!context.mounted) return;
                      if (result ?? false) {
                        ref
                            .read(colorThemeRepositoryProvider.notifier)
                            .removeTheme(theme.id);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        scrollable: true,
                        title: Text(S.of(context).themeCode),
                        content: Text(code),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(S.of(context).doneCopy)),
                              );
                              Navigator.of(context).pop();
                            },
                            child: Text(S.of(context).copy),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
