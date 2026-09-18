# Terrace BuildStream Skill

## Overview

This skill covers BuildStream 2 (bst) element authoring, junction management, patch queues, and build graph debugging for the Terrace project.

Terrace uses BuildStream to assemble bootc OCI images from Free Desktop SDK (FSDK) 26.08.1 components. All image content comes from BST elements — no Containerfile package installation or post-build overlays.

## Key Concepts

### Element Types
- **`kind: junction`** — Repositories of elements (FSDK, gnome-build-meta, plugins)
- **`kind: stack`** — Dependency aggregation, no filesystem output
- **`kind: compose`** — OCI filesystem layer production
- **`kind: manual`** — Custom build/install commands
- **`kind: patch_queue`** — Ordered patch application

### Project Structure
```
elements/
├── freedesktop-sdk.bst          # FSDK 26.08.1 junction (pinned)
├── gnome-build-meta.bst         # GNOME build meta junction
├── plateau/                     # Desktop image elements
│   ├── deps.bst                 # Dependency stack
│   ├── plateau.bst              # Main image stack
│   ├── mango.bst                # Mango WM
│   ├── quickshell.bst           # Quickshell shell
│   ├── rofi.bst                 # Rofi launcher
│   ├── awww.bst                 # Awww bar
│   ├── pipewire.bst             # PipeWire audio stack
│   ├── wlclipboard.bst          # Wayland clipboard
│   └── desktop-base.bst         # Session/desktop config
├── strata/                      # Server image elements
│   ├── deps.bst                 # Dependency stack
│   ├── strata.bst               # Main image stack
│   ├── k0s-sysext.bst           # k0s systemd-sysext
│   ├── kubestellar.bst          # Kubestellar integration
│   ├── ucore-base.bst           # Minimal ucore base
│   └── server-install.bst       # Server setup
├── oci/                         # OCI assembly
│   ├── plateau.bst              # Plateau OCI layer
│   ├── strata.bst               # Strata OCI layer
│   ├── os-release.bst           # OS release metadata
│   └── chunkah/                 # Chunkah elements
├── core/                        # Shared core
│   ├── linux-fdsdk.bst          # FSDK kernel
│   ├── linux-ogc.bst            # OGC kernel (gaming)
│   └── ...
└── bluefin-nvidia/              # NVIDIA (gaming variant)
```

### Junctions
- **freedesktop-sdk.bst** — Pinned to `freedesktop-sdk-26.08.1` (same as Dakota)
- **gnome-build-meta.bst** — Pinned to matching GNOME 26.08 release
- **plugins/buildstream-plugins.bst** — Core build plugins
- **plugins/buildstream-plugins-community.bst** — Community plugins (cargo2, ostree, etc.)

### Overrides (freedesktop-sdk.bst)
Key overrides redirect FSDK components to gnome-build-meta equivalents:
- systemd, flatpak, xdg-desktop-portal → gnome-build-meta:core-deps
- GNOME libraries (gtk, glib, pango, etc.) → gnome-build-meta:sdk
- Kernel → core/linux-fdsdk.bst (or linux-ogc.bst for gaming)

## Common Tasks

### Validate Build Graph
```bash
just validate
# Runs: just bst show --deps all elements/plateau/plateau.bst
#       just bst show --deps all elements/strata/strata.bst
```

### Build Image
```bash
# Plateau desktop
just bst build elements/plateau/plateau.bst --option arch x86_64 --option gaming false

# Strata server
just bst build elements/strata/strata.bst --option arch x86_64 --option gaming false

# Gaming variant (NVIDIA)
just bst build elements/plateau/plateau.bst --option arch x86_64 --option gaming true
```

### Inspect Element
```bash
just bst show elements/plateau/mango.bst
just bst show --deps elements/plateau/deps.bst
just bst artifact list elements/plateau/plateau.bst
```

### Patch Management
Patches live in `patches/` directory, applied via `patch_queue` in junctions:
```
patches/
├── freedesktop-sdk/
│   ├── 0001-fix-something.patch
│   └── series
└── linux/
    └── ...
```

## Anti-patterns (DO NOT)
- ❌ Add package installation to Containerfile
- ❌ Use `dnf`/`rpm-ostree` in elements
- ❌ Edit staged junction contents directly (use patch_queue)
- ❌ Use mutable refs (branches) — pin to commit SHAs
- ❌ Network access in build commands
- ❌ Timestamps, hostname, user identity in build

## Debugging
```bash
# Verbose build with error context
just bst --colors build elements/plateau/plateau.bst --error-lines 500

# Artifact inspection
just bst artifact checkout elements/plateau/plateau.bst --directory /tmp/out

# Dependency graph
just bst show --deps all elements/plateau/plateau.bst | grep -E "(plateau|strata)"
```

## Related Files
- `project.conf` — Project configuration, options, artifacts, plugins
- `include/aliases.yml` — Element aliases
- `include/os-release.yml` — OS release metadata
- `plugins/chunkah-ownership.py` — Chunkah ownership plugin