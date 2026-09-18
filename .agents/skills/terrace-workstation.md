# Terrace Workstation Skill

## Overview

This skill covers the host development environment for building Terrace images: BuildStream container, host dependencies, and local testing.

Terrace builds run inside the FSDK `bst2` container — BuildStream is not installed on the host.

## Host Requirements

### Required Tools
```bash
# Podman (rootless preferred)
podman --version  # >= 4.9

# Just (command runner)
just --version    # >= 1.20

# Git
git --version

# Python3 (for scripts)
python3 --version # >= 3.11
```

### Optional Tools
```bash
# QEMU/KVM for local boot testing
qemu-system-x86_64 --version
# OVMF firmware
ls /usr/share/edk2/ovmf/OVMF_CODE.fd

# Cosign for local signing
cosign version

# Skopeo for image inspection
skopeo --version
```

## BuildStream Container (bst2)

### Image
```bash
# Pinned SHA (same as Dakota CI)
registry.gitlab.com/freedesktop-sdk/infrastructure/freedesktop-sdk-docker-images/bst2:64eb0b4930d57a92710822898fb73af6cc1ae35d
```

### Justfile Wrapper
The `bst` recipe in `Justfile` runs bst inside the container:
```bash
just bst build elements/plateau/plateau.bst
just bst show --deps all elements/strata/strata.bst
just bst artifact checkout elements/plateau/plateau.bst --directory /tmp/out
```

### Container Configuration
```bash
# Runs with:
--privileged
--device /dev/fuse
--network=host
-v "${PWD}:/src:rw"
-v "${HOME}/.cache/buildstream:/root/.cache/buildstream:rw"
-w /src
```

### Cache Directory
- Host: `${HOME}/.cache/buildstream`
- Container: `/root/.cache/buildstream`
- Persists between builds

## Local Development Workflow

### Initial Setup
```bash
# Clone repo
git clone https://github.com/huntedraven7/terrace.git
cd terrace

# Validate
just validate

# Build Plateau
just build-plateau

# Build Strata
just build-strata
```

### Iterative Development
```bash
# Make changes to elements/
# Rebuild specific element
just bst build elements/plateau/mango.bst

# Rebuild full image
just build-plateau

# Test in QEMU
just show-me-the-future-plateau
```

### Debugging Build Failures
```bash
# Verbose output
just bst --colors build elements/plateau/plateau.bst --error-lines 500

# Inspect build directory
just bst shell elements/plateau/mango.bst
# Inside container: examine /builddir

# Check artifact
just bst artifact list elements/plateau/plateau.bst
just bst artifact checkout elements/plateau/plateau.bst --directory /tmp/out
```

## Host Podman Configuration

### Rootless (Preferred)
```bash
# Enable lingering for user services
loginctl enable-linger $USER

# Configure subuid/subgid
echo "$USER:100000:65536" | sudo tee -a /etc/subuid
echo "$USER:100000:65536" | sudo tee -a /etc/subgid

# Restart podman
systemctl --user restart podman
```

### BTRFS Storage (Optional, for performance)
```bash
# Create BTRFS pool
sudo btrfs subvolume create /var/lib/containers/storage

# Configure containers.conf
mkdir -p ~/.config/containers
cat > ~/.config/containers/storage.conf << EOF
[storage]
driver = "btrfs"
[storage.options.btrfs]
path = "/var/lib/containers/storage"
EOF
```

## QEMU Boot Testing

### Requirements
```bash
# Install
sudo dnf install qemu-system-x86_64 edk2-ovmf

# Or on Arch
sudo pacman -S qemu-base edk2-ovmf
```

### Run Test
```bash
# Plateau
just show-me-the-future-plateau

# Strata
just show-me-the-future-strata
```

### Test Script
The `show-me-the-future` recipe:
1. Builds and exports image
2. Creates QEMU disk images
3. Boots installer in QEMU
4. Boots installed system
5. Verifies services (Strata: KubeStellar console on :8080)

## Common Issues

### Permission Denied (Podman)
```bash
# Fix: ensure rootless works
podman info 2>/dev/null || sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER
newgrp $USER
```

### BuildStream Cache Corruption
```bash
# Nuke cache
rm -rf ~/.cache/buildstream
just validate
```

### QEMU No KVM
```bash
# Check KVM
ls -la /dev/kvm
# If missing: modprobe kvm_intel (or kvm_amd)
```

### OVMF Not Found
```bash
# Find OVMF
find /usr -name "OVMF_CODE.fd" 2>/dev/null
# Common paths:
# /usr/share/edk2/ovmf/OVMF_CODE.fd
# /usr/share/OVMF/OVMF_CODE.fd
# /usr/share/qemu/edk2-x86_64-code.fd
```

## Anti-patterns (DO NOT)
- ❌ Install BuildStream on host
- ❌ Run bst outside container
- ❌ Skip `just validate` before changes
- ❌ Use sudo with podman (rootless preferred)
- ❌ Modify container image directly

## Related Files
- `Justfile` — Build commands and bst wrapper
- `files/scripts/` — Helper scripts
- `.github/workflows/build.yml` — CI uses same bst2 image
- `projectbluefin/actions/bootc-build/setup-runner` — CI runner setup