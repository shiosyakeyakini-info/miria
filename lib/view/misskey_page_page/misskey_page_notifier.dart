import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "misskey_page_notifier.freezed.dart";
part "misskey_page_notifier.g.dart";

@freezed
class MisskeyPageNotifierState with _$MisskeyPageNotifierState {
  const factory MisskeyPageNotifierState({
    required Page page,
    AsyncValue<void>? likeOr,
  }) = _MisskeyPageNotifierState;
}

@Riverpod(dependencies: [accountContext, misskeyGetContext, misskeyPostContext])
class MisskeyPageNotifier extends _$MisskeyPageNotifier {
  @override
  Future<MisskeyPageNotifierState> build(String pageId) async {
    return MisskeyPageNotifierState(
      page: await ref
          .read(misskeyGetContextProvider)
          .pages
          .show(PagesShowRequest(pageId: pageId)),
    );
  }

  Future<void> likeOr() async {
    final before = await future;

    if (ref.read(accountContextProvider).postAccount.i.id ==
        before.page.userId) {
      await ref.read(dialogStateNotifierProvider.notifier).showSimpleDialog(
            message: (context) => S.of(context).canNotFavoriteMyPage,
          );
      return;
    }
    state = AsyncData(before.copyWith(likeOr: const AsyncLoading()));
    final likeOrResult =
        await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      if (before.page.isLiked ?? false) {
        await ref
            .read(misskeyPostContextProvider)
            .pages
            .unlike(PagesUnlikeRequest(pageId: pageId));
        state = AsyncData(
          before.copyWith(
            page: before.page.copyWith(
              isLiked: false,
              likedCount: before.page.likedCount - 1,
            ),
          ),
        );
      } else {
        await ref
            .read(misskeyPostContextProvider)
            .pages
            .like(PagesLikeRequest(pageId: pageId));
        state = AsyncData(
          before.copyWith(
            page: before.page.copyWith(
              isLiked: true,
              likedCount: before.page.likedCount + 1,
            ),
          ),
        );
      }
    });
    state = AsyncData((await future).copyWith(likeOr: likeOrResult));
  }
}
