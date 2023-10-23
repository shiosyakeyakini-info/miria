import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';

class Breadcrumbs extends ConsumerWidget {
  const Breadcrumbs({
    super.key,
    required this.account,
    this.color = Colors.white,
  });

  final Account account;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breadcrumbs = ref.watch(
      drivePageNotifierProvider.select((state) => state.breadcrumbs),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // ネストが深くなったときに現在のフォルダを表示するため
      reverse: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: breadcrumbs.isNotEmpty
                  ? () => ref
                      .read(drivePageNotifierProvider.notifier)
                      .popUntil(null)
                  : null,
              icon: Icon(
                Icons.cloud,
                color: breadcrumbs.isNotEmpty ? color.withOpacity(0.8) : color,
              ),
            ),
          ),
          for (final folder in breadcrumbs) ...[
            Icon(Icons.keyboard_arrow_right, color: color.withOpacity(0.4)),
            TextButton(
              onPressed: folder.id != breadcrumbs.lastOrNull?.id
                  ? () => ref
                      .read(drivePageNotifierProvider.notifier)
                      .popUntil(folder.id)
                  : null,
              style: TextButton.styleFrom(
                foregroundColor: color.withOpacity(0.8),
                disabledForegroundColor: color,
              ),
              child: Text(folder.name),
            ),
          ],
        ],
      ),
    );
  }
}
