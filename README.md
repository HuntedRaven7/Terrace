# Terrace

![Build](https://github.com/huntedraven7/terrace/workflows/Build/badge.svg)
![Validate](https://github.com/huntedraven7/terrace/workflows/Validate/badge.svg)
![Vulnerability Scan](https://github.com/huntedraven7/terrace/workflows/Vulnerability%20Scan/badge.svg)

Project Terrace is a BuildStream 2 factory for Free Desktop SDK bootc images, producing two OCI images:

- **Plateau** — Desktop image (Mango WM + Quickshell shell)
- **Strata** — Server image (k0s sysext + Kubestellar)

Assembled entirely from source with BuildStream 2 from freedesktop-sdk (FSDK 26.08).

## Images

| Image | Variant | Description |
|-------|---------|-------------|
| `plateau` | default | Mango 0.17.2 WM + Quickshell 0.3.1 shell |
| `plateau` | gaming | NVIDIA drivers + OGC kernel |
| `strata` | default | k0s sysext + Kubestellar + ucore base |

## Registry

```bash
# Testing (daily)
ghcr.io/huntedraven7/terrace/plateau:testing-26.08.1-x86_64-default
ghcr.io/huntedraven7/terrace/strata:testing-26.08.1-x86_64-default

# Stable (Friday promotion)
ghcr.io/huntedraven7/terrace/plateau:stable-26.08.1-x86_64-default
ghcr.io/huntedraven7/terrace/strata:stable-26.08.1-x86_64-default
```

## Quick Start

### Prerequisites
- Podman (rootless)
- Just >= 1.20
- Git
- Python3 >= 3.11

### Build Locally
```bash
git clone https://github.com/huntedraven7/terrace.git
cd terrace

# Validate build graph
just validate

# Build Plateau desktop
just build-plateau

# Build Strata server
just build-strata

# Build gaming variant (NVIDIA)
just build-plateau-gaming
```

### Boot with bootc
```bash
# Switch to Plateau testing
sudo bootc switch ghcr.io/huntedraven7/terrace/plateau:testing-26.08.1-x86_64-default

# Switch to Strata stable
sudo bootc switch ghcr.io/huntedraven7/terrace/strata:stable-26.08.1-x86_64-default
```

## Desktop (Plateau)

- **Window Manager**: Mango 0.17.2 (Sway-compatible)
- **Shell**: Quickshell 0.3.1 (declarative Wayland shell)
- **Launcher**: Rofi 1.7.5
- **Bar**: Awww 0.12.1
- **Audio**: PipeWire + WirePlumber
- **Clipboard**: wlclipboard
- **Terminal**: foot
- **File Manager**: thunar
- **Browser**: firefox

## Server (Strata)

- **Base**: uutils-coreutils, bash, minimal systemd
- **Container Runtime**: podman, buildah, skopeo, crun, runc, containerd
- **Kubernetes**: k0s (systemd-sysext), Kubestellar, kubectl, helm
- **Networking**: NetworkManager, firewalld, SSH (on-demand)
- **Filesystems**: btrfs, xfs, ext4, cryptsetup
- **OTA Updates**: systemd-sysupdate, systemd-repart

## Development

### Skills
Agent skills in `.agents/skills/`:
- `terrace-buildstream` — BST elements, junctions, patches
- `terrace-ci` — GitHub Actions, matrix builds
- `terrace-extensions` — Desktop config, dconf
- `terrace-factory` — Factory model, OCI assembly
- `terrace-image` — Boot testing, VM checks, OTA
- `terrace-packaging` — Go, Rust, C++ packaging
- `terrace-release` — Signing, promotion, rollback
- `terrace-review` — PR review, triage
- `terrace-ujust` — User recipes
- `terrace-workstation` — Host dev environment

### Documentation
- [Build Guide](docs/build.md)
- [CI Pipeline](docs/ci.md)
- [Factory Model](docs/factory.md)
- [OCI Assembly](docs/oci-assembly.md)
- [Patch Management](docs/patches.md)
- [PR Checklist](docs/pr-checklist.md)
- [Workflow](docs/workflow.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md) for the full contributor workflow.

## Security

See [SECURITY.md](SECURITY.md) for vulnerability disclosure policy.

## License

Apache-2.0 — see [LICENSE](LICENSE)