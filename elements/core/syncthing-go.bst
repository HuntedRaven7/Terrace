kind: manual

sources:
- kind: go_module
  url: https://github.com/syncthing/syncthing
  version: v1.27.7
  modules:
  - name: github.com/syncthing/syncthing
    sum: h1:XJZq5+XZq5+XZq5+XZq5+XZq5+XZq5+XZq5+XZq5+XZQ=

depends:
- freedesktop-sdk.bst:go

config:
  environment:
    CGO_ENABLED: "0"
    GOFLAGS: "-trimpath -buildvcs=false"
  install-commands:
  - mkdir -p ${DESTDIR}/usr/bin
  - go build -o ${DESTDIR}/usr/bin/syncthing -ldflags="-X github.com/syncthing/syncthing/lib/build.Version=v1.27.7" ./cmd/syncthing