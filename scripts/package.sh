#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
OUT_DIR="${ROOT_DIR}/out"
VERSION="${1:-dev-$(date -u +%Y%m%d%H%M%S)}"
ARCHIVE_BASENAME="containerization-kernel-${VERSION}"

if [ ! -d "${DIST_DIR}" ] || [ ! -f "${DIST_DIR}/vmlinux" ]; then
  echo "error: dist/ not found or vmlinux missing. Run build first." >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"

FILES=(vmlinux upstream-commit.txt build-timestamp.txt)
if [ -f "${DIST_DIR}/config-arm64" ]; then
  FILES+=(config-arm64)
fi

tar -C "${DIST_DIR}" -czf "${OUT_DIR}/${ARCHIVE_BASENAME}.tar.gz" "${FILES[@]}"
