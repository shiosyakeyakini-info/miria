import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/ai_settings.dart";
import "package:miria/repository/ai_repository.dart";
import "package:miria/repository/ai_settings_repository.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

class AiTranslationButton extends HookConsumerWidget {
  final Note note;

  const AiTranslationButton({required this.note, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettings = ref.watch(aiSettingsRepositoryProvider);
    final isLoading = useState(false);
    final translatedText = useState<String?>(null);
    final isExpanded = useState(false);

    // AI機能が無効の場合は表示しない
    if (!aiSettings.maybeWhen(
      data: (settings) => settings.isTranslationEnabled,
      orElse: () => false,
    )) {
      return const SizedBox.shrink();
    }

    // テキストがない場合は表示しない
    if (note.text == null || note.text!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    Future<void> translateText() async {
      if (isLoading.value) return;

      // 既に翻訳済みの場合はトグル
      if (translatedText.value != null) {
        isExpanded.value = !isExpanded.value;
        return;
      }

      isLoading.value = true;
      try {
        final aiRepo = ref.read(aiRepositoryProvider);

        // モデルが初期化されていない場合は初期化
        if (!await aiRepo.isModelAvailable()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).ai_model_not_downloaded),
              action: SnackBarAction(
                label: S.of(context).download,
                onPressed: () {
                  // TODO: モデルダウンロード画面に遷移
                },
              ),
            ),
          );
          return;
        }

        await aiRepo.initializeModel();

        final request = AiInferenceRequest(
          text: note.text!,
          featureType: AiFeatureType.translation,
          context: "Translate the following text to Japanese",
        );

        final result = await aiRepo.generateText(request);

        if (result.isSuccess) {
          translatedText.value = result.text;
          isExpanded.value = true;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("AI error: ${result.error}")));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 翻訳ボタン
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: translateText,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading.value)
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(
                      Icons.translate,
                      size: 12,
                      color: translatedText.value != null
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  const SizedBox(width: 4),
                  Text(
                    translatedText.value != null
                        ? (isExpanded.value
                              ? S.of(context).hide
                              : S.of(context).show)
                        : S.of(context).translate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: translatedText.value != null
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 翻訳結果
        if (isExpanded.value && translatedText.value != null)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.of(
                context,
              ).reactionButtonBackgroundColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.of(context).reactionButtonBackgroundColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      S.of(context).ai_translation,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SelectableText(
                  translatedText.value!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
