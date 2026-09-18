# Terrace Packaging Skill

## Overview

This skill covers native package building in BuildStream for the Terrace project: Go, Rust, C/C++, Python, and binary packaging.

All packages in Terrace are built from source via BuildStream elements — no binary package installation from external repositories.

## Language-Specific Patterns

### Go (cargo2 equivalent: go_module)
```yaml
sources:
- kind: go_module
  url: https://github.com/example/project
  version: v1.0.0
  modules:
  - name: github.com/example/project
    sum: h1:...

depends:
- freedesktop-sdk.bst:go

config:
  environment:
    CGO_ENABLED: "0"
    GOFLAGS: "-trimpath -buildvcs=false"
  build-commands:
  - go build -o project -ldflags="-X main.version=v1.0.0" ./cmd/project
  install-commands:
  - mkdir -p ${DESTDIR}/usr/bin
  - cp project ${DESTDIR}/usr/bin/
```

### Rust (cargo2)
```yaml
sources:
- kind: cargo2
  url: https://github.com/example/project
  version: v1.0.0
  Cargo.lock: project.lock

depends:
- freedesktop-sdk.bst:rust
- freedesktop-sdk.bst:cargo

config:
  environment:
    CARGO_HOME: "${DESTDIR}/.cargo"
  build-commands:
  - cargo build --release --locked
  install-commands:
  - mkdir -p ${DESTDIR}/usr/bin
  - cp target/release/project ${DESTDIR}/usr/bin/
```

### C/C++ (meson/autotools/cmake)
```yaml
# Meson (preferred)
sources:
- kind: git_repo
  url: https://github.com/example/project
  track: 1.0
  ref: 1.0.0

depends:
- freedesktop-sdk.bst:meson
- freedesktop-sdk.bst:ninja
- freedesktop-sdk.bst:pkg-config

config:
  build-commands:
  - meson setup build --prefix=/usr -Ddefault_library=shared
  - ninja -C build
  install-commands:
  - DESTDIR="${DESTDIR}" ninja -C build install
```

### Python (pyproject)
```yaml
sources:
- kind: pyproject
  url: https://github.com/example/project
  version: 1.0.0

depends:
- freedesktop-sdk.bst:python3
- freedesktop-sdk.bst:python3-pip

config:
  install-commands:
  - pip install --prefix=/usr --root=${DESTDIR} .
```

## Terrace-Specific Packages

### Mango WM (C, meson)
```yaml
# elements/plateau/mango.bst
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
```

### Quickshell (C++, cmake, Qt6)
```yaml
# elements/plateau/quickshell.bst
sources:
- kind: git_repo
  url: https://github.com/quickshell-mirror/quickshell.git
  track: v0.3.1
  ref: v0.3.1

depends:
- freedesktop-sdk.bst:qt6-qtbase
- freedesktop-sdk.bst:qt6-qtdeclarative
- freedesktop-sdk.bst:qt6-qtwayland
- freedesktop-sdk.bst:qt6-qtsvg
- freedesktop-sdk.bst:qt6-qttools
- freedesktop-sdk.bst:wayland
- freedesktop-sdk.bst:wlroots
- freedesktop-sdk.bst:fmt
- freedesktop-sdk.bst:spdlog
- freedesktop-sdk.bst:nlohmann-json
- freedesktop-sdk.bst:tomlplusplus
```

### Awww (Rust, cargo)
```yaml
# elements/plateau/awww.bst
sources:
- kind: url
  url: https://codeberg.org/LGFae/awww/archive/v0.12.1.tar.gz
  sha256: ...

depends:
- freedesktop-sdk.bst:rust
- freedesktop-sdk.bst:cargo
- freedesktop-sdk.bst:wayland
- freedesktop-sdk.bst:wlroots
- freedesktop-sdk.bst:gtk3
- freedesktop-sdk.bst:libadwaita
```

### k0s (Go)
```yaml
# elements/strata/k0s-sysext.bst
sources:
- kind: git_repo
  url: https://github.com/k0sproject/k0s.git
  track: v1.30.0
  ref: v1.30.0

depends:
- freedesktop-sdk.bst:go
- freedesktop-sdk.bst:make
```

## Cargo Source Generation
For complex Rust projects, generate cargo sources:
```bash
python3 files/scripts/generate_cargo_sources.py Cargo.lock
```

## Binary Packages
For prebuilt binaries (rare, avoid when possible):
```yaml
kind: manual
sources:
- kind: url
  url: https://example.com/project.tar.gz
  sha256: ...
config:
  install-commands:
  - mkdir -p ${DESTDIR}/usr/bin
  - cp project ${DESTDIR}/usr/bin/
```

## Anti-patterns (DO NOT)
- ❌ Use `dnf install` in elements
- ❌ Download binaries without sha256 verification
- ❌ Use mutable version refs (branches, `latest`)
- ❌ Skip dependency declaration
- ❌ Network access in build commands

## Related Files
- `elements/plateau/mango.bst`
- `elements/plateau/quickshell.bst`
- `elements/plateau/awww.bst`
- `elements/strata/k0s-sysext.bst`
- `elements/strata/kubestellar.bst`
- `files/scripts/generate_cargo_sources.py` (if needed)