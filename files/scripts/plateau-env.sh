#!/bin/bash
# Plateau desktop environment setup script

set -euo pipefail

# Set up Wayland environment variables
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Mango
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_DISPLAY=wl
export MOZ_ENABLE_WAYLAND=1
export GDK_BACKEND=wayland

# Set up Mango-specific
export MANGO_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mango"

# Set up Quickshell-specific
export QUICKSHELL_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"

# PipeWire
export PIPEWIRE_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

echo "Plateau environment variables set."