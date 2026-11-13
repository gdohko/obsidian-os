#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"
export DEBIAN_FRONTEND=noninteractive
ARCH=amd64
DIST=trixie
IMAGE_NAME=obsidian-os
VERSION="${OBSIDIAN_VERSION:-0.1.0}"
OUT_DIR="$ROOT/output"
mkdir -p "$OUT_DIR"

if [[ "$(dpkg --print-architecture 2>/dev/null || true)" != "$ARCH" ]]; then
  echo "Build must run on amd64." >&2
  exit 2
fi
if [[ $EUID -ne 0 ]]; then
  echo "Run as root (inside the GitHub Actions container this is automatic)." >&2
  exit 2
fi
for cmd in lb xorriso; do
  command -v "$cmd" >/dev/null || { echo "Missing build dependency: $cmd" >&2; exit 2; }
done

rm -rf config/binary config/chroot config/bootstrap config/source
lb clean --purge >/dev/null 2>&1 || true
lb config \
  --mode debian \
  --distribution "$DIST" \
  --architectures "$ARCH" \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware" \
  --security false \
  --apt-recommends true \
  --apt-indices false \
  --memtest none \
  --debian-installer live \
  --iso-volume "OBSIDIAN_OS_${VERSION}" \
  --iso-application "Obsidian OS Live" \
  --iso-publisher "Obsidian OS Project" \
  --iso-preparer "live-build" \
  --bootappend-live "boot=live components quiet splash username=obsidian hostname=obsidian"
lb build 2>&1 | tee "$OUT_DIR/build.log"

ISO="$(find "$ROOT" -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "$ISO" ]]; then
  echo "live-build completed but no ISO was found." >&2
  exit 1
fi
mv "$ISO" "$OUT_DIR/${IMAGE_NAME}-${VERSION}-amd64.iso"
(
  cd "$OUT_DIR"
  sha256sum "${IMAGE_NAME}-${VERSION}-amd64.iso" > "${IMAGE_NAME}-${VERSION}-amd64.iso.sha256"
)
echo "ISO created: $OUT_DIR/${IMAGE_NAME}-${VERSION}-amd64.iso"
