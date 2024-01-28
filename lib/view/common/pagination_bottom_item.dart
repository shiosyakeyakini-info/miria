import 'package:flutter/material.dart';
import 'package:miria/model/pagination_state.dart';

class PaginationBottomItem<T> extends StatelessWidget {
  const PaginationBottomItem({
    super.key,
    required this.paginationState,
    this.noItemsLabel,
    this.child,
  });

  final PaginationState<T> paginationState;
  final Widget? noItemsLabel;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (paginationState.isLoading) {
      return const CircularProgressIndicator();
    }
    if (paginationState.isLastLoaded) {
      if (paginationState.isEmpty) {
        return noItemsLabel ?? const SizedBox.shrink();
      } else {
        return const SizedBox.shrink();
      }
    }
    return child ?? const SizedBox.shrink();
  }
}
