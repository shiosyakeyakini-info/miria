# marionette against miria — mechanics and limits

Read `SKILL.md` first; this is the "why" behind it. Everything here was
observed against a real build (marionette_flutter 0.6.0, Flutter 3.44.6) —
on Windows unless a section says Linux, and the Linux runs were headless in a
container against misskey 2025.8.0-beta.4.

## Building on Windows

`permission_handler_windows` passes `/await`, which MSVC 14.51+ rejects
(`error C2338`, STL1011). Configure the build directory against the v143
toolset once and Flutter reuses it:

```powershell
Remove-Item -Recurse -Force build\windows
& "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" `
  -S windows -B build\windows\x64 -G "Visual Studio 18 2026" -A x64 -T v143
fvm flutter run -d windows --debug
```

Needs the "C++ ATL for v14.42 build tools" component
(`Microsoft.VisualStudio.Component.VC.14.42.17.12.ATL`), otherwise
`flutter_secure_storage_windows` fails on `atlstr.h`. Redo the `cmake` step
after any `flutter clean`.

Do not run `flutter test` while `flutter run` is up — they share `build/` and
clobber each other's `native_assets.json`.

## A local misskey to drive against

`assets_builder/misskey` is the submodule; `git submodule update --init --depth 1`
brings it down. It needs postgres and redis, `.config/default.yml` pointing at
them, `pnpm install`, `pnpm build`, `pnpm migrate`, `pnpm start`.

Two things bite in a sandboxed container:

- **Docker Hub is often unreachable** (the blob CDN, not the registry). Install
  `postgresql` and `redis-server` from apt and start them with
  `pg_ctlcluster 16 main start` / `redis-server --daemonize yes` instead of
  `compose.local-db.yml`.
- **`github:` dependencies fetch a codeload tarball**, which fails where plain
  git clones succeed. Rewriting them in `packages/frontend/package.json` to
  `git+https://github.com/<owner>/<repo>.git#<ref>` makes pnpm use git.
  `CYPRESS_INSTALL_BINARY=0` skips another download that is only for e2e tests.

`pnpm build` also builds the web frontend, which wants `fluent-emojis/dist/*.png`.
Those are absent from a plain checkout and the vite build dies on them — but
**miria only needs the backend API**, and `packages/backend/built` is produced
before that failure. Migrate and start anyway.

First account, then a token for the API-key login:

```bash
curl -s -X POST http://localhost:3000/api/admin/accounts/create \
  -H "Content-Type: application/json" -d '{"username":"miria","password":"..."}'
curl -s -X POST http://localhost:3000/api/signin-flow \
  -H "Content-Type: application/json" \
  -d '{"username":"miria","password":"..."}'      # -> {"i": "<token>"}
```

## Transports

**MCP server.** `.mcp.json` declares it; `dart pub global activate
marionette_mcp` once, then hand the agent the VM Service URI.

**`scripts/marionette.py`.** Plain HTTP over the VM Service. Every tool is
also reachable raw as `ext.flutter.marionette.<name>` /
`ext.flutter.riverpod.<name>` / `ext.flutter.text.submit`, with `isolateId` as
a query parameter.

`marionette.listExtensions` reports only app-registered extensions, not the
built-ins. The 17 built-ins are `tap`, `secondaryTap`, `doubleTap`,
`longPress`, `swipe`, `pinchZoom`, `scrollTo`, `enterText`, `pressKey`,
`pressBackButton`, `interactiveElements`, `getLogs`, `getVersion`,
`listExtensions`, `takeScreenshots`, `startScreencast`, `stopScreencast`. Read
the package for their parameters.

`startScreencast` returns a TCP port carrying a raw frame protocol — for a
viewer client, not for reading frames as an agent.

## Why note bodies need help

mfm_renderer ends in `Text.rich(TextSpan(children: [WidgetSpan(...)]))`, and
marionette stops traversing at the first `Text` (built in, not configurable).
That `Text`'s `toPlainText()` is the WidgetSpan placeholder `￼`, and the inner
`Text.rich` that holds the real spans is never reached.

`lib/marionette_debug.dart` passes an `extractText` to
`MarionetteConfiguration` that returns the original text from the `Mfm` /
`SimpleMfm` widget above it. Those are `InheritedWidget` / `StatefulWidget`,
visited before the stop, and `Element.renderObject` resolves down to the
paragraph so bounds and hit testing still work.

Decorations are dropped, `:shortcode:` / `@acct` / `#tag` / URLs kept:

```
Mfm    '太字 ぷるぷる :neko: @miria #marionette https://example.com code 通常テキスト'
Text   '￼'
```

Because `extractText` feeds `TextMatcher` (unlike the `Semantics` fallback,
which is discovery-only), body text also works for `tap --text`. Verified: on
a hashtag-only note it reaches the inner `TapGestureRecognizer` and opens the
hashtag page.

The accessibility question — whether mfm_renderer should carry
`Semantics`/`semanticsLabel` itself — is separate and unresolved. The package
currently has none, and ignores `MediaQuery.disableAnimations` for `shake` /
`jelly` / `spin` / `twitch`.

### Button labels

Traversal stops at every interactive widget except `GestureDetector` and
`InkWell` (`_isBuiltInStopWidget`), so a Material button's child `Text` is
never emitted. Tabs built on `InkWell` kept their label, but every
`TextButton` / `ElevatedButton` / `OutlinedButton` arrived as `''` — a confirm
dialog was two anonymous buttons at two coordinates, and the affirmative is
not reliably the right-hand one (`削除する` sits on the **left**). That
mis-tap happened.

`extractText` runs before traversal stops, so `_extractButtonLabel` in
`lib/marionette_debug.dart` walks the button's own subtree and joins the
`Text` it finds. Only widgets that stop traversal are eligible, so no new
elements appear — these are already interactive and listed, and only their
empty `text` gets filled.

`Icon` subtrees are skipped: `Icon` builds a `RichText` whose plain text is a
private-use codepoint, which would turn every icon button into `''`-grade
noise. Icon-only buttons therefore stay empty, which is the honest answer.

## Element discovery

`isElementHittable` hit-tests the element's **centre point** and checks the
render object is in the path. An element whose centre is offscreen or covered
is dropped from `elements` entirely — a half-scrolled note is absent, not
merely `visible: false`. Five notes on screen routinely yield three
`MisskeyNote` entries.

`findElement` stops descending once a node matches, so nested same-type
widgets are unreachable. `key` matching is `ValueKey<String>` only —
`ValueKey<int>` and `GlobalKey` do not match. Text matching is exact equality;
multiple matches silently take the first.

## Input

`enterText` calls `EditableTextState.updateEditingValue`. That means:

- controller listeners and `onChanged` **do** fire (verified: typing `:sm` in
  the composer flips `inputCompletionTypeProvider` to `Emoji`)
- the whole value is replaced and the caret collapses to the end — no
  incremental typing, no IME composition, no selection control
- `performAction` is **not** called, so `onSubmitted` never runs

`pressKey` dispatches `KeyEvent`s through `HardwareKeyboard` and
`FocusManager`, which drives `Shortcuts`/`Actions` and focus traversal but
never reaches `TextInputClient`. So `pressKey enter` cannot submit a field
either.

`text.submit` (`lib/marionette_debug.dart`) closes the gap by calling
`EditableTextState.performAction` on the focused field — public API, no
private imports. It belongs upstream in marionette_flutter, as its own verb or
an `enterText(submit: true)` option; it lives here until then. A standalone
plugin is also viable (`registerMarionetteExtension` and
`ExtensionInputSchema` are exported, as is `WidgetMatcher`), but `WidgetFinder`
and the hit-test helpers are not, so a matcher-targeted version would have to
reimplement the tree walk. Focused-only needs nothing private.

Fields driven by `onSubmitted` in miria: `note_search.dart`,
`play_search.dart`, `user_select_dialog.dart`.

## Scrolling

`scrollTo` derives its attempt budget from the current `maxScrollExtent`
(`_calculateMaxScrollAttempts`), which a lazily-loaded timeline understates
badly. It fails with `Widget not found after 44 scroll attempts` even when the
target is a screen away — observed becoming visible right after the failure.

`swipe` does not accept the `x`/`y` matcher; that is a `tap`-only fast path.
Passing it yields the misleading `Element matching {x: 190.0, y: 400.0} not
found`. Use `startX/startY/endX/endY`. The drag has no fling momentum.

## Riverpod

Providers never read are absent — Riverpod builds state lazily. This is the
usual cause of "my provider is missing".

Values serialize via `toJson()` if present, else `toString()`. miria's
`ChangeNotifier` repositories have neither, so `TimelineRepository`,
`NoteRepository` and friends read as `{"runtimeType": "..."}`. **The
timeline's notes are not reachable through Riverpod** — the element tree or
the server API are the only routes.

Hand-written providers carry no `name` and appear as their type plus
`:unnamed`. Three `ChangeNotifierProvider<TimelineRepository>` are live at
once (home/local/global), so `read` by name fails as ambiguous and the exact
id is a ~400-character `TabSetting` string. Giving them a `name:` would fix
this. Codegen (`@riverpod`) providers get real names.

`accountProvider` includes the API token. Never paste a raw snapshot anywhere
public — this is why the whole binding is debug-only.

## Logs

`get_logs` is effectively empty. miria calls `logger` in seven places, none on
the common error paths, and `PrintLogCollector` is a pass-through that
captures neither `print` nor framework errors. An API failure surfaces as a
dialog whose full text — exception, code, stack — **is** in the element list;
read that instead.

Wiring `FlutterError.onError` and a `runZoned` print handler into the
collector would make this tool useful.

## Building on Linux

Nothing to configure — `fvm flutter build linux --debug` succeeds against
stock Ubuntu 24.04 build deps (clang, cmake, ninja, `libgtk-3-dev`). No
toolset pinning, no `permission_handler` fallout: that package's Windows
implementation is what breaks there, and it is not in the Linux build.

Headless needs Xvfb, `LIBGL_ALWAYS_SOFTWARE=1`, a session bus, gnome-keyring
and the portal stub — `SKILL.md` has the launch block. Flutter renders through
llvmpipe without complaint; the only console noise is a harmless
`Atk-CRITICAL ... atk_socket_embed` from GTK's accessibility bridge.

## The file picker on Linux

file_picker 12 dropped the native dialog on Linux. `FilePickerLinux` is pure
D-Bus (`lib/src/platform/linux/file_picker_linux.dart`): it calls
`org.freedesktop.portal.FileChooser.OpenFile` on
`org.freedesktop.portal.Desktop`, gets back a Request object path, and awaits
one `org.freedesktop.portal.Request.Response` signal (`ua{sv}`) on it —
`response == 0` plus a `uris` array, or any non-zero for cancelled.
`getDirectoryPath` is the same call with `directory: true`; `saveFile` is
`SaveFile`. All three read `uris` from the same reply.

Nothing about that is a GUI, so none of it needs one. `scripts/portal_stub.py`
owns the name and answers from `/tmp/marionette-portal/answer.json` — the whole
picker becomes a file you write before the tap. It is ~120 lines of `jeepney`
(`pip install jeepney`, pure Python, no libdbus).

Consequences worth knowing:

- **With no portal on the bus, the picker throws** —
  `org.freedesktop.DBus.Error.ServiceUnknown: The name
  org.freedesktop.portal.Desktop was not provided by any .service files`.
  A bare container has no `xdg-desktop-portal` installed, so this is the
  default state, not an edge case.
- **The response must not be instant.** The client subscribes to the Response
  signal only *after* `OpenFile` returns, so a stub that answers in the same
  millisecond loses the race and the signal is dropped. `pickFiles` then awaits
  forever, with the app looking perfectly healthy. Measured: a 0-second delay
  fails every time, 0.6 s (the stub default, `PORTAL_STUB_DELAY`) is reliable.
  A real portal is safe here only because a human takes seconds to click.
- **Request handles must stay unique across stub restarts.** A client whose
  Response was lost is still subscribed to that object path. Restarting a stub
  that numbers handles from zero hands the next client the same path, and the
  one signal completes *both* awaits — observed as the same file attached
  twice from a single tap. The stub puts its pid in the path for this reason.
- `answer.json` is consumed per request (`"once": false` keeps it armed).
  Absent file == cancelled, which is how you exercise the cancel branch.

Verified against miria's composer: single file, two files, and cancel, each
confirmed on the server (`/api/users/notes` showed the attached
`image/png`, byte size matching the source). miria calls `pickFiles` from three
places — `note_create_state_notifier.dart`, `chat_input_state_notifier.dart`,
`profile_edit_page.dart` — all through this one platform call.

## Out of reach

- **Native dialogs (Windows).** 「アップロード」 opens a `File Picker` window owned
  by the miria process. `elements` does not change, `take_screenshots` does not
  show it (it renders the Flutter scene only), and the VM Service keeps
  answering — indistinguishable from a tap that did nothing. Detect with
  `Get-Process | ? { $_.MainWindowTitle }`; dismiss with
  `(New-Object -ComObject WScript.Shell).AppActivate("File Picker")` then
  `SendKeys("{ESC}")`. The in-app drive picker (「ドライブから」) is fully
  driveable. **On Linux this limit does not apply** — see above.
- **External browser.** MiAuth (`account_repository.dart`) and note links use
  `launchUrl(externalApplication)`. Same invisibility. API-key login is the
  only automatable sign-in for this reason.
- **Clipboard.** 「内容をコピー」 works but marionette has no clipboard tool —
  verify with `Get-Clipboard`.
- **Window control.** No resize or multi-window API, so width-dependent
  desktop layouts (deck mode) cannot be exercised.
- **Hot reload.** `flutter run` owns the compiler; calling the VM Service's own
  `reloadSources` fails with `Error while starting Kernel isolate task`.

## Encoding

The VM Service answers in UTF-8. A Windows console defaulting to CP932 turns
every Japanese label into mojibake and makes a healthy app look broken. This
also bites *between* processes: piping UTF-8 JSON into a second `python -c`
that reads `sys.stdin` with the locale codec produces lone surrogates that
look exactly like server-side corruption.

`curl -d` with a multibyte JSON body fails with
`FST_ERR_CTP_INVALID_CONTENT_LENGTH` — the byte length and the character count
disagree. Write the body to a file and use `--data-binary @file`, or post from
Python.
