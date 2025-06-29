import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "package:miria/l10n/app_localizations.dart";
import "package:miria/state_notifier/common/server_preset_provider.dart";

@RoutePage()
class TimelinePresetDialog extends HookConsumerWidget {
  const TimelinePresetDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(serverPresetsProvider);
    return AlertDialog(
      title: Text(S.of(context).template),
      content: presets.when(
        data: (data) => SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: data.particularTimelinePresets.length,
            itemBuilder: (context, index) {
              final preset = data.particularTimelinePresets[index];
              return ListTile(
                title: Text(preset.name),
                subtitle: Text(preset.host),
                onTap: () => context.maybePop(preset),
              );
            },
          ),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, st) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(height: 8),
            Text("Error loading presets:"),
            const SizedBox(height: 4),
            Text(e.toString(), style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.invalidate(serverPresetsProvider),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
