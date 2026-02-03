#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUBMODULE_DIR="${ROOT_DIR}/containerization"
KERNEL_DIR="${SUBMODULE_DIR}/kernel"
DIST_DIR="${ROOT_DIR}/dist"

if [ ! -d "${SUBMODULE_DIR}" ]; then
  git submodule update --init --recursive
fi

KSOURCE=$(awk -F '\\?=' '/^KSOURCE/ {print $2}' "${KERNEL_DIR}/Makefile" | xargs)
KIMAGE=$(awk -F '\\?=' '/^KIMAGE/ {print $2}' "${KERNEL_DIR}/Makefile" | xargs)
HOST_CPUS=$(getconf _NPROCESSORS_ONLN 2>/dev/null || nproc || echo 2)
DEFAULT_CPUS=$(( HOST_CPUS < 8 ? HOST_CPUS : 8 ))
KBUILD_CPUS="${KBUILD_CPUS:-${DEFAULT_CPUS}}"
KBUILD_MEMORY="${KBUILD_MEMORY:-16g}"

if command -v container >/dev/null 2>&1; then
  make -C "${KERNEL_DIR}"
elif command -v docker >/dev/null 2>&1; then
  docker build "${KERNEL_DIR}/image" -f "${KERNEL_DIR}/image/Dockerfile" -t "${KIMAGE}"

  if [ ! -f "${KERNEL_DIR}/source.tar.xz" ]; then
    curl -SsL -o "${KERNEL_DIR}/source.tar.xz" "${KSOURCE}"
  fi

  docker run \
    --cpus "${KBUILD_CPUS}" \
    --rm \
    --memory "${KBUILD_MEMORY}" \
    -v "${KERNEL_DIR}":/kernel \
    --workdir /kernel \
    "${KIMAGE}" \
    /bin/bash -c "./build.sh"
else
  echo "error: requires 'container' (macOS) or 'docker' (Linux)." >&2
  exit 1
fi

mkdir -p "${DIST_DIR}"
cp "${KERNEL_DIR}/vmlinux" "${DIST_DIR}/vmlinux"
if [ -f "${KERNEL_DIR}/config-arm64" ]; then
  cp "${KERNEL_DIR}/config-arm64" "${DIST_DIR}/config-arm64"
fi

git -C "${SUBMODULE_DIR}" rev-parse HEAD > "${DIST_DIR}/upstream-commit.txt"

date -u "+%Y-%m-%dT%H:%M:%SZ" > "${DIST_DIR}/build-timestamp.txt"
