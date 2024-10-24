import "package:collection/collection.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "misskey_server_list_notifier.g.dart";

final _queryProvider = StateProvider.autoDispose((ref) {
  return "";
});

final _instanceInfosProvider = AsyncNotifierProvider.autoDispose<_InstanceInfos,
    List<JoinMisskeyInstanceInfo>>(
  _InstanceInfos.new,
);

class _InstanceInfos
    extends AutoDisposeAsyncNotifier<List<JoinMisskeyInstanceInfo>> {
  @override
  Future<List<JoinMisskeyInstanceInfo>> build() async {
    final response =
        await JoinMisskey(host: "instanceapp.misskey.page").instances();
    return response.instancesInfos
        .sortedByCompare(
          (info) => info.nodeInfo?.usage?.users?.total ?? 0,
          (a, b) => a.compareTo(b),
        )
        .reversed
        .toList();
  }
}

@riverpod
class MisskeyServerListNotifier extends _$MisskeyServerListNotifier {
  @override
  Future<List<JoinMisskeyInstanceInfo>> build() async {
    final query = ref.watch(_queryProvider);
    final instances = await ref.watch(_instanceInfosProvider.future);
    if (query.isEmpty) {
      return instances;
    }
    final filtered = instances.where(
      (e) => e.name.toLowerCase().contains(query) || e.url.contains(query),
    );
    final grouped = filtered.groupListsBy(
      (e) => e.name.toLowerCase().startsWith(query) || e.url.startsWith(query),
    );
    return [...grouped[true] ?? [], ...grouped[false] ?? []];
  }

  void setQuery(String query) {
    ref.read(_queryProvider.notifier).state = query.trim().toLowerCase();
  }
}
