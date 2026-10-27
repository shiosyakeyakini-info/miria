# marionette against miria — mechanics and limits

Read `SKILL.md` first; this is the "why" behind it. Everything here was
observed against a real build — marionette_flutter 0.6.0 on Windows with
Flutter 3.44.6, and the Linux sections on a headless container (Xvfb, no
window manager) with Flutter 3.47.8 against a local Misskey 2024.2.0.
Anything not marked Linux was seen on Windows and is assumed, not checked,
to hold on Linux.

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

## Building on Linux

`fvm flutter build linux --debug` needs nothing beyond the usual GTK
toolchain: clang, cmake, ninja, and `pkg-config` finding `gtk+-3.0` and
`libsecret-1` (the latter for `flutter_secure_storage_linux`). The trouble is
running it.

## Running headless on Linux

The app needs three things a desktop session would normally supply: an X
display, a D-Bus session bus, and a Secret Service with an unlocked `login`
collection. Without the last one, the build starts fine and the API-key
login fails with a dialog quoting
`Libsecret error, secret_password_storev_sync: Object does not exist at path
"/org/freedesktop/secrets/collection/login"`. gnome-keyring creates `login`
only after asking for a password, and there is nobody to ask, so put a
**plaintext** keyring in place *before* the daemon starts — it does not pick
up a file dropped in later:

```bash
mkdir -p ~/.local/share/keyrings
cat > ~/.local/share/keyrings/login.keyring <<'EOF'
[keyring]
display-name=login
ctime=0
mtime=0
lock-on-idle=false
lock-after=false
EOF
printf login > ~/.local/share/keyrings/default
```

Secrets end up readable on disk. That is the point here; do not do it on a
machine that holds anything real.

Keep the bus **separate from the app**. If `flutter run` is the child of
`dbus-run-session`, stopping the app tears down the bus and the keyring with
it, and the next launch fails with `secret_service_get_sync: Could not
connect`. Give the bus a process of its own that just sleeps:

```bash
Xvfb :99 -screen 0 1280x800x24 &
cat > /tmp/bus.sh <<'EOF'
#!/bin/bash
echo "$DBUS_SESSION_BUS_ADDRESS" > /tmp/miria-dbus
gnome-keyring-daemon --start --components=secrets >/dev/null 2>&1
exec sleep infinity
EOF
chmod +x /tmp/bus.sh
setsid dbus-run-session -- /tmp/bus.sh </dev/null >/dev/null 2>&1 &
sleep 2

export DISPLAY=:99 DBUS_SESSION_BUS_ADDRESS=$(cat /tmp/miria-dbus)
fvm flutter run -d linux --debug
```

Check the keyring before blaming the app:

```bash
gdbus introspect --session -d org.freedesktop.secrets \
  -o /org/freedesktop/secrets/collection -r | grep node   # want .../login
```

The console fills with `AT-SPI: Error retrieving accessibility bus address`,
`DRI3 error` and an `Atk-CRITICAL`. They are the missing accessibility bus and
GPU; rendering falls back to software and screenshots work.

To stop the app, `pkill -x miria`. Not `pkill -f` with a pattern that also
appears in the command you are running — it matches its own shell and kills
the caller.

### Login does not survive a restart

Even with the keyring working, every launch comes up logged out.
`accountRepositoryProvider` reads `[]`, and nothing is logged, because
`AccountRepository.load` returns silently when the stored value is `null`.

The item is there — `login.keyring` shows
`display-name=info.shiosyakeyakini.miria/FlutterSecureStorage` — but its
`xdg:schema` attribute is garbage (`/` here). `flutter_secure_storage_linux`
3.0.x builds `SecretSchema` with `name = label.c_str()` in the constructor,
then `setLabel()` replaces the string, leaving the schema name pointing at
freed memory. libsecret matches on `xdg:schema`, so a later process whose
garbage differs finds nothing. Upstream's account is that the value is stable
per build; here two launches of the same bundle already disagreed, even
though both wrote `/`.

Fixed in `flutter_secure_storage_linux` 4.0.0-beta.1 (upstream #1249), which
also migrates items stored under a wrong schema on first read. miria still
resolves 3.0.x. Until that changes, budget an API-key login per launch.

## Running a local Misskey on Linux

Use a full Misskey checkout, not the shallow `assets_builder/misskey`
submodule. miria only talks to the API, so the backend is enough.

- Postgres and Redis: `pg_ctlcluster 16 main start`, `redis-server
  --daemonize yes`, a superuser role and database matching
  `.config/default.yml` (copy `example.yml`).
- Use the Node in `.node-version`. A newer one fails to compile native
  modules (`re2` against `nan`) during install.
- `CYPRESS_INSTALL_BINARY=0 pnpm install`. If GitHub tarballs
  (`codeload.github.com`) are blocked, the `github:` dependencies fail the
  whole install even with `--filter`. In 2024.2 they are frontend-only
  (`aiscript-vscode`, `storybook-addon-misskey-theme`): drop them from
  `packages/frontend/package.json` locally and install with
  `--no-frozen-lockfile`. Do not commit that.
- `pnpm build-pre && pnpm --filter "backend..." build && pnpm migrate`, then
  `NODE_ENV=production node packages/backend/built/boot/entry.js`.
- `POST /api/meta` answering is the readiness check. The web UI will not load;
  that is the frontend you did not build.

## Either platform

Do not run `flutter test` while `flutter run` is up — they share `build/` and
clobber each other's `native_assets.json`.

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

## Out of reach

- **Native dialogs.** 「アップロード」 opens a `File Picker` window owned by the
  miria process. `elements` does not change, `take_screenshots` does not show
  it (it renders the Flutter scene only), and the VM Service keeps answering —
  indistinguishable from a tap that did nothing. Detect with `Get-Process | ?
  { $_.MainWindowTitle }`; dismiss with
  `(New-Object -ComObject WScript.Shell).AppActivate("File Picker")` then
  `SendKeys("{ESC}")`. The in-app drive picker (「ドライブから」) is fully
  driveable.

  **Linux:** `file_picker` does not draw a dialog itself — it asks the XDG
  Desktop Portal over D-Bus. On a headless session there is no portal, so
  「アップロード」 does nothing on screen and the only trace is
  `Unhandled Exception: org.freedesktop.DBus.Error.ServiceUnknown: The name
  org.freedesktop.portal.Desktop was not provided by any .service files` in
  the `flutter run` console. Use 「ドライブから」 there too.
- **External browser.** MiAuth (`account_repository.dart`) and note links use
  `launchUrl(externalApplication)`. Same invisibility. API-key login is the
  only automatable sign-in for this reason.
- **Clipboard.** 「内容をコピー」 works but marionette has no clipboard tool —
  verify with `Get-Clipboard`.
- **Window control.** No resize or multi-window API, so width-dependent
  desktop layouts (deck mode) cannot be exercised.
- **Hot reload.** `flutter run` owns the compiler; calling the VM Service's own
  `reloadSources` fails with `Error while starting Kernel isolate task`.

## Encoding (Windows)

The VM Service answers in UTF-8. A Windows console defaulting to CP932 turns
every Japanese label into mojibake and makes a healthy app look broken. This
also bites *between* processes: piping UTF-8 JSON into a second `python -c`
that reads `sys.stdin` with the locale codec produces lone surrogates that
look exactly like server-side corruption.

`curl -d` with a multibyte JSON body fails with
`FST_ERR_CTP_INVALID_CONTENT_LENGTH` — the byte length and the character count
disagree. Write the body to a file and use `--data-binary @file`, or post from
Python.
