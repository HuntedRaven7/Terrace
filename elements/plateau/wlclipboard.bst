kind: manual

sources:
- kind: git_repo
  url: https://github.com/bugaevc/wl-clipboard.git
  track: v2.2.1
  ref: v2.2.1

depends:
- freedesktop-sdk.bst:wayland
- freedesktop-sdk.bst:meson
- freedesktop-sdk.bst:ninja

config:
  build-commands:
  - meson setup build --prefix=/usr -Ddefault_library=shared
  - ninja -C build
  install-commands:
  - DESTDIR="${DESTDIR}" ninja -C build install