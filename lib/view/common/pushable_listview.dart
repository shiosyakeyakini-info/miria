import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushableListView<T> extends ConsumerStatefulWidget {
  final Future<List<T>> Function() initializeFuture;
  final Future<List<T>> Function(dynamic) nextFuture;
  final Widget Function(BuildContext, dynamic) itemBuilder;

  const PushableListView({
    super.key,
    required this.initializeFuture,
    required this.nextFuture,
    required this.itemBuilder,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      PushableListViewState();
}

class PushableListViewState<T> extends ConsumerState<PushableListView<T>> {
  var isLoading = false;
  var isFinalPage = false;

  final items = <T>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (items.isEmpty) {
      isLoading = true;
      Future(() async {
        items
          ..clear()
          ..addAll(await widget.initializeFuture());
        setState(() {
          isLoading = false;
        });
      });
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

          return Center(
            child: !isLoading
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        Future(() async {
                          final result = await widget.nextFuture(items.last);
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
          );
        }
        return widget.itemBuilder(context, items[index]);
      },
    );
  }
}
