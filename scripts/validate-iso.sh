#!/usr/bin/env bash
set -Eeuo pipefail

ISO="${1:?Usage: validate-iso.sh path/to/image.iso}"
[[ -s "$ISO" ]] || { echo "ISO missing or empty: $ISO" >&2; exit 1; }
command -v xorriso >/dev/null || { echo "xorriso is required" >&2; exit 2; }

REPORT="$(mktemp)"
trap 'rm -f "$REPORT"' EXIT
xorriso -indev "$ISO" -report_el_torito plain > "$REPORT"
cat "$REPORT"

grep -Eqi '^El Torito catalog[[:space:]]*:' "$REPORT" || {
  echo "El Torito boot catalog not found." >&2
  exit 1
}
grep -Eqi '^El Torito boot img[[:space:]]*:[[:space:]]*[0-9]+[[:space:]]+BIOS([[:space:]]|$)' "$REPORT" || {
  echo "Legacy BIOS boot entry not found in El Torito catalog." >&2
  exit 1
}
grep -Eqi '^El Torito boot img[[:space:]]*:[[:space:]]*[0-9]+[[:space:]]+UEFI([[:space:]]|$)' "$REPORT" || {
  echo "UEFI boot entry not found in El Torito catalog." >&2
  exit 1
}

echo "BIOS and UEFI boot entries confirmed."
sha256sum "$ISO"
