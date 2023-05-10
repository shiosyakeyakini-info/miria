import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/view/common/error_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushableListView<T> extends ConsumerStatefulWidget {
  final Future<List<T>> Function() initializeFuture;
  final Future<List<T>> Function(T) nextFuture;
  final Widget Function(BuildContext, T) itemBuilder;
  final Object listKey;

  const PushableListView(
      {super.key,
      required this.initializeFuture,
      required this.nextFuture,
      required this.itemBuilder,
      this.listKey = ""});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      PushableListViewState<T>();
}

class PushableListViewState<T> extends ConsumerState<PushableListView<T>> {
  var isLoading = false;
  Object? error;
  var isFinalPage = false;

  final items = <T>[];

  void initialize() {
    isLoading = true;
    Future(() async {
      try {
        items
          ..clear()
          ..addAll(await widget.initializeFuture());
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          error = e;
        });
        rethrow;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (items.isEmpty) {
      initialize();
    }
  }

  @override
  void didUpdateWidget(covariant PushableListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listKey != widget.listKey) {
      initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (items.length == index) {
          if (isFinalPage) {
            return Container();
          }

          return Column(
            children: [
              if (error != null)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).dividerColor)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "エラーが発生しました",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ErrorDetail(error: error)
                        ],
                      ),
                    ),
                  ),
                ),
              Center(
                child: !isLoading
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            Future(() async {
                              final result =
                                  await widget.nextFuture(items.last);
                              if (result.isEmpty) isFinalPage = true;
                              items.addAll(result);
                              setState(() {
                                isLoading = false;
                              });
                            });
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator()),
              )
            ],
          );
        }
        return widget.itemBuilder(context, items[index]);
      },
    );
  }
}
