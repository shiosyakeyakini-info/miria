import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/constants.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/image_dialog.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:miria/view/user_page/user_list_item.dart';
import 'package:misskey_dart/misskey_dart.dart' as misskey;
import 'package:miria/view/common/account_scope.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class MisskeyPagePage extends ConsumerWidget {
  final Account account;
  final misskey.Page page;

  const MisskeyPagePage({
    super.key,
    required this.account,
    required this.page,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
        account: account,
        child: Scaffold(
          appBar: AppBar(title: const Text("ページ")),
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
                          style: Theme.of(context).textTheme.headlineSmall),
                      MfmText(
                          mfmText: page.summary ?? "",
                          style: Theme.of(context).textTheme.bodySmall),
                      const Divider(),
                      if (page.eyeCatchingImage != null)
                        NetworkImageView(
                            url: page.eyeCatchingImage!.url,
                            type: ImageType.image),
                      for (final content in page.content)
                        PageContent(content: content, page: page),
                      const Divider(),
                      const Text("このページ書きはった人"),
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
                            onTap: () => launchUrl(Uri(
                                scheme: "https",
                                host: account.host,
                                pathSegments: [
                                  "@${page.user.username}",
                                  "pages",
                                  page.name
                                ])),
                            child: Text(
                              "ブラウザで表示する",
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
                            Text("作成日: ${page.createdAt.format}"),
                            Text("更新日: ${page.updatedAt.format}")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class PageContent extends ConsumerWidget {
  final misskey.AbstractPageContent content;
  final misskey.Page page;
  const PageContent({
    super.key,
    required this.content,
    required this.page,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = this.content;
    if (content is misskey.PageText) {
      return MfmText(mfmText: content.text);
    }
    if (content is misskey.PageImage) {
      final url = page.attachedFiles
          .firstWhereOrNull((e) => e.id == content.fileId)
          ?.url;
      final thumbnailUrl = page.attachedFiles
          .firstWhereOrNull((e) => e.id == content.fileId)
          ?.thumbnailUrl;
      if (url != null) {
        return GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (context) =>
                    ImageDialog(imageUrlList: [url], initialPage: 0)),
            child: NetworkImageView(
                url: thumbnailUrl ?? url, type: ImageType.image));
      } else {
        return const SizedBox.shrink();
      }
    }
    if (content is misskey.PageNote) {
      return FutureBuilder(future: (() async {
        final account = AccountScope.of(context);
        final note = await ref
            .read(misskeyProvider(account))
            .notes
            .show(misskey.NotesShowRequest(noteId: content.note));
        ref.read(notesProvider(account)).registerNote(note);
        return note;
      })(), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return MisskeyNote(note: snapshot.data!);
        } else if (snapshot.hasError) {
          return const Text("エラーが起きたみたいや");
        } else {
          return const Center(
            child: SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator()),
          );
        }
      });
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
                  style: Theme.of(context).textTheme.titleLarge),
              for (final child in content.children)
                PageContent(content: child, page: page)
            ]),
      );
    }

    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Miriaが対応していないページやわ　ブラウザで見てな"),
          ),
        ]),
      ),
    );
  }
}

class PageLikeButton extends ConsumerStatefulWidget {
  final bool initialLiked;
  final int likeCount;
  final String pageId;
  final String userId;

  const PageLikeButton({
    super.key,
    required this.initialLiked,
    required this.likeCount,
    required this.pageId,
    required this.userId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PageLikeButtonState();
}

class PageLikeButtonState extends ConsumerState<PageLikeButton> {
  late bool liked = widget.initialLiked;
  late int likeCount = widget.likeCount;

  @override
  Widget build(BuildContext context) {
    if (liked) {
      return ElevatedButton.icon(
        onPressed: () async {
          await ref
              .read(misskeyProvider(AccountScope.of(context)))
              .pages
              .unlike(misskey.PagesUnlikeRequest(pageId: widget.pageId));
          setState(() {
            liked = false;
            likeCount--;
          });
        }.expectFailure(context),
        icon: Icon(Icons.favorite,
            size: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 22) *
                MediaQuery.of(context).textScaleFactor),
        label: Text(likeCount.format()),
      );
    } else {
      return OutlinedButton.icon(
          onPressed: () async {
            if (AccountScope.of(context).i.id == widget.userId) {
              SimpleMessageDialog.show(context, "自分のページにはふぁぼつけられへんねん");
              return;
            }
            await ref
                .read(misskeyProvider(AccountScope.of(context)))
                .pages
                .like(misskey.PagesLikeRequest(pageId: widget.pageId));
            setState(() {
              liked = true;
              likeCount++;
            });
          }.expectFailure(context),
          icon: Icon(Icons.favorite,
              size: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 22) *
                  MediaQuery.of(context).textScaleFactor),
          label: Text(likeCount.format()));
    }
  }
}
