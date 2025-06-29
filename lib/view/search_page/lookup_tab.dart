import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:misskey_dart/misskey_dart.dart";

class LookupTab extends HookConsumerWidget {
  final FocusNode focusNode;

  const LookupTab({required this.focusNode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    Future<void> performLookup() async {
      final query = controller.text.trim();
      if (query.isEmpty) return;

      isLoading.value = true;
      errorMessage.value = null;

      try {
        final accountContext = ref.read(accountContextProvider);
        final lookupRepository = ref.read(
          lookupRepositoryProvider(accountContext.postAccount),
        );
        final result = await lookupRepository.lookup(query);

        if (result != null) {
          final type = result["type"] as String?;
          final object = result["object"];

          if (type == "User" && object is User) {
            if (context.mounted) {
              context.pushRoute(
                UserRoute(userId: object.id, accountContext: accountContext),
              );
            }
          } else if (type == "Note" && object is Note) {
            if (context.mounted) {
              context.pushRoute(
                NoteDetailRoute(note: object, accountContext: accountContext),
              );
            }
          } else {
            errorMessage.value = "未知のオブジェクトです";
          }
        } else {
          errorMessage.value = "照会に失敗しました";
        }
      } catch (e) {
        errorMessage.value = "照会に失敗しました";
      } finally {
        isLoading.value = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "URLやアカウント名からユーザーやノートを照会できます",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: "URL、アカウント名、またはノートID",
              hintText: "@ai@misskey.io やhttps://... を入力",
              border: const OutlineInputBorder(),
              suffixIcon: isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      onPressed: performLookup,
                      icon: const Icon(Icons.search),
                    ),
            ),
            onSubmitted: (_) => performLookup(),
            enabled: !isLoading.value,
          ),
          if (errorMessage.value != null) ...[
            const SizedBox(height: 8),
            Text(
              errorMessage.value!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            "入力例:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "• https://misskey.io/@ai",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            "• @ai@misskey.io",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            "• https://misskey.io/notes/abc123",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text("• abc123def456", style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
