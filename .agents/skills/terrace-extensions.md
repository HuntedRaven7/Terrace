# Terrace Extensions Skill

## Overview

This skill covers GNOME Shell extensions, ESM modules, and dconf defaults for the Terrace Plateau desktop image.

Plateau uses Mango WM + Quickshell as the primary desktop, not GNOME Shell. However, some GNOME components and GTK configuration are still relevant for GTK applications running on the desktop.

## Desktop Stack

### Window Manager: Mango
- **Source**: https://github.com/mangowm/mango
- **Version**: 0.17.2 (pinned)
- **Type**: Sway-compatible Wayland compositor
- **Config**: `~/.config/mango/config`

### Shell: Quickshell
- **Source**: https://github.com/quickshell-mirror/quickshell
- **Version**: 0.3.1 (pinned)
- **Type**: Declarative shell for Wayland compositors
- **Config**: `~/.config/quickshell/`

### Launcher: Rofi
- **Source**: https://github.com/davatorium/rofi
- **Version**: 1.7.5
- **Config**: `~/.config/rofi/config.rasi`

### Bar: Awww
- **Source**: https://codeberg.org/LGFae/awww
- **Version**: 0.12.1 (pinned via tarball)
- **Type**: Wayland bar/widget system

### GTK/dconf Defaults
Even though Plateau doesn't use GNOME Shell, GTK applications need consistent theming:

```ini
# /etc/dconf/db/local.d/99-terrace-desktop
[org/gnome/desktop/interface]
gtk-theme='Adwaita-dark'
icon-theme='Adwaita'
cursor-theme='Adwaita'
font-name='JetBrains Mono 10'
monospace-font-name='JetBrains Mono 10'

[org/gnome/desktop/wm/preferences]
focus-mode='click'
titlebar-font='JetBrains Mono Bold 10'
```

### Wayland Session Files
Created by `plateau/desktop-base.bst`:
- `/usr/share/wayland-sessions/mango.desktop`
- `/usr/share/wayland-sessions/quickshell.desktop`

### Autostart Services
- `pipewire` — Audio server
- `wireplumber` — Session manager
- `xdg-desktop-portal` — Desktop portal
- `xdg-desktop-portal-wlr` — WLR portal backend

## Common Tasks

### Test Desktop Defaults
```bash
python3 scripts/test_desktop_defaults.py
```

### Verify Session Files
```bash
ls -la /usr/share/wayland-sessions/
# Should show mango.desktop and quickshell.desktop
```

### Check dconf
```bash
dconf dump /org/gnome/desktop/interface/
```

## Anti-patterns (DO NOT)
- ❌ Install GNOME Shell extensions (not used)
- ❌ Configure GNOME Shell specific settings
- ❌ Assume GNOME Shell is running
- ❌ Hardcode user-specific paths in system config

## Related Files
- `elements/plateau/desktop-base.bst` — Session/dconf config
- `elements/plateau/mango.bst` — Mango WM build
- `elements/plateau/quickshell.bst` — Quickshell build
- `elements/plateau/rofi.bst` — Rofi build
- `elements/plateau/awww.bst` — Awww build
- `files/dconf/terrace-desktop` — dconf defaults
- `files/firstboot/` — Firstboot setup