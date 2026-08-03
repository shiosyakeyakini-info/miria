---
name: drive-miria
description: Launch miria and operate it as a real user through marionette — log in, navigate, post a note, inspect Riverpod state, take screenshots. Use when asked to run miria, reproduce a UI bug, or confirm a change works in the running app rather than only in tests.
---

# Driving miria with marionette

miria's debug builds embed a [marionette](https://github.com/leancodepl/marionette_mcp)
binding (`lib/marionette_debug.dart`), so a running instance can be inspected and
driven from outside. This skill is the operating manual: how to get an app up,
how to find things on screen, and the sequences that are known to work.

Everything below was executed against a real build; the gotchas are ones that
actually bit.

## 1. Get an app running

```bash
fvm flutter run -d windows --debug
```

Copy the line it prints:

```
A Dart VM Service on Windows is available at: http://127.0.0.1:49570/_id8d8wYirU=/
```

That URI is the handle for everything else. It changes on every launch.

> **Windows builds need a pinned toolset.** `permission_handler_windows` passes
> `/await`, which MSVC 14.51+ rejects (`error C2338`, STL1011). Configure the
> build directory against the v143 toolset once, and Flutter will reuse it:
>
> ```powershell
> Remove-Item -Recurse -Force build\windows
> & "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" `
>   -S windows -B build\windows\x64 -G "Visual Studio 18 2026" -A x64 -T v143
> fvm flutter run -d windows --debug
> ```
>
> This needs the "C++ ATL for v14.42 build tools" component
> (`Microsoft.VisualStudio.Component.VC.14.42.17.12.ATL`) installed, otherwise
> `flutter_secure_storage_windows` fails on `atlstr.h`. Redo the `cmake` step
> after any `flutter clean`.

## 2. Connect

**Preferred — the MCP server.** `.mcp.json` already declares it; install once
with `dart pub global activate marionette_mcp`, then hand the agent the VM
Service URI and use the MCP tools directly: `get_interactive_elements`, `tap`,
`enter_text`, `scroll_to`, `swipe`, `long_press`, `press_back_button`,
`take_screenshots`, `get_logs`, `hot_reload`, plus miria's own
`riverpod_snapshot` / `riverpod_read`.

**Fallback — `scripts/marionette.py`.** Same capabilities over plain HTTP, for
when the MCP server is not set up or you want a scripted sequence:

```bash
python .claude/skills/drive-miria/scripts/marionette.py \
  --uri http://127.0.0.1:49570/_id8d8wYirU=/ elements   # caches the URI
python .claude/skills/drive-miria/scripts/marionette.py tap --text "APIキーでログイン"
python .claude/skills/drive-miria/scripts/marionette.py text --input "hello"
python .claude/skills/drive-miria/scripts/marionette.py shot out.png
python .claude/skills/drive-miria/scripts/marionette.py snapshot --filter account
```

Every tool is also reachable raw as `ext.flutter.marionette.<name>` /
`ext.flutter.riverpod.<name>` on the VM Service, with `isolateId` as a query
parameter.

## 3. Find things on screen

`elements` (`get_interactive_elements`) is the map. It returns each interactive
widget with its type, text, and bounds. Match in this order:

1. **`text`** — works with Japanese labels: `tap --text "APIキーでログイン"`.
2. **`key`** — if the widget has one.
3. **coordinates** — `tap --x 200 --y 328`, using the element's *centre*.
4. **`type`** — `tap --type ElevatedButton`. Only when the type is unique on
   screen; it silently takes the first match.

Then take a screenshot to confirm you are where you think you are. The element
list and the pixels occasionally disagree — dialogs in particular.

## 4. Sequences that work

### Log in (API key)

Fastest way to a logged-in app; MiAuth needs a browser round-trip.

Get a token from the server (first admin on an empty instance):

```bash
curl -X POST http://localhost:3000/api/admin/accounts/create \
  -H "Content-Type: application/json" \
  -d '{"username":"miria","password":"..."}'
curl -X POST http://localhost:3000/api/signin-flow \
  -H "Content-Type: application/json" \
  -d '{"username":"miria","password":"..."}'   # -> {"i": "<token>"}
```

Then drive the login screen:

```bash
marionette.py tap  --text "APIキーでログイン"
marionette.py tap  --x 200 --y 328                     # focus サーバー
marionette.py text --input "http://localhost:3000"
marionette.py tap  --x 200 --y 378                     # focus APIキー
marionette.py text --input "<token>"
marionette.py tap  --type ElevatedButton
```

The two fields are both bare `TextField`s, so `--type TextField` always hits the
first one. Tap the field by coordinate, then write to `focused` (the default
matcher for `text`).

**The scheme is required for a local server.** `localhost:3000` alone is tried
over https, fails the TLS handshake, and you get
「サーバーとして認識できませんでした」. Use `http://localhost:3000`.

Success looks like the ホームタイムライン screen.

### Post a note

From the timeline, the composer is the `TextField` pinned to the bottom:

```bash
marionette.py tap  --x 150 --y 640     # composer
marionette.py text --input "marionette から投稿しました"
marionette.py tap  --x 304 --y 640     # send
```

A `MisskeyNote` appears in the element list and the composer clears. Confirm on
the server rather than trusting the UI:

```bash
curl -X POST http://localhost:3000/api/users/notes \
  -H "Content-Type: application/json" -d '{"userId":"<id>","limit":5}'
```

### Inspect state

```bash
marionette.py snapshot                    # names and types only — start here
marionette.py snapshot --filter account --values
marionette.py read accountRepositoryProvider
```

Providers that were never read do not appear: Riverpod builds state lazily, so
there is genuinely nothing to report for them. This is the single most common
source of "my provider is missing".

Miria's hand-written providers (`ChangeNotifierProvider<...>`, `StateProvider<...>`)
carry no `name`, so they show up as their type plus `:unnamed`. Codegen
(`@riverpod`) providers get real names. If you need to address one of the
unnamed ones repeatedly, giving it a `name:` is worth it.

## 5. Gotchas

- **Read responses as UTF-8.** The VM Service answers in UTF-8; a Windows
  console defaulting to CP932 turns every Japanese label into mojibake and makes
  it look like the app is broken when it is not.
- **Do not run `flutter test` and `flutter run` at once.** They share `build/`
  and clobber each other's `native_assets.json`.
- **Give the UI time.** Network-backed transitions need several seconds before
  the element list settles; a screenshot taken too early shows the old screen.
- **`take_screenshots` works** on Windows/Impeller — a real PNG, not a blank
  frame.
- **Values can contain secrets.** An account object holds its API token, and
  provider values are dumped best-effort. This is debug-only for that reason;
  do not paste raw snapshots into anywhere public.
- **A fresh `flutter run` means a fresh URI.** Nothing caches across launches.
