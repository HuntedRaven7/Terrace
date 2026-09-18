# Terrace Factory Skill

## Overview

This skill covers the Terrace factory model: OCI layer composition, boot testing, VM checks, OTA updates, and the overall image assembly pipeline.

Terrace follows the Project Bluefin Dakota factory model: BuildStream assembles OCI layers from FSDK components, which are then published as bootc images to GHCR.

## Factory Model Invariants

### BuildStream → OCI Pipeline
1. **BST Elements** define all package builds and compositions
2. **`kind: compose`** elements produce OCI filesystem layers
3. **OCI layers** are pushed to GHCR as multi-arch manifests
4. **bootc** consumes OCI images for boot/upgrade

### Image Variants
| Image | Purpose | Base |
|-------|---------|------|
| `plateau` | Desktop (Mango + Quickshell) | FSDK runtime + desktop stack |
| `strata` | Server (k0s + Kubestellar) | FSDK runtime + server stack |

### Build Options
- **`arch`**: `x86_64` (default), `x86_64_v3`
- **`gaming`**: `false` (default), `true` (NVIDIA + OGC kernel)
- **`x86_64_v3`**: `true` (default, per user request)

### OCI Layer Composition
Each image is a `kind: compose` element that:
1. Installs base from dependency stack (`bst-artifact-install`)
2. Writes `/etc/os-release` with correct variant
3. Writes `/etc/bootc/bootc.json` metadata
4. Enables required systemd services
5. Copies `/src/files/*` to image root

### Boot Testing
```bash
# Local QEMU smoke test
just show-me-the-future-plateau
just show-me-the-future-strata

# CI: e2e.yml workflow
```

### OTA Updates
- Images published to GHCR with semantic tags
- `bootc upgrade` pulls new image
- `bootc status` shows current/pending
- Rollback via `bootc rollback`

### Chunkah Rechunking
OCI layer optimization for efficient deltas:
- `projectbluefin/actions/bootc-build/chunka` in CI
- Reorganizes layers for maximum reuse
- Reduces download size on upgrade

## Common Tasks

### Build All Images Locally
```bash
just build-all
# Or individually:
just build-plateau
just build-strata
```

### Test Boot in QEMU
```bash
just show-me-the-future-plateau
just show-me-the-future-strata
```

### Export Artifacts
```bash
just export-plateau
just export-strata
```

### Inspect OCI Layout
```bash
skopeo inspect docker://ghcr.io/huntedraven7/terrace/plateau:testing-26.08.1-x86_64-default
```

## Anti-patterns (DO NOT)
- ❌ Add packages via Containerfile
- ❌ Use `dnf`/`rpm-ostree` for image content
- ❌ Bypass BuildStream for any image content
- ❌ Hardcode image references in elements
- ❌ Skip boot testing before publish

## Related Files
- `elements/oci/plateau.bst` — Plateau OCI assembly
- `elements/oci/strata.bst` — Strata OCI assembly
- `elements/oci/os-release.bst` — OS release metadata
- `elements/oci/chunkah/` — Chunkah elements
- `files/` — System files copied to image
- `.github/workflows/build.yml` — CI build pipeline
- `.github/workflows/execute-release.yml` — Stable promotion