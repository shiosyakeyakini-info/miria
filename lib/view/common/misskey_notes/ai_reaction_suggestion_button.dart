import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/ai_settings.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/repository/ai_repository.dart";
import "package:miria/repository/ai_settings_repository.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

class AiReactionSuggestionButton extends HookConsumerWidget {
  final Note note;
  final Function(MisskeyEmojiData)? onReactionSelected;

  const AiReactionSuggestionButton({
    required this.note,
    this.onReactionSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettings = ref.watch(aiSettingsRepositoryProvider);
    final isLoading = useState(false);
    final suggestions = useState<List<String>>([]);
    final isExpanded = useState(false);

    // AI機能が無効の場合は表示しない
    if (!aiSettings.maybeWhen(
      data: (settings) => settings.isReactionSuggestionEnabled,
      orElse: () => false,
    )) {
      return const SizedBox.shrink();
    }

    Future<void> getSuggestions() async {
      if (isLoading.value) return;

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
          text: note.text ?? "",
          featureType: AiFeatureType.reactionSuggestion,
          context: '${note.user.name}: ${note.text ?? ''}',
        );

        final result = await aiRepo.generateText(request);

        if (result.isSuccess) {
          // 結果をパースしてリアクション候補を抽出
          final reactionList = result.text
              .split(" ")
              .where((emoji) => emoji.trim().isNotEmpty)
              .take(5)
              .toList();

          suggestions.value = reactionList;
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
        // AI提案ボタン
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: getSuggestions,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.of(context).reactionButtonBackgroundColor,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
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
                      Icons.auto_awesome,
                      size: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  const SizedBox(width: 4),
                  Text(
                    "AI",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),

        // AI提案されたリアクション一覧
        if (isExpanded.value && suggestions.value.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.of(
                context,
              ).reactionButtonBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.of(context).reactionButtonBackgroundColor,
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final emoji in suggestions.value)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Unicode絵文字として処理
                        final emojiData = UnicodeEmojiData(char: emoji);
                        onReactionSelected?.call(emojiData);

                        // 提案を閉じる
                        isExpanded.value = false;
                        suggestions.value = [];
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                // 閉じるボタン
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      isExpanded.value = false;
                      suggestions.value = [];
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
