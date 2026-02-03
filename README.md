# Cluster Kernel Packaging

This repository packages and releases the optimized Linux kernel from Apple's containerization project.

## Quick start

1. Ensure Docker is available (GitHub-hosted Ubuntu runners work out of the box). On macOS, the script will use the Apple `container` tool if present.
2. Initialize the submodule.
3. Run the build.

```bash
git submodule update --init --recursive
./scripts/build-kernel.sh
```

Build output is staged in `dist/`.

## GitHub Actions

The workflows use GitHub-hosted Ubuntu runners and rely on Docker to build the kernel in the same containerized toolchain as upstream.

## Release flow

Renovate bumps the `containerization` submodule. Merges to `main` trigger a release tagged `containerization-<sha>` that includes the built `vmlinux` (and `config-arm64` when available).

## Renovate

Renovate is configured via `renovate.json` to keep the `containerization` git submodule updated. Review and merge those PRs to publish new kernel releases tied to the pinned upstream commit.
