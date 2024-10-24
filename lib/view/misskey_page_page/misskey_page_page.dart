import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:mfm_parser/mfm_parser.dart" hide MfmText;
import "package:miria/extensions/list_mfm_node_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/constants.dart";
import "package:miria/view/common/image_dialog.dart";
import "package:miria/view/common/misskey_notes/link_preview.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/misskey_page_page/misskey_page_notifier.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart" as misskey;
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:url_launcher/url_launcher.dart";

part "misskey_page_page.g.dart";

@RoutePage()
class MisskeyPagePage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final misskey.Page page;

  const MisskeyPagePage({
    required this.accountContext,
    required this.page,
    super.key,
  });
  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).page)),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  MfmText(
                    mfmText: page.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  MfmText(
                    mfmText: page.summary ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(),
                  if (page.eyeCatchingImage != null)
                    NetworkImageView(
                      url: page.eyeCatchingImage!.url,
                      type: ImageType.image,
                    ),
                  for (final content in page.content)
                    PageContent(content: content, page: page),
                  const Divider(),
                  Text(S.of(context).pageWrittenBy),
                  UserListItem(user: page.user),
                  Row(
                    children: [
                      PageLikeButton(
                        initialLiked: page.isLiked ?? false,
                        likeCount: page.likedCount,
                        pageId: page.id,
                        userId: page.userId,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      GestureDetector(
                        onTap: () async => launchUrl(
                          Uri(
                            scheme: "https",
                            host: accountContext.getAccount.host,
                            pathSegments: [
                              "@${page.user.username}",
                              "pages",
                              page.name,
                            ],
                          ),
                        ),
                        child: Text(
                          S.of(context).openBrowsers,
                          style: AppTheme.of(context).linkStyle,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(S.of(context).pageCreatedAt(page.createdAt)),
                        Text(S.of(context).pageUpdatedAt(page.updatedAt)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@Riverpod(dependencies: [misskeyGetContext, notesWith])
Future<Note> fetchNote(FetchNoteRef ref, String noteId) async {
  final note = await ref
      .read(misskeyGetContextProvider)
      .notes
      .show(misskey.NotesShowRequest(noteId: noteId));
  ref.read(notesWithProvider).registerNote(note);
  return note;
}

class PageContent extends ConsumerWidget {
  final misskey.AbstractPageContent content;
  final misskey.Page page;
  const PageContent({
    required this.content,
    required this.page,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = this.content;
    if (content case misskey.PageText(:final text?)) {
      final account = ref.read(accountContextProvider).getAccount;
      final nodes = const MfmParser().parse(text);
      return Column(
        children: [
          MfmText(
            mfmNode: nodes,
          ),
          ...nodes.extractLinks().map(
                (link) => LinkPreview(
                  account: account,
                  link: link,
                  host: account.host,
                ),
              ),
        ],
      );
    }
    if (content case misskey.PageImage(:final fileId?)) {
      final file = page.attachedFiles.firstWhereOrNull((e) => e.id == fileId);
      if (file != null) {
        final url = file.url;

        final thumbnailUrl = page.attachedFiles
            .firstWhereOrNull((e) => e.id == content.fileId)
            ?.thumbnailUrl;
        return GestureDetector(
          onTap: () async => showDialog(
            context: context,
            builder: (context) =>
                ImageDialog(driveFiles: [file], initialPage: 0),
          ),
          child: NetworkImageView(
            url: thumbnailUrl ?? url,
            type: ImageType.image,
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }
    if (content case misskey.PageNote(note: final noteId?)) {
      final note = ref.watch(fetchNoteProvider(noteId));
      return switch (note) {
        AsyncLoading() => const Center(
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        AsyncError() => Text(S.of(context).thrownError),
        AsyncData(:final value) => MisskeyNote(note: value)
      };
    }
    if (content is misskey.PageSection) {
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            MfmText(
              mfmText: content.title ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final child in content.children)
              PageContent(content: child, page: page),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(S.of(context).unsupportedPage),
            ),
          ],
        ),
      ),
    );
  }
}

class PageLikeButton extends ConsumerWidget {
  final bool initialLiked;
  final int likeCount;
  final String pageId;
  final String userId;

  const PageLikeButton({
    required this.initialLiked,
    required this.likeCount,
    required this.pageId,
    required this.userId,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = misskeyPageNotifierProvider(pageId);
    final liked = ref.watch(
      provider.select((value) => value.valueOrNull?.page.isLiked ?? false),
    );
    final likeCount = ref.watch(
      provider.select((value) => value.valueOrNull?.page.likedCount ?? 0),
    );
    final isLoading = ref.watch(
      provider.select((value) => value.valueOrNull?.likeOr is AsyncLoading),
    );

    if (liked) {
      return ElevatedButton.icon(
        onPressed:
            isLoading ? null : () async => ref.read(provider.notifier).likeOr(),
        icon: Icon(
          Icons.favorite,
          size: MediaQuery.textScalerOf(context)
              .scale(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 22),
        ),
        label: Text(likeCount.format()),
      );
    } else {
      return OutlinedButton.icon(
        onPressed:
            isLoading ? null : () async => ref.read(provider.notifier).likeOr(),
        icon: Icon(
          Icons.favorite,
          size: MediaQuery.textScalerOf(context)
              .scale(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 22),
        ),
        label: Text(likeCount.format()),
      );
    }
  }
}
