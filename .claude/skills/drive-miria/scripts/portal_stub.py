#!/usr/bin/env python3
"""Headless stand-in for org.freedesktop.portal.Desktop's FileChooser.

file_picker >= 12 on Linux does not draw a dialog of its own: it calls
OpenFile/SaveFile on the XDG desktop portal over the session bus and waits for
the portal's Request.Response signal. That makes the picker scriptable — this
serves the portal side and answers with whatever paths were armed beforehand.
"""

import json
import os
import sys
import threading
import time

from jeepney import DBusAddress, MessageType, new_error, new_method_return, new_signal
from jeepney.bus_messages import DBusNameFlags, message_bus
from jeepney.io.blocking import open_dbus_connection

BUS_NAME = "org.freedesktop.portal.Desktop"
OBJ_PATH = "/org/freedesktop/portal/desktop"
IFACE = "org.freedesktop.portal.FileChooser"

STATE_DIR = os.environ.get("PORTAL_STUB_DIR", "/tmp/marionette-portal")
ANSWER = os.path.join(STATE_DIR, "answer.json")
LOG = os.path.join(STATE_DIR, "requests.log")
# The client subscribes to the Response signal only after OpenFile returns,
# so answering instantly races the match rule being installed.
DELAY = float(os.environ.get("PORTAL_STUB_DELAY", "0.6"))


def log(entry):
    entry["ts"] = time.time()
    with open(LOG, "a") as fh:
        fh.write(json.dumps(entry, ensure_ascii=False) + "\n")


def read_answer():
    """Consume the armed answer. Missing/empty file == user pressed cancel."""
    try:
        with open(ANSWER) as fh:
            data = json.load(fh)
    except (OSError, ValueError):
        return None
    if data.get("once", True):
        try:
            os.remove(ANSWER)
        except OSError:
            pass
    return data


def respond(conn, req_path, answer):
    time.sleep(DELAY)
    addr = DBusAddress(req_path, interface="org.freedesktop.portal.Request")
    if answer is None:
        code, results = 1, {}          # 1 == cancelled by the user
    else:
        uris = ["file://" + os.path.abspath(p) for p in answer.get("paths", [])]
        code, results = 0, {"uris": ("as", uris)}
    conn.send(new_signal(addr, "Response", "ua{sv}", (code, results)))
    log({"event": "response", "handle": req_path, "code": code,
         "uris": list(results.get("uris", ("as", []))[1])})


def main():
    os.makedirs(STATE_DIR, exist_ok=True)
    conn = open_dbus_connection(bus="SESSION")
    reply = conn.send_and_get_reply(
        message_bus.RequestName(BUS_NAME, DBusNameFlags.do_not_queue)
    )
    if reply.body[0] != 1:  # 1 == primary owner
        sys.exit(f"could not own {BUS_NAME}: RequestName returned {reply.body[0]}")
    print(f"portal stub owning {BUS_NAME}; state in {STATE_DIR}", flush=True)

    serial = 0
    while True:
        msg = conn.receive()
        if msg.header.message_type != MessageType.method_call:
            continue
        member = msg.header.fields.get(3)   # MEMBER
        iface = msg.header.fields.get(2)    # INTERFACE
        sender = msg.header.fields.get(7)   # SENDER

        if iface == "org.freedesktop.DBus.Peer" and member == "Ping":
            conn.send(new_method_return(msg, "", ()))
            continue

        if iface == IFACE and member in ("OpenFile", "SaveFile"):
            _parent, title, options = msg.body
            opts = {k: v[1] for k, v in options.items()}
            serial += 1
            token = opts.get("handle_token", "t") or "t"
            # os.getpid() keeps handles unique across stub restarts: a client
            # still awaiting a lost Response would otherwise match a reused
            # path and complete a second time off someone else's answer.
            req_path = (f"{OBJ_PATH}/request/"
                        f"{sender.replace(':', '_').replace('.', '_')}/"
                        f"{token}_{os.getpid()}_{serial}")
            log({"event": member, "title": title, "handle": req_path,
                 "multiple": bool(opts.get("multiple", False)),
                 "directory": bool(opts.get("directory", False))})
            conn.send(new_method_return(msg, "o", (req_path,)))
            answer = read_answer()
            threading.Thread(target=respond, args=(conn, req_path, answer),
                             daemon=True).start()
            continue

        if iface == "org.freedesktop.portal.Request" and member == "Close":
            conn.send(new_method_return(msg, "", ()))
            continue

        conn.send(new_error(msg, "org.freedesktop.DBus.Error.UnknownMethod",
                            "s", (f"{iface}.{member} not implemented by stub",)))


if __name__ == "__main__":
    main()
