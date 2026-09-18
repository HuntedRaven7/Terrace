kind: manual

sources:
- kind: url
  url: https://codeberg.org/LGFae/awww/archive/v0.12.1.tar.gz
  sha256: sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
  # Note: Actual sha256 needs to be filled in after download

depends:
- freedesktop-sdk.bst:rust
- freedesktop-sdk.bst:cargo
- freedesktop-sdk.bst:wayland
- freedesktop-sdk.bst:wayland-protocols
- freedesktop-sdk.bst:wlroots
- freedesktop-sdk.bst:mesa
- freedesktop-sdk.bst:libinput
- freedesktop-sdk.bst:libxkbcommon
- freedesktop-sdk.bst:gtk3
- freedesktop-sdk.bst:libadwaita
- freedesktop-sdk.bst:librsvg
- freedesktop-sdk.bst:json-glib

config:
  environment:
    CGO_ENABLED: "0"
    CARGO_HOME: "${DESTDIR}/.cargo"
  build-commands:
  - cargo build --release --locked
  install-commands:
  - mkdir -p ${DESTDIR}/usr/bin
  - cp target/release/awww ${DESTDIR}/usr/bin/
  - mkdir -p ${DESTDIR}/usr/share/applications
  - cp data/awww.desktop ${DESTDIR}/usr/share/applications/
  - mkdir -p ${DESTDIR}/usr/share/metainfo
  - cp data/awww.metainfo.xml ${DESTDIR}/usr/share/metainfo/