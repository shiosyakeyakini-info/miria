import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/server_preset.dart';
import '../../../state_notifier/common/server_preset_provider.dart';

@RoutePage<TimelinePreset>()
class TimelinePresetDialog extends HookConsumerWidget {
  const TimelinePresetDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(serverPresetsProvider);
    return AlertDialog(
      title: const Text('Preset'),
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
        error: (e, st) => Text(e.toString()),
      ),
    );
  }
}
