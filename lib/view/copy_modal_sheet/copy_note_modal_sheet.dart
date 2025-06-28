import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/view/themes/app_theme.dart";

class CopyNoteModalSheet extends ConsumerWidget {
  final String text;
  final String? cw;

  const CopyNoteModalSheet({
    required this.text,
    this.cw,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              title: Text(S.of(context).detail),
              trailing: IconButton(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: text),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).doneCopy),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                tooltip: S.of(context).copyContents,
              ),
            ),
            if (cw != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SelectableText(
                            cw!,
                            style: AppTheme.of(context).monospaceStyle,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: cw!),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).doneCopy),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  text,
                  style: AppTheme.of(context).monospaceStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
