// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_timeline_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(misskeyStreaming)
const misskeyStreamingProvider = MisskeyStreamingFamily._();

final class MisskeyStreamingProvider
    extends
        $FunctionalProvider<
          AsyncValue<StreamingController>,
          FutureOr<StreamingController>
        >
    with
        $FutureModifier<StreamingController>,
        $FutureProvider<StreamingController> {
  const MisskeyStreamingProvider._({
    required MisskeyStreamingFamily super.from,
    required Misskey super.argument,
  }) : super(
         retry: null,
         name: r'misskeyStreamingProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$misskeyStreamingHash();

  @override
  String toString() {
    return r'misskeyStreamingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<StreamingController> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StreamingController> create(Ref ref) {
    final argument = this.argument as Misskey;
    return misskeyStreaming(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MisskeyStreamingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$misskeyStreamingHash() => r'b639ff4b308b410ee3f8b9c702097451dfe4fc02';

final class MisskeyStreamingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StreamingController>, Misskey> {
  const MisskeyStreamingFamily._()
    : super(
        retry: null,
        name: r'misskeyStreamingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  MisskeyStreamingProvider call(Misskey misskey) =>
      MisskeyStreamingProvider._(argument: misskey, from: this);

  @override
  String toString() => r'misskeyStreamingProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
