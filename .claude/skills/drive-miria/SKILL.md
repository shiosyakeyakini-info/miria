---
name: drive-miria
description: Launch miria and operate it as a real user through marionette — log in, navigate, post a note, react, search, attach a file, inspect Riverpod state, take screenshots. Covers running it headless on Linux. Use when asked to run miria, reproduce a UI bug, or confirm a change works in the running app rather than only in tests.
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
fvm flutter run -d linux   --debug    # same, on a Linux desktop or container
```

That URI is the handle for everything, and changes on every launch. Windows
builds need a pinned MSVC toolset — see `reference.md` if the build fails.
Linux builds need no such coaxing, but a headless one needs an X display, a
session bus and a few daemons around it — see **Linux, headless** below.

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

### Attach a file (Linux only)

On Linux the 「アップロード」 picker is **not** a native dialog: file_picker 12
asks the XDG desktop portal over the session bus and waits for its reply. Serve
that yourself with `scripts/portal_stub.py` and the picker becomes ordinary
scripted UI — arm the answer, tap, verify.

```bash
python .claude/skills/drive-miria/scripts/portal_stub.py &   # once per session
```

```bash
echo '{"paths": ["/abs/path/pic.png"]}' > /tmp/marionette-portal/answer.json
m tap  --x 25 --y 238        # 画像アイコン, leftmost under the compose field
m tap  --text "アップロード"
```

Re-read `elements` for that first coordinate rather than trusting it — it is
from one 400×700 Linux window.

The answer is consumed by one request, so arm it again for the next pick. Two
paths in `paths` selects two files; **leaving the file absent is how you press
Cancel**. Every call is appended to `/tmp/marionette-portal/requests.log` —
that log is the proof the picker actually opened, since a tap that missed looks
identical from `elements`.

Give it real files. The stub hands over whatever path you name, but miria asks
for `FileType.image` and decodes the result, and
`note_create_state_notifier.dart` pops an error dialog when the decode yields
nothing — so a bad file fails inside miria, well after the picker looked fine.
Verify uploads on the server, never on the screen:

```bash
curl -s -X POST http://localhost:3000/api/users/notes \
  -H "Content-Type: application/json" -d '{"userId":"<id>","limit":1}'
```

Windows has no equivalent — there the picker is a real native window and stays
out of reach (`reference.md`).

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

## Linux, headless

A container with no display runs miria fine — verified end to end on Ubuntu
24.04 against a local misskey, including uploads. Bring these up **before**
`flutter run`; the app inherits them from the environment:

```bash
Xvfb :99 -screen 0 1280x900x24 &
export DISPLAY=:99
export LIBGL_ALWAYS_SOFTWARE=1                 # llvmpipe; no GPU in a container
export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --print-address --fork)
printf '\n' | gnome-keyring-daemon --unlock --replace --daemonize --components=secrets
python .claude/skills/drive-miria/scripts/portal_stub.py &
```

- **Xvfb** — the GTK shell needs an X server. `m shot` still captures the
  Flutter scene, so screenshots work with nothing on screen.
- **gnome-keyring** — `flutter_secure_storage` stores the account through
  `org.freedesktop.secrets`, which nothing else in a bare container provides.
  It was up before the login above; a run without it was not tried.
- **portal_stub.py** — the file picker. See the recipe above.

The session bus is the load-bearing part: the app reads
`DBUS_SESSION_BUS_ADDRESS` at startup, so a bus started afterwards is invisible
to it. `dbus-send --session --dest=org.freedesktop.DBus --print-reply \
/org/freedesktop/DBus org.freedesktop.DBus.ListNames` should list both
`org.freedesktop.portal.Desktop` and `org.freedesktop.secrets` before you launch.

The Linux window is larger than the Windows one — every coordinate under
**The screen** is wrong here. Read `elements` and use what it reports.

## When it looks like nothing happened

In order: re-read `elements`; take a screenshot; ask the server. Then check
whether something outside the Flutter scene is holding the app:

- **Windows** — a native dialog (`Get-Process | ? { $_.MainWindowTitle }`);
  file pickers and browsers are invisible to marionette.
- **Linux** — no native dialog exists for the file picker, so read
  `/tmp/marionette-portal/requests.log` instead. No request line at all means
  the tap missed, or the stub is down and the call threw `ServiceUnknown`. A
  request *and* a response logged, with nothing on screen, means the response
  lost the subscription race and `pickFiles` is now hung — restart the stub
  with a larger `PORTAL_STUB_DELAY` (`reference.md`).

`reference.md` has the full list of what is out of reach and why.
