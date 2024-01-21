import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/futurable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SoftMutePage extends ConsumerStatefulWidget {
  const SoftMutePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SoftMuteState();
}

class SoftMuteState extends ConsumerState<SoftMutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).wordMute)),
      body: SingleChildScrollView(
        child: CommonFuture(
          future: () async {
            return [];
          }(),
          complete: (context, data) {
            return Row(
              children: [
                Card(child: Text(S.of(context).hideConditionalNotes)),
                const TextField(
                  maxLines: null,
                  minLines: 5,
                ),
                Text(
                  S.of(context).muteSettingDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
