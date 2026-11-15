#!/bin/sh
set -eu

LAYOUT=/usr/share/obsidian/desktop/obsidian-plasma-layout.js
[ -r "$LAYOUT" ] || exit 0
sleep 8

if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
    plasma-apply-colorscheme BreezeDark >/dev/null 2>&1 || true
fi

SCRIPT_CONTENT="$(cat "$LAYOUT")"
attempt=0
while [ "$attempt" -lt 20 ]; do
    if qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$SCRIPT_CONTENT" >/dev/null 2>&1; then
        exit 0
    fi
    attempt=$((attempt + 1))
    sleep 2
done
exit 0
