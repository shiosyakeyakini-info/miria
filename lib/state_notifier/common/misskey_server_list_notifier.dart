import "package:collection/collection.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "misskey_server_list_notifier.g.dart";

@riverpod
Future<List<JoinMisskeyInstanceInfo>> _instanceInfos(Ref ref) async {
  final response = await JoinMisskey(
    host: "instanceapp.misskey.page",
  ).instances();
  return response.instancesInfos
      .sortedByCompare(
        (info) => info.nodeInfo?.usage?.users?.total ?? 0,
        (a, b) => a.compareTo(b),
      )
      .reversed
      .toList();
}

@riverpod
class MisskeyServerListNotifier extends _$MisskeyServerListNotifier {
  String _query = "";

  @override
  Future<List<JoinMisskeyInstanceInfo>> build() async {
    final instances = await ref.watch(_instanceInfosProvider.future);
    if (_query.isEmpty) {
      return instances;
    }
    final filtered = instances.where(
      (e) => e.name.toLowerCase().contains(_query) || e.url.contains(_query),
    );
    final grouped = filtered.groupListsBy(
      (e) =>
          e.name.toLowerCase().startsWith(_query) || e.url.startsWith(_query),
    );
    return [...grouped[true] ?? [], ...grouped[false] ?? []];
  }

  void setQuery(String query) {
    _query = query.trim().toLowerCase();
    ref.invalidateSelf();
  }
}
