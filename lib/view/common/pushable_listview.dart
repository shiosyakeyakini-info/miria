import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/error_notification.dart";
import "package:miria/view/common/misskey_ad.dart";

class PushableListView<T> extends HookConsumerWidget {
  final Future<List<T>> Function() initializeFuture;
  final Future<List<T>> Function(T, int) nextFuture;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, Object?)? additionalErrorInfo;
  final Object listKey;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool showAd;
  final bool hideIsEmpty;

  const PushableListView({
    required this.initializeFuture,
    required this.nextFuture,
    required this.itemBuilder,
    super.key,
    this.listKey = "",
    this.shrinkWrap = false,
    this.physics,
    this.additionalErrorInfo,
    this.showAd = true,
    this.hideIsEmpty = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final error = useState<(Object?, StackTrace)?>(null);
    final isFinalPage = useState(false);
    final scrollController = useScrollController();
    final items = useState<List<T>>([]);

    final initialize = useCallback(
      () async {
        isLoading.value = true;
        isFinalPage.value = false;
        items.value = [];
        try {
          final initialItems = await initializeFuture();
          items.value = initialItems;
          isLoading.value = false;
          await scrollController.animateTo(
            -scrollController.position.pixels,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn,
          );
        } catch (e, s) {
          if (kDebugMode) print(e);
          error.value = (e, s);
          isLoading.value = false;
        }
      },
      [initializeFuture, scrollController, listKey],
    );

    useMemoized(
      () => unawaited(initialize()),
      [listKey],
    );

    final nextLoad = useCallback(
      () async {
        if (isLoading.value || items.value.isEmpty) return;
        isLoading.value = true;
        try {
          final result = await nextFuture(items.value.last, items.value.length);
          if (result.isEmpty) isFinalPage.value = true;
          items.value = [...items.value, ...result];
          isLoading.value = false;
        } catch (e) {
          isLoading.value = false;
        }
      },
      [isLoading.value, items.value, nextFuture],
    );

    return RefreshIndicator(
      onRefresh: () async {
        items.value.clear();
        isLoading.value = true;
        await initialize();
      },
      child: ListView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemCount: items.value.length + 1,
        controller: scrollController,
        itemBuilder: (context, index) {
          if (items.value.length == index) {
            if (isFinalPage.value) {
              return Container();
            }
            if (isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            if (error.value != null) {
              return ErrorDetail(
                error: error.value!.$1,
                stackTrace: error.value!.$2,
              );
            }

            if (items.value.isEmpty && !hideIsEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("なんもないで"),
                ),
              );
            }

            if (ref.read(
                  generalSettingsRepositoryProvider
                      .select((value) => value.settings.automaticPush),
                ) ==
                AutomaticPush.automatic) {
              unawaited(nextLoad());
            }

            return Column(
              children: [
                if (error.value != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ErrorNotification(
                        error: error.value?.$1,
                        stackTrace: error.value?.$2,
                      ),
                      additionalErrorInfo?.call(context, error.value) ??
                          const SizedBox.shrink(),
                    ],
                  ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: IconButton(
                      onPressed: nextLoad,
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ),
              ],
            );
          }

          if (index != 0 && (index == 3 || index % 30 == 0) && showAd) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                itemBuilder(context, items.value[index]),
                const MisskeyAd(),
              ],
            );
          } else {
            return itemBuilder(context, items.value[index]);
          }
        },
      ),
    );
  }
}
