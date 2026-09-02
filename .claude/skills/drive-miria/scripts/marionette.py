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

    def vm(self, method, **params):
        """A VM Service RPC that is not scoped to an isolate."""
        result = self._get(method, params)
        if "error" in result:
            raise SystemExit(json.dumps(result["error"], ensure_ascii=False, indent=1))
        return result["result"]

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
    print(
        json.dumps(
            app.call("ext.flutter.riverpod.read", name=args.name),
            ensure_ascii=False,
            indent=1,
        )
    )


def _mib(n):
    return f"{n / 1024 / 1024:.1f}MiB"


def cmd_mem(app, args):
    """Memory as the VM sees it: process RSS, then the Dart heap inside it.

    RSS is what the OS charges the app; the Dart heap is usually a fraction of
    it, with decoded images and GPU-side buffers living outside. A leak that
    only shows in RSS is not a Dart-object leak.
    """
    process = app.vm("getProcessMemoryUsage")["root"]
    usage = app.call("getMemoryUsage")
    print(f"rss            {_mib(process['size'])}")
    # 子は数百件ある mmap の内訳なので、目に留まる大きさのものだけ。
    children = sorted(process.get("children", []), key=lambda c: -c["size"])
    for child in children[: args.top]:
        if child["size"] < 1024 * 1024:
            break
        print(f"  {child['name'].split('/')[-1][:44]:44} {_mib(child['size'])}")
    print(f"dart heap      {_mib(usage['heapUsage'])} "
          f"(capacity {_mib(usage['heapCapacity'])}, "
          f"external {_mib(usage['externalUsage'])})")


def cmd_alloc(app, args):
    """Live Dart objects by class. `--gc` collects first, so what is left is
    genuinely reachable — the honest way to ask "is this screen still holding
    every tile it ever built?".
    """
    profile = app.call("getAllocationProfile", gc="true" if args.gc else "false")
    members = profile["members"]
    if args.filter:
        needle = args.filter.lower()
        members = [m for m in members if needle in m["class"].get("name", "").lower()]
    members.sort(key=lambda m: -m["bytesCurrent"])
    print(f"{'class':44} {'instances':>10} {'bytes':>12}")
    for m in members[: args.top]:
        print(f"{m['class'].get('name', '')[:44]:44} "
              f"{m['instancesCurrent']:>10} {m['bytesCurrent']:>12}")


def cmd_frames(app, args):
    """Frame times the engine reported, split into UI and raster.

    Registered by lib/marionette_debug.dart. A still screen produces no
    frames, so reset, scroll, then read.
    """
    print(json.dumps(
        app.call("ext.flutter.perf.frames", reset="true" if args.reset else "false"),
        ensure_ascii=False, indent=1))


def cmd_imagecache(app, args):
    """Flutter's decoded-image cache. Registered by lib/marionette_debug.dart."""
    print(json.dumps(
        app.call("ext.flutter.perf.imageCache",
                 clear="true" if args.clear else "false"),
        ensure_ascii=False, indent=1))


def cmd_tree(app, args):
    """Element and render-object counts, and the widget types that dominate.

    Watch this while scrolling: a lazily built list holds it steady, a list
    that materializes everything grows without bound. Registered by
    lib/marionette_debug.dart.
    """
    params = {"top": str(args.top)}
    if args.filter:
        params["filter"] = args.filter
    print(json.dumps(app.call("ext.flutter.perf.tree", **params),
                     ensure_ascii=False, indent=1))


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
    me = sub.add_parser("mem")
    me.add_argument("--top", type=int, default=8, help="how many mappings to list")
    me.set_defaults(fn=cmd_mem)
    al = sub.add_parser("alloc")
    al.add_argument("--top", type=int, default=20)
    al.add_argument("--filter", help="only classes whose name contains this")
    al.add_argument("--gc", action="store_true", help="collect before measuring")
    al.set_defaults(fn=cmd_alloc)
    fr = sub.add_parser("frames")
    fr.add_argument("--reset", action="store_true", help="empty the buffer after reading")
    fr.set_defaults(fn=cmd_frames)
    ic = sub.add_parser("imagecache")
    ic.add_argument("--clear", action="store_true", help="evict everything after reading")
    ic.set_defaults(fn=cmd_imagecache)
    tr = sub.add_parser("tree")
    tr.add_argument("--top", type=int, default=15)
    tr.add_argument("--filter", help="only widget types whose name contains this")
    tr.set_defaults(fn=cmd_tree)
    rd = sub.add_parser("read")
    rd.add_argument("name")
    rd.set_defaults(fn=cmd_read)

    args = p.parse_args()
    args.fn(App(resolve_uri(args.uri)), args)


if __name__ == "__main__":
    main()
