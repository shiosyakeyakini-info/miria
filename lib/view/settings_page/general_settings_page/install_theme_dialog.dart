import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:json5/json5.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/color_theme.dart";
import "package:miria/model/misskey_theme.dart";
import "package:miria/state_notifier/installed_themes_page/misskey_theme_codes_notifier.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/themes/built_in_color_themes.dart";

@RoutePage()
class InstallThemeDialog extends HookConsumerWidget {
  const InstallThemeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    return AlertDialog(
      scrollable: true,
      title: Text(S.of(context).installTheme),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: S.of(context).themeCode),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 10,
              textAlignVertical: TextAlignVertical.top,
              validator: (code) {
                if (code == null || code.isEmpty) {
                  return S.of(context).pleaseInputSomething;
                }
                try {
                  ColorTheme.misskey(
                    MisskeyTheme.fromJson(
                      json5Decode(code) as Map<String, dynamic>,
                    ),
                  );
                } catch (e) {
                  return S.of(context).invalidThemeFormat;
                }
                return null;
              },
              onSaved: (code) async {
                if (code != null && formKey.currentState!.validate()) {
                  final theme = MisskeyTheme.fromJson(
                    json5Decode(code) as Map<String, dynamic>,
                  );
                  if (builtInColorThemes.any((e) => e.id == theme.id) ||
                      ref
                          .read(misskeyThemesProvider)
                          .any((e) => e?.id == theme.id)) {
                    await ref
                        .read(dialogStateNotifierProvider.notifier)
                        .showSimpleDialog(
                          message: (context) =>
                              S.of(context).alreadyInstalledTheme,
                        );
                    return;
                  }
                  await ref
                      .read(misskeyThemeCodesNotifierProvider.notifier)
                      .install(code);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                }
              },
            ),
            ElevatedButton(
              onPressed: () => formKey.currentState?.save(),
              child: Text(S.of(context).install),
            ),
          ],
        ),
      ),
    );
  }
}
