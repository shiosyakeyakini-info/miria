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
minutes, and login survives restarts (secure storage), so an existing process
is usually already signed in.

```bash
fvm flutter run -d windows --debug    # prints: A Dart VM Service ... at: <URI>
```

That URI is the handle for everything, and changes on every launch. Windows
builds need a pinned MSVC toolset — see `reference.md` if the build fails.

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

Coordinates below are for the default 384×661 window. Tabs are user
configurable, so trust the title text under the bar rather than the icon.

- **Top bar** `y≈28` — hamburger `x=28`, then the timeline tabs (`76` home,
  `116` local, `156` …), notifications `x=364`
- **Second row** `y≈76` — current timeline name, then per-tab actions and
  reload `x=364`
- **Bottom** `y≈641` — composer field `x≈152`, send `x=324`, full compose
  page `x=364`
- **Note action row** — reply `x=118`, renote `x=192`, react `x=264`, menu
  `x=338`. The note body is not a tap target; open detail via menu → 詳細
- **Drawer** (hamburger) — 通知 / お気に入り / リスト / アンテナ / クリップ /
  チャンネル / チャット / 検索 / みつける / Misskey Games / 設定, account at top

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

Only needed on a fresh profile. MiAuth opens an external browser and cannot be
driven; API key is the only automatable sign-in.

```bash
curl -X POST http://localhost:3000/api/signin-flow \
  -H "Content-Type: application/json" \
  -d '{"username":"miria","password":"..."}'   # -> {"i": "<token>"}
```

```bash
m tap  --text "APIキーでログイン"
m tap  --x 200 --y 328                 # サーバー field
m text --input "http://localhost:3000"  # the scheme is required
m tap  --x 200 --y 378                 # APIキー field
m text --input "<token>"
m tap  --type ElevatedButton
```

Success looks like the ホームタイムライン screen.

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
dialog** is up (`Get-Process | ? { $_.MainWindowTitle }` — file pickers and
browsers are invisible to marionette); ask the server. `reference.md` has the
full list of what is out of reach and why.
