kind: manual

sources:
- kind: git_repo
  url: https://github.com/davatorium/rofi.git
  track: 1.7.5
  ref: 1.7.5

depends:
- freedesktop-sdk.bst:glib
- freedesktop-sdk.bst:cairo
- freedesktop-sdk.bst:pango
- freedesktop-sdk.bst:librsvg
- freedesktop-sdk.bst:gdk-pixbuf
- freedesktop-sdk.bst:gtk3
- freedesktop-sdk.bst:libxkbcommon
- freedesktop-sdk.bst:xcb-util
- freedesktop-sdk.bst:xcb-util-wm
- freedesktop-sdk.bst:xcb-util-xrm
- freedesktop-sdk.bst:startup-notification
- freedesktop-sdk.bst:libev
- freedesktop-sdk.bst:libx11
- freedesktop-sdk.bst:libxinerama
- freedesktop-sdk.bst:libxrandr
- freedesktop-sdk.bst:libxrender
- freedesktop-sdk.bst:meson
- freedesktop-sdk.bst:ninja

config:
  build-commands:
  - meson setup build --prefix=/usr -Ddefault_library=shared -Dcheck=enabled -Dman-pages=enabled
  - ninja -C build
  install-commands:
  - DESTDIR="${DESTDIR}" ninja -C build install