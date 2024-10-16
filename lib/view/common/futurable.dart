import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:miria/view/common/error_notification.dart";

class CommonFuture<T> extends StatelessWidget {
  final Future<T> future;
  final Function(T)? futureFinished;
  final Widget Function(BuildContext, T) complete;

  const CommonFuture({
    required this.future,
    required this.complete,
    super.key,
    this.futureFinished,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: () async {
        final result = await future;
        futureFinished?.call(result);
        return result;
      }(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
            print(snapshot.stackTrace);
          }
          return ErrorNotification(
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return complete(context, snapshot.data as T);
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
