---
name: drive-miria
description: Launch miria and operate it as a real user through marionette — log in, navigate, post a note, react, search, inspect Riverpod state, take screenshots. Use when asked to run miria, reproduce a UI bug, or confirm a change works in the running app rather than only in tests.
---

# Driving miria with marionette

miria's debug builds embed a marionette binding (`lib/marionette_debug.dart`),
so a running instance can be driven from outside. This file is the operating
manual. When something behaves in a way it does not explain, read
`reference.md` next to it — the mechanics, the limits, and the traps live
there.

## Connect

The app may already be running. Check before rebuilding: a debug build takes
minutes, and on Windows login survives restarts (secure storage), so an
existing process is usually already signed in. On Linux it does not — see
`reference.md`.

```bash
fvm flutter run -d windows --debug    # prints: A Dart VM Service ... at: <URI>
fvm flutter run -d linux --debug      # same, but needs a display and a keyring
```

That URI is the handle for everything, and changes on every launch. On Linux,
running the already-built `build/linux/x64/debug/bundle/miria` directly
skips the rebuild and prints `The Dart VM service is listening on <URI>`
instead.

Each desktop has its own setup cost, in `reference.md`: Windows builds need a
pinned MSVC toolset; Linux without a desktop (CI, a container) needs Xvfb, a
D-Bus session and an unlocked keyring before the app can even log in.

Drive it with `scripts/marionette.py` (plain HTTP, no MCP server needed):

```bash
python .claude/skills/drive-miria/scripts/marionette.py --uri <URI> elements
```

The URI is cached, so later calls can omit `--uri`. Below, `m` stands for that
script path.

## Verbs

| | |
|---|---|
| `m elements` | the map — every interactive widget with type, text, bounds |
| `m tap` | `--text` / `--key` / `--x --y` / `--type` |
| `m text --input "..."` | replaces the whole value of the focused field |
| `m submit` | fires `onSubmitted`. `--action done\|next\|previous` |
| `m swipe --start X Y --end X Y` | drag. **This is how you scroll** |
| `m back` | pop the current route |
| `m shot out.png` | screenshot |
| `m snapshot` / `m read <name>` | Riverpod state |
| `m logs` | miria's logger output (nearly always empty — `reference.md`) |

There are more built-ins (`longPress`, `secondaryTap`, `doubleTap`,
`pinchZoom`, `scrollTo`, `pressKey`) reachable raw as
`ext.flutter.marionette.<name>`. `scrollTo` and `pressKey` do not do what
their names suggest here — `reference.md` explains why, and `swipe` /
`submit` are the working substitutes.

## The loop

**`elements` → act → verify.** Never skip the third step.

- **A tap that hits nothing still reports success.** `Tapped element matching:
  {...}` only means a pointer event was dispatched.
- **Seeing what you wanted on screen is not proof your action ran.** The
  search page's ユーザー tab lists bob before you type anything, so "I typed
  bob and bob is there" says nothing. For anything that changes state, ask the
  server:

```bash
curl -s -X POST http://localhost:3000/api/users/notes \
  -H "Content-Type: application/json" -d '{"userId":"<id>","limit":5}'
```

- **Re-read `elements` before every tap.** Coordinates shift constantly — one
  new reaction chip moves a whole timeline.
- **Give the UI seconds**, not milliseconds, after anything network-backed.
  There is no settle primitive. A tap right after a route pop was swallowed
  once; the retry worked.

Match in this order: **`text`** (exact only, no substring; several matches →
silently the first), **`key`** (`MisskeyNote` carries the note id, emoji
buttons carry the emoji: `tap --key 👍`), **coordinates** (the element's
*centre*), **`type`** (only when unique).

Note bodies are readable — they surface as `Mfm` / `SimpleMfm` elements with
the text flattened the way it looks on screen, and are valid `--text`
matchers. The `Text '￼'` sitting at the same spot is the same note; ignore it.

Buttons carry their own label, so a confirm dialog reads `TextButton '削除する'`
/ `TextButton 'やっぱやめる'` rather than two anonymous buttons — match those by
`--text`, never by guessing which side is affirmative. Icon-only buttons stay
empty; the icon glyph is deliberately kept out of the label.

## The screen

The window opens at 400×700 (`lib/main.dart`). On Windows the client area
measured 384×661 — presumably the frame's share; under Xvfb there is no window manager,
so Linux gets the full 400×700 and everything right of centre or below it
sits a little further out. Tabs are user configurable, so trust the title
text under the bar rather than the icon.

| | Windows 384×661 | Linux (Xvfb) 400×700 |
|---|---|---|
| **Top bar** | `y≈28` — hamburger `x=28`, tabs `76` home / `116` local / `156` …, notifications `x=364` | `y≈28` — same `x` for hamburger and tabs, notifications `x=380` |
| **Second row** — timeline name, per-tab actions, reload | `y≈76`, reload `x=364` | `y≈76`, reload `x=380` |
| **Bottom** — composer, send, full compose page | `y≈641`, `x≈152` / `324` / `364` | `y≈680`, `x≈160` / `340` / `380` |
| **Note action row** — reply, renote, react, menu | `x=118` / `192` / `264` / `338` | `x=120` / `198` / `274` / `352` |

The note body is not a tap target; open detail via menu → 詳細. The
**drawer** (hamburger) holds 通知 / お気に入り / リスト / アンテナ / クリップ /
チャンネル / チャット / 検索 / みつける / Misskey Games / 設定, account at top —
tap those by `--text`, which works the same everywhere.

Recipes below use the Windows numbers. Anything not in the table has not
been measured on Linux; re-read `elements` rather than scaling by hand.

## Recipes

### Post a note

```bash
m tap  --x 152 --y 641
m text --input "marionette から投稿しました"
m tap  --x 324 --y 641
```

### React

The picker opens with a search field on top and category accordions below.
Search by English shortcode, then tap the result by its key.

```bash
m tap  --x 264 --y <note action row>   # ＋
m tap  --x 192 --y 53                  # picker's search field
m text --input "thumbs"
m tap  --key 👍
```

### Search

Search runs on `onSubmitted`, which neither `text` nor `pressKey enter` can
trigger — `submit` exists for exactly this.

```bash
m tap  --text "検索"        # drawer
m tap  --text "ユーザー"     # tab: ノート x=64, ユーザー x=192, Play x=320, all y=80
m tap  --x 172 --y 134     # query field
m text --input "bob"
m submit
```

Read-only actions leave nothing on the server to check, so prove the mechanism
instead: run it once with input that **must** produce a different result. A
query no user can match empties the list (「なんもないで」), which the
pre-populated default never does — then repeat with the real query.

### Scroll

```bash
m swipe --start 190 450 --end 190 150
```

### Log in (API key)

Only needed on a fresh profile — which on Linux is every launch. MiAuth opens
an external browser and cannot be driven; API key is the only automatable
sign-in.

```bash
curl -X POST http://localhost:3000/api/signin-flow \
  -H "Content-Type: application/json" \
  -d '{"username":"miria","password":"..."}'   # -> {"i": "<token>"}
```

On a server with no users yet, `/api/admin/accounts/create` takes the same
body without auth (while `setupPassword` is unset in `.config/default.yml`)
and makes the first admin.

Wait until `elements` lists `APIキーでログイン` before tapping it. Right after
launch the tab is not there yet, the tap fails, and the next taps land on the
MiAuth form instead — its 認証をする opens an external browser that never
appears.

```bash
m tap  --text "APIキーでログイン"
m tap  --x 200 --y 328                 # サーバー field   (Linux: --x 236 --y 348)
m text --input "http://localhost:3000"  # the scheme is required
m tap  --x 200 --y 378                 # APIキー field    (Linux: --x 236 --y 398)
m text --input "<token>"
m tap  --type ElevatedButton
```

Success looks like the ホームタイムライン screen. On Linux, a dialog quoting
`Libsecret error` instead means the keyring is not set up — `reference.md`.

### Inspect state

```bash
m snapshot                        # names and types only — start here
m snapshot --filter account --values
m read accountRepositoryProvider
```

Providers that were never read are absent — Riverpod builds state lazily.
Repositories serialize to `{"runtimeType": ...}` only, so the timeline's notes
are not reachable this way. Values can contain API tokens; never paste a raw
snapshot anywhere public.

## When it looks like nothing happened

In order: re-read `elements`; take a screenshot; check whether a **native
dialog** is up (Windows: `Get-Process | ? { $_.MainWindowTitle }` — file
pickers and browsers are invisible to marionette); on Linux, read the
`flutter run` console, where a missing desktop service shows up as an
`Unhandled Exception` and nowhere else; ask the server. `reference.md` has the
full list of what is out of reach and why.
