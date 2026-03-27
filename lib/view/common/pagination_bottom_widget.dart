import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/pagination_state.dart";
import "package:miria/view/common/error_detail.dart";

class PaginationBottomWidget<T> extends StatelessWidget {
  const PaginationBottomWidget({
    required this.paginationState,
    super.key,
    this.noItemsLabel,
    this.loadMore,
  });

  final AsyncValue<PaginationState<T>> paginationState;
  final String? noItemsLabel;
  final void Function()? loadMore;

  @override
  Widget build(BuildContext context) {
    final value = paginationState.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (paginationState.error != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ErrorDetail(
              error: paginationState.error,
              stackTrace: paginationState.stackTrace,
            ),
          ),
        if (paginationState.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        else if (value == null || !value.isLastLoaded)
          IconButton(
            onPressed: loadMore != null ? () => loadMore!() : null,
            icon: const Icon(Icons.keyboard_arrow_down),
          )
        else if (noItemsLabel case final noItemsLabel? when value.items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(noItemsLabel),
          ),
      ],
    );
  }
}
