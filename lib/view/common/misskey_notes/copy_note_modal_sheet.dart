import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:miria/view/themes/app_theme.dart';

class CopyNoteModalSheet extends ConsumerWidget{

  final String note;

  const CopyNoteModalSheet({
    super.key,
    required this.note,
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
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: note)
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).doneCopy),
                      duration: const Duration(seconds: 1)
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                tooltip: S.of(context).copyContents,
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  note,
                  style: AppTheme.of(context).monospaceStyle,
                ),
              )
            )
          ],
        )
      ),
    );
  }
}