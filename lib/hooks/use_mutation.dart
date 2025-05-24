// import "dart:async";

// import "package:riverpod_annotation/experimental/mutation.dart";
// import "package:riverpod_annotation/riverpod_annotation.dart";

// class MutationOperation<T2, T extends MutationBase<T2>> {
//   final T mutation;

//   FutureOr<void> Function(T mutation) callee;

//   FutureOr<void>? onPressed() {
//     if (mutation is PendingMutation) {
//       return null;
//     }
//     return callee(mutation);
//   }

//   MutationOperation(this.mutation, this.callee);
// }

// MutationOperation<T2, T> useMutation<T2, T extends MutationBase<T2>>(
//   ProviderListenable<MutationBase<T2>> mutationProvider,
//   void Function(T mutation) callee,
// ) {

//   return MutationOperation(mutation, callee);
// }
