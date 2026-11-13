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

[[ "$(dpkg --print-architecture)" == "$ARCH" ]] || { echo "Build host must be amd64." >&2; exit 2; }
[[ $EUID -eq 0 ]] || { echo "Run as root." >&2; exit 2; }
for cmd in lb xorriso; do command -v "$cmd" >/dev/null || { echo "Missing dependency: $cmd" >&2; exit 2; }; done

rm -rf config/binary config/chroot config/bootstrap config/source
lb clean --purge >/dev/null 2>&1 || true

lb config \
  --mode debian \
  --distribution "$DIST" \
  --architectures "$ARCH" \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware" \
  --mirror-bootstrap "http://deb.debian.org/debian/" \
  --mirror-chroot "http://deb.debian.org/debian/" \
  --mirror-chroot-security "http://deb.debian.org/debian-security/" \
  --mirror-binary "http://deb.debian.org/debian/" \
  --mirror-binary-security "http://deb.debian.org/debian-security/" \
  --security true \
  --linux-packages none \
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
[[ -n "$ISO" ]] || { echo "Build ended without an ISO." >&2; exit 1; }
mv "$ISO" "$OUT_DIR/${IMAGE_NAME}-${VERSION}-amd64.iso"
(
  cd "$OUT_DIR"
  sha256sum "${IMAGE_NAME}-${VERSION}-amd64.iso" > "${IMAGE_NAME}-${VERSION}-amd64.iso.sha256"
)
echo "ISO created: $OUT_DIR/${IMAGE_NAME}-${VERSION}-amd64.iso"
