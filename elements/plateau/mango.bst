kind: manual

sources:
- kind: git_repo
  url: https://github.com/mangowm/mango.git
  track: v0.17.2
  ref: v0.17.2

depends:
- freedesktop-sdk.bst:wayland
- freedesktop-sdk.bst:wayland-protocols
- freedesktop-sdk.bst:wlroots
- freedesktop-sdk.bst:mesa
- freedesktop-sdk.bst:libinput
- freedesktop-sdk.bst:libxkbcommon
- freedesktop-sdk.bst:pango
- freedesktop-sdk.bst:cairo
- freedesktop-sdk.bst:gdk-pixbuf
- freedesktop-sdk.bst:gtk3
- freedesktop-sdk.bst:json-c
- freedesktop-sdk.bst:libevdev
- freedesktop-sdk.bst:libdisplay-info
- freedesktop-sdk.bst:seatd
- freedesktop-sdk.bst:systemd
- freedesktop-sdk.bst:scdoc

config:
  environment:
    CGO_ENABLED: "0"
  build-commands:
  - meson setup build --prefix=/usr -Ddefault_library=shared -Dman-pages=enabled
  - ninja -C build
  install-commands:
  - DESTDIR="${DESTDIR}" ninja -C build install