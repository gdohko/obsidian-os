#!/usr/bin/env python3
"""Booted Sapphire OS VNC capture helper for GitHub Actions."""
import os
import sys
import time
from pathlib import Path

from vncdotool import api

OUT = Path("screenshots")
OUT.mkdir(exist_ok=True)
HOST, PORT = "127.0.0.1", 5900

client = None
deadline = time.time() + 300
while time.time() < deadline:
    try:
        client = api.connect(HOST, PORT)
        break
    except Exception:
        time.sleep(5)

if client is None:
    raise SystemExit("QEMU VNC did not become available within 5 minutes")

try:
    # Allow GRUB, live boot, SDDM autologin and Plasma startup to complete.
    time.sleep(210)
    client.captureScreen(str(OUT / "01-sapphire-kde-plasma.png"))
    print("Captured KDE/Plasma desktop.")

    # The live image includes XFCE alongside Plasma. Ask the running graphical
    # session to replace its desktop session with XFCE for a second real capture.
    client.keyPress("ctrl-alt-t")
    time.sleep(3)
    client.typeText("xfce4-session --replace")
    client.keyPress("enter")
    time.sleep(60)
    client.captureScreen(str(OUT / "02-sapphire-xfce.png"))
    print("Captured post-switch desktop (XFCE session launch requested).")
finally:
    client.disconnect()
