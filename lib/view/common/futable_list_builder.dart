import 'dart:async';

import 'package:flutter/material.dart';

class FutureListView<T> extends StatefulWidget {
  final Future<Iterable<T>> future;
  final Widget Function(BuildContext, T) builder;

  const FutureListView({
    super.key,
    required this.future,
    required this.builder,
  });

  @override
  State<StatefulWidget> createState() => FutureListViewState<T>();
}

class FutureListViewState<T> extends State<FutureListView<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<T>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;
          if (data == null) {
            print(snapshot.error);
            print(snapshot.stackTrace);
            return const Text("エラー： データなし");
          }
          final list = data.toList();

          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  widget.builder(context, list[index]));
        } else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          return Text("エラー： ${snapshot.error}");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
