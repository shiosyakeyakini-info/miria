import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";

/// 通知アイコン
class NotificationIcon extends ConsumerWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acct = ref.watch(
      accountContextProvider.select((value) => value.postAccount.acct),
    );
    final hasUnread = ref.watch(
      iProvider(acct).select((value) => value.hasUnreadNotification),
    );

    if (hasUnread) {
      return IconButton(
        onPressed: () async => context.pushRoute(
          NotificationRoute(
            accountContext: ref.read(accountContextProvider),
          ),
        ),
        icon: Stack(
          children: [
            const Icon(Icons.notifications),
            Transform.translate(
              offset: const Offset(12, 12),
              child: SizedBox(
                width: 14,
                height: 14,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return IconButton(
        onPressed: () async => context.pushRoute(
          NotificationRoute(
            accountContext: ref.read(accountContextProvider),
          ),
        ),
        icon: const Icon(Icons.notifications),
      );
    }
  }
}
