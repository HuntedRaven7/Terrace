kind: manual

sources:
- kind: git_repo
  url: https://github.com/projectbluefin/chunkah.git
  track: main
  ref: main

depends:
- freedesktop-sdk.bst:rust
- freedesktop-sdk.bst:cargo
- freedesktop-sdk.bst:openssl
- freedesktop-sdk.bst:pkg-config

config:
  environment:
    CGO_ENABLED: "0"
    CARGO_HOME: "${DESTDIR}/.cargo"
  build-commands:
  - cargo build --release --locked --bin chunkah-metadata-tool
  install-commands:
  - mkdir -p ${DESTDIR}/usr/bin
  - cp target/release/chunkah-metadata-tool ${DESTDIR}/usr/bin/