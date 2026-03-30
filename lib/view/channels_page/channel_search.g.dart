// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ChannelSearchQuery)
const channelSearchQueryProvider = ChannelSearchQueryProvider._();

final class ChannelSearchQueryProvider
    extends $NotifierProvider<ChannelSearchQuery, String> {
  const ChannelSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'channelSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$channelSearchQueryHash();

  @$internal
  @override
  ChannelSearchQuery create() => ChannelSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$channelSearchQueryHash() =>
    r'7caac77cafb2692d4d31c4fe05fcb26e68cc367b';

abstract class _$ChannelSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
