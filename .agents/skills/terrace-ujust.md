# Terrace ujust Skill

## Overview

This skill covers end-user recipes in `files/just-overrides/default.just` for the Terrace images.

`ujust` is the user-facing command runner (aliased to `just --justfile /usr/share/ublue-os/justfile --working-directory /usr/share/ublue-os`). Terrace provides its own overrides in `files/just-overrides/default.just`.

## Plateau Recipes (Desktop)

### Session Management
```bash
# Start Mango session
ujust plateau-shell

# Start Quickshell session
ujust plateau-quickshell

# Development shell
ujust dev-shell
```

### System Info
```bash
# Show image info
ujust image-info
# Output: bootc status + /etc/os-release
```

### Maintenance
```bash
# Check for updates
ujust check-updates

# Apply updates
ujust update

# Rollback
ujust rollback
```

## Strata Recipes (Server)

### Server Management
```bash
# Show server status
ujust server-status

# Start k0s controller
ujust k0s-start

# Start k0s worker
ujust k0s-worker

# Start Kubestellar
ujust kubestellar-start

# SSH management (on-demand)
ujust ssh-enable
ujust ssh-disable
```

### System Info
```bash
# Show image info
ujust image-info

# Show k0s status
ujust k0s-status
```

## Recipe Structure

### File Location
- Source: `files/just-overrides/default.just`
- Installed to: `/usr/share/ublue-os/justfile.d/terrace.just`

### Recipe Format
```just
# Category: Description
recipe-name:
	@echo "Description..."
	command args
```

### Groups
```just
[group('desktop')]
plateau-shell:
	@mango

[group('server')]
k0s-start:
	@systemctl start k0s.service
```

## Common Tasks

### Add New Recipe
1. Edit `files/just-overrides/default.just`
2. Add to appropriate group
3. Test locally: `just -f files/just-overrides/default.just recipe-name`
4. Build image to verify installation

### Test Recipes in VM
```bash
just show-me-the-future-plateau
# In VM:
ujust --list
ujust plateau-shell
```

## Anti-patterns (DO NOT)
- ❌ Put system administration in user recipes (use systemd)
- ❌ Hardcode paths that differ between images
- ❌ Require root in user recipes
- ❌ Override core ublue-os recipes without need

## Related Files
- `files/just-overrides/default.just`
- `elements/plateau/desktop-base.bst` — Installs justfile
- `elements/strata/server-install.bst` — Installs justfile
- `projectbluefin/actions` — upstream just recipes