kind: manual

depends:
- freedesktop-sdk.bst:wayland
- freedesktop-sdk.bst:wayland-protocols
- freedesktop-sdk.bst:wlroots
- freedesktop-sdk.bst:mesa
- freedesktop-sdk.bst:libinput
- freedesktop-sdk.bst:libxkbcommon
- freedesktop-sdk.bst:systemd
- freedesktop-sdk.bst:dbus
- freedesktop-sdk.bst:polkit
- freedesktop-sdk.bst:xdg-desktop-portal
- freedesktop-sdk.bst:xdg-desktop-portal-gtk
- freedesktop-sdk.bst:xdg-desktop-portal-wlr
- freedesktop-sdk.bst:gtk3
- freedesktop-sdk.bst:gtk4
- freedesktop-sdk.bst:gsettings-desktop-schemas
- freedesktop-sdk.bst:glib

sources:
- kind: git_repo
  url: https://github.com/huntedraven7/terrace-files.git
  track: main
  ref: main
  # This would be a separate repo for Terrace-specific files
  # For now, we'll create the files locally

config:
  install-commands:
  - mkdir -p ${DESTDIR}/usr/share/wayland-sessions
  - cat > ${DESTDIR}/usr/share/wayland-sessions/mango.desktop << 'EOF'
[Desktop Entry]
Name=Mango
Comment=Mango Window Manager
Exec=mango
Type=Application
DesktopNames=Mango
EOF

  - cat > ${DESTDIR}/usr/share/wayland-sessions/quickshell.desktop << 'EOF'
[Desktop Entry]
Name=Quickshell
Comment=Quickshell Desktop
Exec=quickshell
Type=Application
DesktopNames=Quickshell
EOF

  - mkdir -p ${DESTDIR}/etc/xdg/autostart
  - cat > ${DESTDIR}/etc/xdg/autostart/pipewire.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=PipeWire
Exec=pipewire
OnlyShowIn=Mango;Quickshell;
EOF

  - cat > ${DESTDIR}/etc/xdg/autostart/wireplumber.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=WirePlumber
Exec=wireplumber
OnlyShowIn=Mango;Quickshell;
EOF

  - mkdir -p ${DESTDIR}/usr/share/glib-2.0/schemas
  - cat > ${DESTDIR}/usr/share/glib-2.0/schemas/99-terrace-desktop.gschema.override << 'EOF'
[org.gnome.desktop.interface]
gtk-theme='Adwaita-dark'
icon-theme='Adwaita'
cursor-theme='Adwaita'
font-name='JetBrains Mono 10'
monospace-font-name='JetBrains Mono 10'
document-font-name='Sans 10'

[org.gnome.desktop.peripherals.keyboard]
repeat=true
repeat-interval=30
delay=250

[org.gnome.desktop.peripherals.mouse]
accel-profile='flat'
speed=0.0

[org.gnome.desktop.wm.preferences]
focus-mode='click'
titlebar-font='JetBrains Mono Bold 10'
EOF

  - mkdir -p ${DESTDIR}/etc/dconf/db/local.d
  - cat > ${DESTDIR}/etc/dconf/db/local.d/99-terrace-desktop << 'EOF'
[org/gnome/desktop/interface]
gtk-theme='Adwaita-dark'
icon-theme='Adwaita'
cursor-theme='Adwaita'
font-name='JetBrains Mono 10'
monospace-font-name='JetBrains Mono 10'

[org/gnome/desktop/wm/preferences]
focus-mode='click'
titlebar-font='JetBrains Mono Bold 10'
EOF