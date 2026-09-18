# Terrace Factory Model

## Overview

Terrace follows the Project Bluefin Dakota factory model: a BuildStream 2 factory producing bootc OCI images from Free Desktop SDK components.

## Factory Invariants

### 1. BuildStream is the Only Package Mechanism
- All image content comes from BST elements
- No Containerfile package installation
- No rpm-ostree post-build overlays
- No COPRs or external repos in image build

### 2. OCI Layer Composition
- `kind: compose` elements produce OCI filesystem layers
- `kind: stack` elements aggregate dependencies (no filesystem output)
- Each image variant has its own compose element

### 3. Deterministic Builds
- No network access in build commands
- No timestamps, hostname, user identity
- Pin all sources to commit SHAs (not branches)
- FSDK junction pinned to exact commit

### 4. Shared Cache Infrastructure
- GNOME BuildStream CAS: `https://gbm.gnome.org:11003`
- Project Bluefin Cache: `https://cache.projectbluefin.io:11001`
- Both as artifacts and source-caches

### 5. Version Single Source of Truth
- FSDK version from `freedesktop-sdk.bst` ref
- Propagated to os-release, bootc.json, tags
- Validated by `check-release-version.py`

### 6. Security by Default
- Cosign signing for stable releases
- SBOM generation (syft)
- SLSA Build L2 provenance
- Trivy vulnerability scanning
- Chunkah OCI rechunking for supply chain

## Image Variants

### Plateau (Desktop)
- **WM**: Mango 0.17.2
- **Shell**: Quickshell 0.3.1
- **Launcher**: Rofi 1.7.5
- **Bar**: Awww 0.12.1
- **Audio**: PipeWire + WirePlumber
- **Clipboard**: wlclipboard
- **Terminal**: foot
- **File Manager**: thunar
- **Browser**: firefox

### Strata (Server)
- **Base**: uutils-coreutils, bash, minimal systemd
- **Container**: podman, buildah, skopeo, crun, runc, containerd
- **Kubernetes**: k0s (sysext), Kubestellar, kubectl, helm
- **Networking**: NetworkManager, firewalld, SSH (on-demand)
- **Filesystems**: btrfs, xfs, ext4, cryptsetup
- **OTA**: systemd-sysupdate, systemd-repart

### Gaming Variant (NVIDIA)
- OGC kernel (linux-ogc)
- NVIDIA kernel modules
- NVIDIA userspace drivers
- Enabled via `--option gaming true`

## Build Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `arch` | x86_64 | x86_64 | Machine architecture |
| `x86_64_v3` | true/false | true | Enable x86_64-v3 |
| `gaming` | true/false | false | Gaming variant (NVIDIA) |

## Artifact Flow

```
BST Elements → kind:compose → OCI Layers → GHCR (multi-arch manifest)
                                    ↓
                            bootc upgrade ← User machines
```

## Promotion Flow

```
testing (daily) → [Friday: tests pass] → stable + latest
                                    ↓
                            GitHub Release + Changelog
```

## Anti-patterns (DO NOT)
- ❌ Add packages via Containerfile
- ❌ Use mutable refs (branches) in junctions
- ❌ Skip boot testing before publish
- ❌ Publish unsigned images as stable
- ❌ Hardcode registry/image names in elements
- ❌ Bypass BuildStream for any image content

## Related Files
- `project.conf` — Project configuration
- `elements/oci/plateau.bst` — Plateau OCI compose
- `elements/oci/strata.bst` — Strata OCI compose
- `.github/workflows/build.yml` — Build pipeline
- `.github/workflows/execute-release.yml` — Promotion
- `.github/image-variants.json` — Build matrix