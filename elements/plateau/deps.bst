kind: stack

depends:
# Base FSDK runtime
- freedesktop-sdk.bst:runtime
- freedesktop-sdk.bst:platform

# Kernel
- core/linux-fdsdk.bst
(?):
- gaming == true:
  - core/linux-ogc.bst

# Core system
- freedesktop-sdk.bst:systemd
- freedesktop-sdk.bst:systemd-libs
- freedesktop-sdk.bst:flatpak
- freedesktop-sdk.bst:xdg-desktop-portal
- freedesktop-sdk.bst:xdg-desktop-portal-gtk
- freedesktop-sdk.bst:pipewire
- freedesktop-sdk.bst:wireplumber
- freedesktop-sdk.bst:libpipewire
- freedesktop-sdk.bst:polkit
- freedesktop-sdk.bst:dbus
- freedesktop-sdk.bst:dbus-broker
- freedesktop-sdk.bst:dbus-glib

# Graphics stack
- freedesktop-sdk.bst:mesa
- freedesktop-sdk.bst:vulkan-loader
- freedesktop-sdk.bst:spirv-tools
- freedesktop-sdk.bst:wayland
- freedesktop-sdk.bst:wayland-protocols
- freedesktop-sdk.bst:wlroots
- freedesktop-sdk.bst:xorg-server
- freedesktop-sdk.bst:xwayland
- freedesktop-sdk.bst:libdrm
- freedesktop-sdk.bst:libva
- freedesktop-sdk.bst:libvdpau

# Audio
- freedesktop-sdk.bst:pipewire
- freedesktop-sdk.bst:pipewire-alsa
- freedesktop-sdk.bst:pipewire-jack
- freedesktop-sdk.bst:pipewire-pulse
- freedesktop-sdk.bst:wireplumber
- freedesktop-sdk.bst:libpipewire
- freedesktop-sdk.bst:alsa-lib
- freedesktop-sdk.bst:alsa-utils
- freedesktop-sdk.bst:pulseaudio
- freedesktop-sdk.bst:pulseaudio-alsa

# Fonts and text
- freedesktop-sdk.bst:fontconfig
- freedesktop-sdk.bst:freetype
- freedesktop-sdk.bst:harfbuzz
- freedesktop-sdk.bst:pango
- freedesktop-sdk.bst:cairo
- freedesktop-sdk.bst:gdk-pixbuf
- freedesktop-sdk.bst:gtk3
- freedesktop-sdk.bst:gtk4
- freedesktop-sdk.bst:librsvg
- freedesktop-sdk.bst:graphene

# Input
- freedesktop-sdk.bst:libinput
- freedesktop-sdk.bst:libxkbcommon
- freedesktop-sdk.bst:xkeyboard-config

# Networking
- freedesktop-sdk.bst:networkmanager
- freedesktop-sdk.bst:openssh
- freedesktop-sdk.bst:openssl
- freedesktop-sdk.bst:gnutls
- freedesktop-sdk.bst:ca-certificates

# Utilities
- freedesktop-sdk.bst:bash
- freedesktop-sdk.bst:coreutils
- freedesktop-sdk.bst:util-linux
- freedesktop-sdk.bst:findutils
- freedesktop-sdk.bst:grep
- freedesktop-sdk.bst:sed
- freedesktop-sdk.bst:gawk
- freedesktop-sdk.bst:which
- freedesktop-sdk.bst:less
- freedesktop-sdk.bst:vim
- freedesktop-sdk.bst:nano
- freedesktop-sdk.bst:sudo
- freedesktop-sdk.bst:shadow
- freedesktop-sdk.bst:passwd

# File systems
- freedesktop-sdk.bst:e2fsprogs
- freedesktop-sdk.bst:dosfstools
- freedesktop-sdk.bst:ntfs-3g
- freedesktop-sdk.bst:btrfs-progs
- freedesktop-sdk.bst:xfsprogs

# Archive
- freedesktop-sdk.bst:tar
- freedesktop-sdk.bst:gzip
- freedesktop-sdk.bst:bzip2
- freedesktop-sdk.bst:xz
- freedesktop-sdk.bst:zstd
- freedesktop-sdk.bst:unzip

# Development
- freedesktop-sdk.bst:git
- freedesktop-sdk.bst:meson
- freedesktop-sdk.bst:ninja
- freedesktop-sdk.bst:pkg-config
- freedesktop-sdk.bst:python3
- freedesktop-sdk.bst:rust
- freedesktop-sdk.bst:cargo
- freedesktop-sdk.bst:go

# Container tools
- freedesktop-sdk.bst:podman
- freedesktop-sdk.bst:buildah
- freedesktop-sdk.bst:skopeo
- freedesktop-sdk.bst:crun
- freedesktop-sdk.bst:runc

# Desktop specific
- plateau/mango.bst
- plateau/quickshell.bst
- plateau/rofi.bst
- plateau/awww.bst
- plateau/pipewire.bst
- plateau/wlclipboard.bst
- plateau/desktop-base.bst

# Terminal
- freedesktop-sdk.bst:foot

# File manager
- freedesktop-sdk.bst:thunar

# Browser
- freedesktop-sdk.bst:firefox

# Additional desktop tools
- freedesktop-sdk.bst:grim
- freedesktop-sdk.bst:slurp
- freedesktop-sdk.bst:wl-clipboard
- freedesktop-sdk.bst:waybar
- freedesktop-sdk.bst:wofi
- freedesktop-sdk.bst:bemenu
- freedesktop-sdk.bst:mako
- freedesktop-sdk.bst:swaylock
- freedesktop-sdk.bst:swayidle
- freedesktop-sdk.bst:xdg-desktop-portal-wlr