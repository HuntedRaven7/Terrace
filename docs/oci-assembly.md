# OCI Assembly

## Overview

Terrace images are assembled as OCI filesystem layers via BuildStream `kind: compose` elements, then published to GHCR as multi-arch manifests for bootc consumption.

## Compose Elements

### Plateau (`elements/oci/plateau.bst`)
```yaml
kind: compose
depends:
- plateau/deps.bst

config:
  install-commands:
  - bst-artifact-install plateau/deps.bst ${DESTDIR}
  - write /etc/os-release
  - write /etc/bootc/bootc.json
  - enable systemd services
  - copy files/
```

### Strata (`elements/oci/strata.bst`)
```yaml
kind: compose
depends:
- strata/deps.bst

config:
  install-commands:
  - bst-artifact-install strata/deps.bst ${DESTDIR}
  - write /etc/os-release (variant=strata)
  - write /etc/bootc/bootc.json
  - enable systemd services (no SSH by default)
  - copy files/
```

## Output Structure

Each compose produces an OCI layout:
```
oci-layout/
├── blobs/
│   └── sha256/
│       ├── <config>
│       └── <layer.tar>
├── oci-layout
└── refs/
    └── latest
```

## Multi-Arch Manifests

CI creates manifest indexes:
```bash
# Manifest list for plateau:testing-26.08.1-x86_64-default
# Contains: x86_64, x86_64_v3 platform-specific images
```

## bootc Integration

### bootc.json
```json
{
  "bootc": {
    "version": "26.08.1",
    "image": "ghcr.io/huntedraven7/terrace/plateau",
    "variant": "plateau"
  }
}
```

### os-release
```
VARIANT="plateau"
VARIANT_ID="plateau"
```

## Tagging Strategy

| Tag | Description |
|-----|-------------|
| `testing-{version}-{arch}-{variant}` | Daily build |
| `stable-{version}-{arch}-{variant}` | Friday promoted |
| `latest-{arch}-{variant}` | Alias to latest testing |

## Chunkah Rechunking

OCI layer optimization for efficient deltas:
```bash
# In CI: projectbluefin/actions/bootc-build/chunka
# Reorganizes layers for maximum reuse
# Reduces download size on bootc upgrade
```

## Image Inspection

```bash
# Manifest
skopeo inspect docker://ghcr.io/huntedraven7/terrace/plateau:testing-26.08.1-x86_64-default

# Config
skopeo inspect --raw docker://... | jq '.config'

# Layers
skopeo inspect --raw docker://... | jq '.layers[]'
```

## Export for Offline

```bash
just export-plateau
# Creates: dist/oci/plateau/ with OCI layout

# Or manual:
just bst artifact checkout elements/plateau/plateau.bst --directory /tmp/out
```

## Related Files
- `elements/oci/plateau.bst`
- `elements/oci/strata.bst`
- `elements/oci/os-release.bst`
- `include/os-release.yml`
- `.github/workflows/build.yml` (push, manifest, sign)
- `projectbluefin/actions/bootc-build/chunka`