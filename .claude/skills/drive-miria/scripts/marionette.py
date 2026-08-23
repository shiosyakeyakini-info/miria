#!/usr/bin/env python3
"""Talk to a running miria (or any marionette-enabled Flutter app) over the
Dart VM Service, without needing the marionette_mcp server.

The MCP server is the normal route. This exists for when it is not set up, or
when you want a scripted, repeatable sequence.

    python marionette.py --uri http://127.0.0.1:49570/_id8d8wYirU=/ elements
    python marionette.py tap --text "APIキーでログイン"
    python marionette.py tap --x 200 --y 328
    python marionette.py text --input "hello"          # focused field
    python marionette.py shot out.png
    python marionette.py snapshot --filter account

The URI is printed by `flutter run` as
"A Dart VM Service on Windows is available at: ...". Pass it with --uri or set
MARIONETTE_VM_URI; it is cached in .marionette_uri next to this script so
subsequent calls can omit it.
"""

import argparse
import base64
import io
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request

# The VM Service answers in UTF-8. Windows consoles often default to CP932,
# which turns every Japanese label into mojibake.
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8")

CACHE = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".marionette_uri")


def resolve_uri(explicit):
    uri = explicit or os.environ.get("MARIONETTE_VM_URI")
    if uri:
        with open(CACHE, "w", encoding="utf-8") as f:
            f.write(uri)
        return uri
    if os.path.exists(CACHE):
        with open(CACHE, encoding="utf-8") as f:
            return f.read().strip()
    sys.exit("No VM Service URI. Pass --uri or set MARIONETTE_VM_URI.")


class App:
    def __init__(self, base):
        self.base = base if base.endswith("/") else base + "/"
        self.isolate = self._first_isolate()

    def _get(self, method, params):
        url = self.base + method + "?" + urllib.parse.urlencode(params)
        try:
            with urllib.request.urlopen(url) as r:
                return json.loads(r.read().decode("utf-8"))
        except urllib.error.HTTPError as e:
            return json.loads(e.read().decode("utf-8"))

    def _first_isolate(self):
        vm = self._get("getVM", {})
        return vm["result"]["isolates"][0]["id"]

    def call(self, method, **params):
        params["isolateId"] = self.isolate
        result = self._get(method, params)
        if "error" in result:
            raise SystemExit(json.dumps(result["error"], ensure_ascii=False, indent=1))
        return result["result"]

    def marionette(self, name, **params):
        return self.call("ext.flutter.marionette." + name, **params)


def cmd_elements(app, args):
    """Print the interactive widget tree, one line per element.

    This is the map you navigate by: match on `text` when a widget has a
    label, fall back to coordinates when several widgets share a type.
    """
    for e in app.marionette("interactiveElements")["elements"]:
        b = e.get("bounds", {})
        cx = b.get("x", 0) + b.get("width", 0) / 2
        cy = b.get("y", 0) + b.get("height", 0) / 2
        print(
            f"{e.get('type',''):18} {e.get('text','')!r:44} "
            f"center=({cx:.0f},{cy:.0f})"
        )


def _matcher(args):
    if args.text:
        return {"text": args.text}
    if args.key:
        return {"key": args.key}
    if args.x is not None and args.y is not None:
        return {"x": str(args.x), "y": str(args.y)}
    if args.type:
        return {"type": args.type}
    return {"focused": "true"}


def cmd_tap(app, args):
    print(app.marionette("tap", **_matcher(args))["message"])


def cmd_text(app, args):
    print(app.marionette("enterText", input=args.input, **_matcher(args))["message"])


def cmd_submit(app, args):
    """Confirm the focused field, the way a keyboard's done/search key does.

    `enterText` only rewrites the value and `pressKey enter` never reaches
    `TextInputClient`, so anything wired to `onSubmitted` — note search, for
    one — needs this. Registered by lib/marionette_debug.dart.
    """
    print(app.call("ext.flutter.text.submit", action=args.action)["message"])


def cmd_swipe(app, args):
    """Drag between two points.

    Use this rather than `scroll_to` on the timeline: `scroll_to` sizes its
    attempt budget from the current `maxScrollExtent`, which a lazily loaded
    list understates, so it gives up early. Note the coordinate matcher used
    by `tap` is not accepted here — swipe wants an explicit start and end.
    """
    print(
        app.marionette(
            "swipe",
            startX=str(args.start[0]),
            startY=str(args.start[1]),
            endX=str(args.end[0]),
            endY=str(args.end[1]),
        )["message"]
    )


def cmd_back(app, args):
    print(app.marionette("pressBackButton")["message"])


def cmd_shot(app, args):
    shots = app.marionette("takeScreenshots")["screenshots"]
    first = shots[0]
    raw = base64.b64decode(first["data"] if isinstance(first, dict) else first)
    with open(args.path, "wb") as f:
        f.write(raw)
    print(f"{args.path}: {len(raw)} bytes")


def cmd_logs(app, args):
    print(json.dumps(app.marionette("getLogs"), ensure_ascii=False, indent=1))


def cmd_snapshot(app, args):
    params = {"includeValues": "true" if args.values else "false"}
    if args.filter:
        params["filter"] = args.filter
    print(
        json.dumps(
            app.call("ext.flutter.riverpod.snapshot", **params),
            ensure_ascii=False,
            indent=1,
        )
    )


def cmd_read(app, args):
    # 入れ子の ProviderScope にある provider は、同じ名前のものが複数のスコープ
    # で同時に生きうる。そのときは id (末尾に #scopeN が付く) で指定する。
    key = "id" if args.id else "name"
    value = args.id or args.name
    print(
        json.dumps(
            app.call("ext.flutter.riverpod.read", **{key: value}),
            ensure_ascii=False,
            indent=1,
        )
    )


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--uri", help="Dart VM Service base URI")
    sub = p.add_subparsers(dest="cmd", required=True)

    def with_matcher(sp):
        sp.add_argument("--text", help="match by visible text")
        sp.add_argument("--type", help="match by widget type, e.g. TextField")
        sp.add_argument("--key", help="match by widget key")
        sp.add_argument("--x", type=float)
        sp.add_argument("--y", type=float)
        return sp

    sub.add_parser("elements").set_defaults(fn=cmd_elements)
    with_matcher(sub.add_parser("tap")).set_defaults(fn=cmd_tap)
    t = with_matcher(sub.add_parser("text"))
    t.add_argument("--input", required=True)
    t.set_defaults(fn=cmd_text)
    sb = sub.add_parser("submit")
    sb.add_argument(
        "--action",
        default="done",
        choices=["done", "go", "search", "send", "next", "previous", "newline"],
    )
    sb.set_defaults(fn=cmd_submit)
    sw = sub.add_parser("swipe")
    sw.add_argument("--start", type=float, nargs=2, required=True, metavar=("X", "Y"))
    sw.add_argument("--end", type=float, nargs=2, required=True, metavar=("X", "Y"))
    sw.set_defaults(fn=cmd_swipe)
    sub.add_parser("back").set_defaults(fn=cmd_back)
    s = sub.add_parser("shot")
    s.add_argument("path")
    s.set_defaults(fn=cmd_shot)
    sub.add_parser("logs").set_defaults(fn=cmd_logs)
    sn = sub.add_parser("snapshot")
    sn.add_argument("--filter")
    sn.add_argument("--values", action="store_true", help="include provider values")
    sn.set_defaults(fn=cmd_snapshot)
    rd = sub.add_parser("read")
    rd.add_argument("name", nargs="?", help="provider name (ambiguous names are rejected)")
    rd.add_argument("--id", help="exact id from snapshot, e.g. fooProvider#scope3")
    rd.set_defaults(fn=cmd_read)

    args = p.parse_args()
    args.fn(App(resolve_uri(args.uri)), args)


if __name__ == "__main__":
    main()
