import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class FutureListView<T> extends StatelessWidget {
  final Future<Iterable<T>> future;
  final Widget Function(BuildContext, T) builder;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const FutureListView({
    required this.future,
    required this.builder,
    super.key,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;
          if (data == null) {
            if (kDebugMode) {
              print(snapshot.error);
              print(snapshot.stackTrace);
            }
            return Text("${S.of(context).thrownError}\n${snapshot.error}");
          }
          final list = data.toList();

          return ListView.builder(
            shrinkWrap: shrinkWrap,
            physics: physics,
            itemCount: data.length,
            itemBuilder: (context, index) => builder(context, list[index]),
          );
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
            print(snapshot.stackTrace);
          }
          return Text("${S.of(context).thrownError}： ${snapshot.error}");
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}
