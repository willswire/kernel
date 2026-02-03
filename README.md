# Cluster Kernel Packaging

This repository packages and releases the optimized Linux kernel from Apple's containerization project.

## Quick start

This repository builds in GitHub Actions only. Local build scripts have been removed.

1. Ensure the `containerization` submodule is initialized.
2. Push a branch or open a PR to trigger the build workflow.

```bash
git submodule update --init --recursive
```

## GitHub Actions

The workflows use GitHub-hosted Ubuntu runners and rely on Docker to build the kernel in the same containerized toolchain as upstream.

## Release flow

Renovate bumps the `containerization` submodule. Merges to `main` trigger a release tagged `containerization-<sha>` that includes the built `vmlinux` (and `config-arm64` when available).

## Renovate

Renovate is configured via `renovate.json` to keep the `containerization` git submodule updated. Review and merge those PRs to publish new kernel releases tied to the pinned upstream commit.
