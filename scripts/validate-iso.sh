#!/usr/bin/env bash
set -Eeuo pipefail
ISO="${1:?Usage: validate-iso.sh path/to/image.iso}"
[[ -s "$ISO" ]] || { echo "ISO missing or empty: $ISO" >&2; exit 1; }
command -v xorriso >/dev/null || { echo "xorriso is required" >&2; exit 2; }
xorriso -indev "$ISO" -report_el_torito plain > /tmp/obsidian-el-torito.txt
cat /tmp/obsidian-el-torito.txt
grep -Eqi 'El Torito|Boot catalog' /tmp/obsidian-el-torito.txt
sha256sum "$ISO"
