import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/repository/ai_repository.dart";
import "package:miria/repository/ai_settings_repository.dart";

@RoutePage()
class AiSettingsPage extends HookConsumerWidget {
  const AiSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettings = ref.watch(aiSettingsRepositoryProvider);
    final aiRepository = ref.watch(aiRepositoryProvider);
    final downloadProgress = useState<double?>(null);
    final isDownloading = useState(false);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).ai_settings)),
      body: aiSettings.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // モデル状態
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.memory,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).ai_model_status,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<bool>(
                      future: aiRepository.isModelAvailable(),
                      builder: (context, snapshot) {
                        final isAvailable = snapshot.data ?? false;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isAvailable
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: isAvailable
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isAvailable
                                      ? S.of(context).ai_model_downloaded
                                      : S.of(context).ai_model_not_downloaded,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            if (!isAvailable) ...[
                              const SizedBox(height: 8),
                              Text(
                                S.of(context).ai_model_description,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 12),
                              if (isDownloading.value)
                                Column(
                                  children: [
                                    LinearProgressIndicator(
                                      value: downloadProgress.value,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      downloadProgress.value != null
                                          ? "${(downloadProgress.value! * 100).toStringAsFixed(1)}%"
                                          : S.of(context).downloading,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                )
                              else
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      isDownloading.value = true;
                                      downloadProgress.value = null;

                                      try {
                                        final success = await aiRepository
                                            .downloadModel(
                                              onProgress: (progress) {
                                                downloadProgress.value =
                                                    progress;
                                              },
                                            );

                                        if (success) {
                                          await ref
                                              .read(
                                                aiSettingsRepositoryProvider
                                                    .notifier,
                                              )
                                              .setModelDownloaded(true);

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                S
                                                    .of(context)
                                                    .ai_model_download_success,
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                S
                                                    .of(context)
                                                    .ai_model_download_failed,
                                              ),
                                            ),
                                          );
                                        }
                                      } finally {
                                        isDownloading.value = false;
                                        downloadProgress.value = null;
                                      }
                                    },
                                    icon: const Icon(Icons.download),
                                    label: Text(
                                      S.of(context).download_ai_model,
                                    ),
                                  ),
                                ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // AI機能設定
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).ai_features,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // リアクション提案
                    SwitchListTile(
                      value: settings.isReactionSuggestionEnabled,
                      onChanged: (value) {
                        ref
                            .read(aiSettingsRepositoryProvider.notifier)
                            .setReactionSuggestionEnabled(value);
                      },
                      title: Text(S.of(context).ai_reaction_suggestion),
                      subtitle: Text(
                        S.of(context).ai_reaction_suggestion_description,
                      ),
                      secondary: const Icon(Icons.thumb_up),
                    ),

                    const Divider(),

                    // 翻訳機能
                    SwitchListTile(
                      value: settings.isTranslationEnabled,
                      onChanged: (value) {
                        ref
                            .read(aiSettingsRepositoryProvider.notifier)
                            .setTranslationEnabled(value);
                      },
                      title: Text(S.of(context).ai_translation),
                      subtitle: Text(S.of(context).ai_translation_description),
                      secondary: const Icon(Icons.translate),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 詳細設定
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tune, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).ai_advanced_settings,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 温度設定
                    Text(
                      "${S.of(context).ai_temperature}: ${settings.temperature.toStringAsFixed(1)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: settings.temperature,
                      min: 0.1,
                      max: 2.0,
                      divisions: 19,
                      onChanged: (value) {
                        ref
                            .read(aiSettingsRepositoryProvider.notifier)
                            .setTemperature(value);
                      },
                    ),
                    Text(
                      S.of(context).ai_temperature_description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: 16),

                    // 最大トークン数
                    Text(
                      "${S.of(context).ai_max_tokens}: ${settings.maxTokens}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: settings.maxTokens.toDouble(),
                      min: 50,
                      max: 500,
                      divisions: 9,
                      onChanged: (value) {
                        ref
                            .read(aiSettingsRepositoryProvider.notifier)
                            .setMaxTokens(value.round());
                      },
                    ),
                    Text(
                      S.of(context).ai_max_tokens_description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
