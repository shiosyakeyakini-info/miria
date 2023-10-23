import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_state.freezed.dart';

@freezed
class PaginationState<T> extends Iterable<T> with _$PaginationState<T> {
  const factory PaginationState({
    @Default([]) List<T> items,
    @Default(false) bool isLoading,
    @Default(false) bool isLastLoaded,
  }) = _PaginationState;
  const PaginationState._();

  @override
  Iterator<T> get iterator => items.iterator;

  T operator [](int i) => items[i];
}
