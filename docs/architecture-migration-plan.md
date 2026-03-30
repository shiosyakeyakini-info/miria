# アーキテクチャ移行計画: Atomic Provider パターンへ

## 設計原則

1. **高凝縮**: ページとそのNotifierは同じファイルに置く。別ファイルに分ける理由がない限り同居
2. **最小限のNotifier**: `keepAlive: true`の単純providerで済むものはNotifier化しない
3. **Selectorパターン**: ノート投稿は部品ごとに独立したprovider、`ref.watch`で寄せ集め。タイムラインは部品の一部だけを使う
4. **Riverpod 3.0 Storage**: Settings系は`riverpod_shared_preferences`の`persist()`で自動永続化。手動のSharedPreferences読み書きを廃止

## 現状分析

| パターン | ファイル数 | 状態 |
|---|---|---|
| `ChangeNotifierProvider` (Repository) | 8クラス | **要移行（最重要）** |
| `StateNotifierProvider` 使用箇所 | 44ファイル | **要移行** |
| `@riverpod` (モダン) | 53ファイル | 既にAtomic寄り |
| `StateProvider` | 11箇所 | 軽微な移行 |
| 中央集権 `providers.dart` | 302行 | **要分割** |

### ChangeNotifier Repository 一覧（8クラス）

- `GeneralSettingsRepository` - SharedPreferencesで`GeneralSettings`を読み書き
- `AccountSettingsRepository` - SharedPreferencesで`AccountSettings`を読み書き
- `TabSettingsRepository` - SharedPreferencesで`List<TabSetting>`を読み書き
- `DesktopSettingsRepository` - SharedPreferencesで`DesktopSettings`を読み書き
- `NoteRepository` - ノートキャッシュ + ノートUI状態 + ミュートワード判定
- `FavoriteRepository` - お気に入り管理
- `ImportExportRepository` - 設定のインポート/エクスポート
- `TimelineRepository` - タイムラインの基底クラス（9つの具象クラスあり）

---

## Phase 1: 基盤整備 + Settings の Storage 移行

### 1-1. `riverpod_shared_preferences` を依存に追加

```yaml
# pubspec.yaml
dependencies:
  riverpod_shared_preferences: ^0.0.3
```

### 1-2. Storage コネクタを作成

```dart
// lib/providers/storage.dart
@Riverpod(keepAlive: true)
Future<LegacyJsonSharedPreferencesStorage> storage(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return await LegacyJsonSharedPreferencesStorage.open(prefs);
}
```

### 1-3. GeneralSettings の移行（パターン確立）

```dart
// Before: ChangeNotifier + 手動load/save
class GeneralSettingsRepository extends ChangeNotifier {
  var _settings = const GeneralSettings();
  Future<void> load() async { /* SharedPreferencesから手動読み込み */ }
  Future<void> update(GeneralSettings settings) async { /* 手動保存 */ }
}

// After: persist()で自動読み書き
@Riverpod(keepAlive: true)
class GeneralSettingsNotifier extends _$GeneralSettingsNotifier {
  @override
  FutureOr<GeneralSettings> build() async {
    await persist(
      ref.watch(storageProvider.future),
      key: 'general_settings',
      options: const StorageOptions(cacheTime: StorageCacheTime.unsafe_forever),
      encode: (s) => jsonEncode(s.toJson()),
      decode: (json) => GeneralSettings.fromJson(jsonDecode(json)),
    ).future;
    return state.value ?? const GeneralSettings();
  }
  void update(GeneralSettings settings) {
    state = AsyncData(settings); // これだけで永続化完了
  }
}
```

### 1-4. 他のSettings も同パターンで移行

- `AccountSettingsRepository` → `AccountSettingsNotifier`（familyパターン: アカウントごと）
- `TabSettingsRepository` → `TabSettingsNotifier`
- `DesktopSettingsRepository` → `DesktopSettingsNotifier`

AccountSettingsはfamilyパターンを使う:

```dart
@Riverpod(keepAlive: true)
class AccountSettingsNotifier extends _$AccountSettingsNotifier {
  @override
  FutureOr<AccountSettings> build(Acct acct) async {
    await persist(
      ref.watch(storageProvider.future),
      key: 'account_settings_$acct',
      options: const StorageOptions(cacheTime: StorageCacheTime.unsafe_forever),
      encode: (s) => jsonEncode(s.toJson()),
      decode: (json) => AccountSettings.fromJson(jsonDecode(json)),
    ).future;
    return state.value ?? const AccountSettings();
  }
  void update(AccountSettings settings) => state = AsyncData(settings);
}
```

### 1-5. ImportExportRepository → 操作用provider化

他のSettings Notifierに依存して読み書きするだけ。Storage不要。

### 1-6. `providers.dart` をドメイン別に分割

| 新ファイル | 内容 |
|---|---|
| `lib/providers/infrastructure.dart` | dio, fileSystem, cacheManager |
| `lib/providers/storage.dart` | storageProvider |
| `lib/providers/misskey.dart` | misskey, misskeyGetContext, misskeyPostContext, misskeyWithoutAccount |
| `lib/providers/account.dart` | accountContext, accounts, account, i |
| `lib/providers/timeline.dart` | timelineProvider（Phase 4で置換） |
| `lib/providers/settings.dart` | 新しいSettings Notifier群 |
| `lib/providers/note.dart` | notesProvider, favoriteProvider（Phase 2で置換） |
| `lib/providers/error.dart` | errorEventProvider |
| `lib/providers.dart` | barrel file（既存importを壊さないよう再exportのみ） |

### 1-7. 消費側の修正（AsyncValue対応）

```dart
// Before: 同期的にアクセス
ref.watch(generalSettingsRepositoryProvider).settings

// After: AsyncValueとして扱う（keepAlive + persist済みなので実質常にデータあり）
ref.watch(generalSettingsNotifierProvider).valueOrNull ?? const GeneralSettings()

// 個別フィールドだけselectで取得
ref.watch(generalSettingsNotifierProvider.select(
  (s) => s.valueOrNull?.nsfwInherit ?? NSFWInherit.inherit,
))
```

### 1-8. 起動フロー簡素化

```dart
// Before: main.dartで手動load
await ref.read(generalSettingsRepositoryProvider).load();
await ref.read(accountSettingsRepositoryProvider).load();
await ref.read(tabSettingsRepositoryProvider).load();
await ref.read(desktopSettingsRepositoryProvider).load();

// After: storageProviderだけ先にロードすればOK
await ref.read(storageProvider.future);
// 各NotifierはbuildでのAccountContext設定時にpersist()が自動でDBから復元する
```

### 1-9. StateProvider → @riverpod（11箇所）

```dart
// Before
final errorEventProvider = StateProvider<(Object?, BuildContext?)>((ref) => (null, null));

// After
@riverpod
class ErrorEvent extends _$ErrorEvent {
  @override
  (Object?, BuildContext?) build() => (null, null);
  void set(Object? error, BuildContext? context) => state = (error, context);
}
```

---

## Phase 2: NoteRepository の Atomic 分解

NoteRepositoryは巨大なChangeNotifier（notes + noteStatuses + muteWords + API呼び出しが混在）。
3つの独立したAtomに分解する。

### Atom 1: ノートキャッシュ

```dart
@Riverpod(keepAlive: true)
class NoteCache extends _$NoteCache {
  @override
  Map<String, Note> build(Account account) => {};
  void register(Note note) { state = {...state, note.id: note}; }
  void registerAll(Iterable<Note> notes) { ... }
  void remove(String id) { state = Map.of(state)..remove(id); }
}
```

### Atom 2: ノートUI状態（CW開閉等）

```dart
@Riverpod(keepAlive: true)
class NoteStatusCache extends _$NoteStatusCache {
  @override
  Map<String, NoteStatus> build(Account account) => {};
  void update(String id, NoteStatus Function(NoteStatus) updater) { ... }
}
```

### Atom 3: ミュートワード

```dart
@Riverpod(keepAlive: true)
MuteWords muteWords(Ref ref, Account account) {
  final i = ref.watch(iProvider(account.acct));
  return MuteWords.from(i.mutedWords, i.hardMutedWords);
}
```

### FavoriteRepository → Atomic化

NoteCache依存の@riverpod class。

---

## Phase 3: ノート投稿の Selector 分解

現在の`NoteCreate` freezedモデル（22フィールド）と`NoteCreateNotifier`（1110行）を、
関心事ごとのAtomに分解する。

### 各Atomは独立して動作

```dart
// Atom: 公開範囲
@riverpod
class NoteVisibilityState extends _$NoteVisibilityState {
  @override
  NoteVisibility build() => /* デフォルト値 */;
  void set(NoteVisibility v) => state = v;
  void constrainTo(NoteVisibility max) { state = NoteVisibility.min(state, max); }
}

// Atom: 連合オン・オフ
@riverpod
class LocalOnlyState extends _$LocalOnlyState {
  @override
  bool build() => /* デフォルト値 */;
  void toggle() => state = !state;
  void forceLocal() => state = true;
}

// Atom: リアクション受け入れ
@riverpod
class ReactionAcceptanceState extends _$ReactionAcceptanceState { ... }

// Atom: 添付ファイル
@riverpod
class AttachedFiles extends _$AttachedFiles {
  @override
  List<MisskeyPostFile> build() => [];
  void add(MisskeyPostFile file) => state = [...state, file];
  void removeAt(int i) => state = [...state]..removeAt(i);
}

// Atom: CW
@riverpod
class CwState extends _$CwState {
  @override
  ({bool enabled, String text}) build() => (enabled: false, text: "");
  void toggle() => state = (enabled: !state.enabled, text: state.text);
  void setText(String t) => state = (enabled: state.enabled, text: t);
}

// Atom: 投票
@riverpod
class VoteState extends _$VoteState {
  @override
  NoteVoteConfig? build() => null;
  void enable() => state = const NoteVoteConfig();
  void disable() => state = null;
}

// Atom: リプライ先ユーザー
@riverpod
class ReplyToUsers extends _$ReplyToUsers { ... }

// Atom: 送信状態
@riverpod
class NoteSendState extends _$NoteSendState { ... }
```

### 投稿アクション: 各Atomをref.readで寄せ集め

```dart
@riverpod
Future<void> submitNote(Ref ref, {Note? reply, Note? renote}) async {
  final misskey = ref.read(misskeyPostContextProvider);
  final text = ref.read(noteTextControllerProvider).text;
  final visibility = ref.read(noteVisibilityStateProvider);
  final localOnly = ref.read(localOnlyStateProvider);
  final files = ref.read(attachedFilesProvider);
  final cw = ref.read(cwStateProvider);
  final vote = ref.read(voteStateProvider);
  final replyTo = ref.read(replyToUsersProvider);
  final reactionAcceptance = ref.read(reactionAcceptanceStateProvider);
  // バリデーション、ファイルアップロード、API呼び出し...
}
```

### タイムラインからの使用（部分だけ使う）

```dart
class TimelineNoteField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibility = ref.watch(noteVisibilityStateProvider);
    final sendState = ref.watch(noteSendStateProvider);
    return TextField(
      controller: ref.watch(noteTextControllerProvider),
      onSubmitted: (_) => ref.read(submitNoteProvider(reply: null, renote: null)),
    );
  }
}
```

### ノート投稿画面: 全Atomをwatchで寄せ集め（ページとAtom定義が同居）

```dart
// note_create_page.dart に Atom定義もページも全部同居
class NoteCreatePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCw = ref.watch(cwStateProvider.select((s) => s.enabled));
    final files = ref.watch(attachedFilesProvider);
    final isVote = ref.watch(voteStateProvider.select((v) => v != null));
    final sendState = ref.watch(noteSendStateProvider);
    return Column(children: [
      NoteCreateSettingTop(),
      if (isCw) CwTextArea(),
      TextField(...),
      FilePreview(),
      if (isVote) VoteArea(),
    ]);
  }
}
```

---

## Phase 4: Timeline Repository の再設計

### 4-1. タイムライン種別の差異をデータで表現（継承廃止）

```dart
@riverpod
TimelineConfig timelineConfig(Ref ref, TabSetting tab) {
  final account = ref.watch(accountProvider(tab.acct));
  final misskey = ref.read(misskeyProvider(account));
  return switch (tab.tabType) {
    TabType.homeTimeline => TimelineConfig(
      fetcher: (untilId) => misskey.notes.homeTimeline(
        NotesTimelineRequest(limit: 30, untilId: untilId, ...)),
      channel: Channel.homeTimeline(),
      parameters: {"withRenotes": tab.renoteDisplay},
    ),
    TabType.localTimeline => TimelineConfig(...),
    // ... 他のタイムラインも同様
  };
}
```

9つの具象Repositoryクラス（HomeTimelineRepository等）が不要になり、
`TimelineConfig`データ + 共通Notifierだけで動く。

### 4-2. 状態の分解

```dart
// ノートリスト（keepAlive、TabSettingごと）
@Riverpod(keepAlive: true)
class TimelineNotes extends _$TimelineNotes {
  @override
  ({List<Note> newer, List<Note> older, bool isLoading, (Object?, StackTrace)? error})
  build(TabSetting tab) => (newer: [], older: [], isLoading: true, error: null);
}

// Streaming接続管理（keepAlive、TabSettingごと）
@Riverpod(keepAlive: true)
class TimelineStreaming extends _$TimelineStreaming {
  // startTimeline, disconnect, reconnect
  // 内部でTimelineNotesProvider.notifierを操作
}
```

### 4-3. Subscribe/Describe → 専用Notifier

```dart
@Riverpod(keepAlive: true)
class NoteSubscription extends _$NoteSubscription {
  // WebSocketのsubNote/unsubNote管理
  // 10秒タイマーでの自動解除ロジック
}
```

---

## Phase 5: state_notifier/ の各ページへの同居移行

| 現在のファイル | 移動先 |
|---|---|
| `state_notifier/blocked_users_page/` | `view/several_account_settings_page/`内の該当ページに同居 |
| `state_notifier/clip_list_page/` | `view/clip_list_page/`内に同居 |
| `state_notifier/common/misskey_notes/` | `view/common/misskey_notes/`内に同居 |
| `state_notifier/muted_users_page/` | 同上パターン |
| `state_notifier/note_create_page/` | Phase 3で`view/note_create_page/note_create_page.dart`に同居 |
| `state_notifier/photo_edit_page/` | `view/photo_edit_page/photo_edit_page.dart`に同居 |
| `state_notifier/user_list_page/` | `view/users_list_page/`に同居 |
| `state_notifier/chat_input_state_notifier.dart` | `view/chat_page/`内に同居 |

Notifier化不要なものは`keepAlive: true`の関数providerに簡素化。

---

## 実行順序

```
Phase 1 (基盤 + Settings Storage移行) → 他の全Phaseの土台。最もリスク低
Phase 2 (NoteRepository Atomic分解)   → Phase 3, 4の前提
Phase 3 (ノート投稿 Selector分解)     → 最も設計変更が大きいが影響範囲は明確
Phase 5 (state_notifier同居)          → Phase 3, 4と並行。機械的な作業
Phase 4 (Timeline再設計)              → 最後。最もリスク高、テスト重要
```

## 注意事項

- **テスト**: 各Phase完了時に`fvm flutter test`で全テスト通過を確認
- **コード生成**: 各変更後に`fvm flutter pub run build_runner build`が必要
- **AccountContext**: マルチアカウント対応は維持必須。Atomic化しても`.family` + `AccountContext`のスコーピングパターンは継続
- **Timeline (Phase 4)** が最大のリスク。WebSocket接続管理・双方向スクロール・ノート購読の3つが密結合。段階的に分離する
- **Riverpod Storage**: experimentalだがRiverpod 3.0-devで利用可能。APIが変わる可能性あり
