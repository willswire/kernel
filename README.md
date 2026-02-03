# Cluster Kernel Packaging

This repository packages and releases the optimized Linux kernel from Apple's containerization project.

## Quick start

Builds run in GitHub Actions only; local build scripts have been removed.

1. Initialize the `containerization` submodule.
2. Push a branch or open a PR to trigger the workflow.

```bash
git submodule update --init --recursive
```

## GitHub Actions

Workflows use GitHub-hosted Ubuntu 22.04 ARM runners and build the kernel directly on the runner (no containerized build).

## Release flow

Renovate bumps the `containerization` submodule. Merges to `main` trigger a release tagged `containerization-<sha>` that includes the built `vmlinux` (and `config-arm64` when available).

## Renovate

Renovate is configured via `renovate.json` to keep the `containerization` git submodule updated. Review and merge those PRs to publish new kernel releases tied to the pinned upstream commit.
