import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:json5/json5.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/misskey_theme.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/installed_themes_page/misskey_theme_codes_notifier.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";

@RoutePage()
class InstalledThemesPage extends ConsumerWidget {
  const InstalledThemesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codes = ref.watch(misskeyThemeCodesNotifierProvider).value ?? [];
    final themes = codes
        .map(
          (code) =>
              MisskeyTheme.fromJson(json5Decode(code) as Map<String, dynamic>),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).installedThemes),
        actions: [
          IconButton(
            onPressed: () async {
              await context.pushRoute(const InstallThemeRoute());
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
                        await ref
                            .read(misskeyThemeCodesNotifierProvider.notifier)
                            .uninstall(index);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        scrollable: true,
                        title: Text(S.of(context).themeCode),
                        content: Text(code),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: code),
                              );
                              if (!context.mounted) return;
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
