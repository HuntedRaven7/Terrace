# Building Terrace Images

## Prerequisites

- Podman (rootless preferred)
- Just >= 1.20
- Git
- Python3 >= 3.11
- QEMU/KVM (for boot testing)

## Quick Start

```bash
# Clone repository
git clone https://github.com/huntedraven7/terrace.git
cd terrace

# Validate build graph
just validate

# Build Plateau desktop image
just build-plateau

# Build Strata server image
just build-strata

# Build all images
just build-all
```

## Build Options

### Architecture
```bash
# x86_64 (default)
just build-plateau

# x86_64_v3
just bst build elements/plateau/plateau.bst --option arch x86_64 --option x86_64_v3 true
```

### Gaming Variant (NVIDIA)
```bash
# Plateau with NVIDIA drivers
just bst build elements/plateau/plateau.bst --option arch x86_64 --option gaming true --option x86_64_v3 true
```

### Variant Selection
```bash
# Plateau default
just bst build elements/plateau/plateau.bst --option arch x86_64 --option gaming false

# Plateau gaming
just bst build elements/plateau/plateau.bst --option arch x86_64 --option gaming true

# Strata (no gaming variant)
just bst build elements/strata/strata.bst --option arch x86_64
```

## Build Commands

### Justfile Targets
```bash
just --list                    # List all commands
just validate                  # Validate build graph
just build-plateau             # Build Plateau image
just build-strata              # Build Strata image
just build-all                 # Build all images
just push-plateau              # Push Plateau to GHCR
just push-strata               # Push Strata to GHCR
just promote-stable            # Promote to stable
just test                      # Run test suite
just test-unit                 # Run unit tests
just show-me-the-future-plateau # QEMU test Plateau
just show-me-the-future-strata  # QEMU test Strata
just export-plateau            # Export Plateau artifacts
just export-strata             # Export Strata artifacts
```

### Direct BuildStream
```bash
# Build with custom options
just bst build elements/plateau/plateau.bst \
  --option arch x86_64 \
  --option gaming false \
  --option x86_64_v3 true

# Show dependency graph
just bst show --deps all elements/plateau/plateau.bst

# Inspect element
just bst show elements/plateau/mango.bst

# List artifacts
just bst artifact list elements/plateau/plateau.bst

# Checkout artifact
just bst artifact checkout elements/plateau/plateau.bst --directory /tmp/out
```

## Image Output

Built images are available as OCI artifacts in the BuildStream cache. To export:
```bash
just export-plateau
# Output: dist/oci/plateau/

just export-strata
# Output: dist/oci/strata/
```

## CI/CD

Images are automatically built and published via GitHub Actions:
- **On push/PR**: `build.yml` runs validation and builds changed images
- **Daily**: `sync-next.yml` syncs testing → next branch
- **Friday 6 AM UTC**: `execute-release.yml` promotes testing → stable
- **On dispatch**: `publish.yml` for manual publishing

## Troubleshooting

### BuildStream Cache Issues
```bash
# Clear cache
rm -rf ~/.cache/buildstream
just validate
```

### Podman Permission Issues
```bash
# Ensure rootless works
podman info
# If fails, check subuid/subgid
```

### Missing Dependencies
```bash
# Re-fetch sources
just bst source checkout elements/plateau/mango.bst
```

## Related Documentation
- [CI Pipeline](ci.md)
- [OCI Assembly](oci-assembly.md)
- [Factory Model](factory.md)